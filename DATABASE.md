# Job Finder — Database Schema (Supabase)

This document contains all SQL scripts needed to set up the Supabase database for the Job Finder project. Run each section **in order** in the Supabase SQL Editor.

---

## Table of Contents

1. [Profiles table](#1-profiles-table-and-rls-policies)
2. [Auto-create profile trigger](#2-auto-create-profile-on-user-signup-trigger)
3. [Avatars Storage bucket](#3-avatars-storage-bucket)
4. [Companies table](#4-companies-table)
5. [Job Listings table](#5-job-listings-table)
6. [Companies with open jobs (VIEW)](#6-view-companies-with-open-jobs)
7. [Seed data](#7-seed-data)
8. [Notifications table](#8-notifications-table-and-rls-policies)
9. [Bookmarks table](#9-bookmarks-table-and-rls-policies)
10. [Interviews table](#10-interviews-table-and-rls-policies)
11. [Conversations & Messages tables](#11-conversations--messages-tables-and-rls-policies)

---

## 1. Profiles table and RLS policies

```sql
-- Create the 'profiles' table
CREATE TABLE public.profiles (
  id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  country_code TEXT,
  expertises TEXT[],
  official_accounts TEXT[],
  full_name TEXT,
  username TEXT UNIQUE,
  bio TEXT,
  avatar_url TEXT,
  setup_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id)
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Allow users to insert their own profile
CREATE POLICY "Users can insert their own profile."
ON public.profiles FOR INSERT
WITH CHECK ( auth.uid() = id );

-- Allow users to update ONLY their own profile
CREATE POLICY "Users can update their own profile."
ON public.profiles FOR UPDATE
USING ( auth.uid() = id );

-- Allow any authenticated user to view profiles
CREATE POLICY "Profiles are viewable by everyone."
ON public.profiles FOR SELECT
USING ( true );
```

---

## 2. Auto-create profile on user signup (Trigger)

Automatically creates an empty profile row whenever a new user signs up in `auth.users`.

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, setup_completed)
  VALUES (new.id, FALSE);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
```

---

## 3. Avatars Storage bucket

1. Go to **Storage** in your Supabase Dashboard
2. Click **"New bucket"**
3. Set the name to `avatars`
4. Enable **"Public bucket"** (allows public read access via URL)
5. Click **"Create bucket"**

Then run the following RLS policies:

```sql
-- Allow authenticated users to upload their own avatar
CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow authenticated users to update (overwrite) their own avatar
CREATE POLICY "Users can update their own avatar"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow anyone to view avatars (public bucket)
CREATE POLICY "Anyone can view avatars"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'avatars');
```

> **Note:** Each user's avatar is stored at the path `{user_id}/avatar.{ext}` with `upsert: true`, so uploading a new image automatically replaces the previous one.

---

## 4. Companies table

Stores company information. The "Hot Vacancies" section in the Home screen reads from here.

```sql
CREATE TABLE public.companies (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  name TEXT NOT NULL,
  logo_url TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id)
);

ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

-- Any authenticated user can read active companies
CREATE POLICY "Active companies are viewable by authenticated users."
ON public.companies FOR SELECT
TO authenticated
USING (is_active = TRUE);
```

---

## 5. Job Listings table

Central table for **all** job proposals. Both "Best Matches" and "Most Recent" sections read from this table with different filters/ordering.

```sql
CREATE TABLE public.job_listings (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  job_title TEXT NOT NULL,
  location TEXT NOT NULL,
  salary TEXT NOT NULL,
  description TEXT,
  work_mode TEXT NOT NULL DEFAULT 'on-site',
  job_type TEXT NOT NULL DEFAULT 'full-time',
  tags TEXT[] NOT NULL DEFAULT '{}',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  posted_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id),
  CONSTRAINT valid_work_mode CHECK (work_mode IN ('remote', 'hybrid', 'on-site')),
  CONSTRAINT valid_job_type CHECK (job_type IN ('full-time', 'part-time', 'contract'))
);

-- Indexes for common query patterns
CREATE INDEX idx_job_listings_job_type ON public.job_listings(job_type);
CREATE INDEX idx_job_listings_posted_at ON public.job_listings(posted_at DESC);
CREATE INDEX idx_job_listings_company_id ON public.job_listings(company_id);

ALTER TABLE public.job_listings ENABLE ROW LEVEL SECURITY;

-- Any authenticated user can read active job listings
CREATE POLICY "Active job listings are viewable by authenticated users."
ON public.job_listings FOR SELECT
TO authenticated
USING (is_active = TRUE);
```

### Column reference

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Auto-generated primary key |
| `company_id` | UUID | FK → `companies.id` |
| `job_title` | TEXT | Position name (e.g. "Senior Product Designer") |
| `location` | TEXT | Job location (e.g. "San Francisco, CA") |
| `salary` | TEXT | Salary range or rate (e.g. "$120k - $140k") |
| `description` | TEXT | Job description (nullable for listings without one) |
| `work_mode` | TEXT | `remote`, `hybrid`, or `on-site` |
| `job_type` | TEXT | `full-time`, `part-time`, or `contract` |
| `tags` | TEXT[] | Display tags (e.g. `['Remote', 'Full-time']`) |
| `is_active` | BOOLEAN | Soft-delete flag — RLS only shows active listings |
| `posted_at` | TIMESTAMPTZ | When the job was posted (for ordering) |
| `created_at` | TIMESTAMPTZ | Row creation timestamp |

### Constraint reference

| Constraint | Values |
|------------|--------|
| `valid_work_mode` | `remote`, `hybrid`, `on-site` |
| `valid_job_type` | `full-time`, `part-time`, `contract` |

---

## 6. VIEW: Companies with open jobs

Used by the **"Hot Vacancies"** section. Returns companies that have at least one active job listing, ordered by number of open positions. The `open_jobs_count` is calculated dynamically — no need to update it manually.

```sql
CREATE VIEW public.companies_with_open_jobs AS
SELECT
  c.id,
  c.name AS company_name,
  c.logo_url,
  COUNT(jl.id)::INTEGER AS open_jobs_count
FROM public.companies c
INNER JOIN public.job_listings jl
  ON jl.company_id = c.id
  AND jl.is_active = TRUE
WHERE c.is_active = TRUE
GROUP BY c.id, c.name, c.logo_url
HAVING COUNT(jl.id) > 0
ORDER BY open_jobs_count DESC;
```

---

## 7. Seed data

Sample data that matches the current mock data used in the app.

### Companies

```sql
INSERT INTO public.companies (id, name, logo_url) VALUES
  ('a1b2c3d4-0001-4000-8000-000000000001', 'Stripe',    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQGluJhW7I1NYU7jF77E-9K9I46_ib_DUNHw&s'),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'Shopify',   'https://cdn-icons-png.flaticon.com/128/5968/5968919.png'),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'Meta',      'https://cdn-icons-png.flaticon.com/128/6033/6033716.png'),
  ('a1b2c3d4-0004-4000-8000-000000000004', 'Pinterest', 'https://cdn-icons-png.flaticon.com/512/145/145808.png'),
  ('a1b2c3d4-0005-4000-8000-000000000005', 'Figma',     'https://cdn-icons-png.flaticon.com/128/5968/5968705.png'),
  ('a1b2c3d4-0006-4000-8000-000000000006', 'Webflow',   'https://cdn-icons-png.flaticon.com/128/5968/5968672.png');
```

### Job Listings

```sql
INSERT INTO public.job_listings (company_id, job_title, location, salary, description, work_mode, job_type, tags, posted_at) VALUES
  -- Stripe (3 jobs)
  ('a1b2c3d4-0001-4000-8000-000000000001', 'Senior Product Designer', 'San Francisco, CA',      '$120k - $140k', 'Join our design team to shape the future of online payments and financial infrastructure.',                         'remote',  'full-time', ARRAY['Remote', 'Full-time'],              now() - interval '2 days'),
  ('a1b2c3d4-0001-4000-8000-000000000001', 'Frontend Developer',      'San Francisco, CA',      '$130k - $155k', 'Join our team to build the next generation of payment infrastructure used by millions of businesses worldwide.',    'remote',  'full-time', ARRAY['Remote', 'Full-time', 'Engineering'], now() - interval '1 day'),
  ('a1b2c3d4-0001-4000-8000-000000000001', 'Backend Engineer',        'San Francisco, CA',      '$150k - $180k', 'Build scalable distributed systems that process billions in payments.',                                              'hybrid',  'full-time', ARRAY['Hybrid', 'Full-time'],              now() - interval '3 days'),

  -- Shopify (2 jobs)
  ('a1b2c3d4-0002-4000-8000-000000000002', 'Flutter Developer',       'Toronto, Canada',        '$90k - $110k',  'Build beautiful cross-platform e-commerce experiences with Flutter.',                                               'hybrid',  'full-time', ARRAY['Hybrid', 'Full-time'],              now() - interval '1 day'),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'Data Analyst',            'Toronto, Canada',        '$80k - $95k',   'Analyze merchant data to drive product decisions.',                                                                'remote',  'part-time', ARRAY['Remote', 'Part-time'],              now() - interval '4 days'),

  -- Meta (3 jobs)
  ('a1b2c3d4-0003-4000-8000-000000000003', 'UX Researcher',           'Menlo Park, CA',         '$130k - $160k', 'Conduct user research to inform product strategy across the Meta family of apps.',                                  'on-site', 'full-time', ARRAY['On-site', 'Full-time'],             now() - interval '5 hours'),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'Project Manager',         'California, United States', '$110k - $130k', 'Lead cross-functional teams to deliver products on time and within scope.',                                      'remote',  'full-time', ARRAY['Remote', 'Full-time'],              now() - interval '6 hours'),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'iOS Engineer',            'Menlo Park, CA',         '$140k - $170k', 'Work on Instagram and WhatsApp mobile experiences.',                                                               'on-site', 'full-time', ARRAY['On-site', 'Full-time'],             now() - interval '2 days'),

  -- Pinterest (2 jobs)
  ('a1b2c3d4-0004-4000-8000-000000000004', 'Mobile Engineer',         'Remote',                 '$100k - $125k', 'Build inspiring mobile experiences for hundreds of millions of users.',                                              'remote',  'contract',  ARRAY['Remote', 'Contract'],               now() - interval '5 days'),
  ('a1b2c3d4-0004-4000-8000-000000000004', 'UI Designer',             'New York, United States', '$85k - $100k', 'Create amazing user experiences for our mobile and web platforms.',                                                  'on-site', 'part-time', ARRAY['On-site', 'Part-time', 'Design'],  now() - interval '3 days'),

  -- Figma (1 job)
  ('a1b2c3d4-0005-4000-8000-000000000005', 'Visual Designer',         'Remote',                 '$45/hr',        'Design beautiful interfaces and illustrations for the Figma platform.',                                             'remote',  'part-time', ARRAY['Remote', 'Part-time'],              now() - interval '3 days'),

  -- Webflow (1 job)
  ('a1b2c3d4-0006-4000-8000-000000000006', 'Graphic Designer',        'California, United States', '$90k - $105k', 'Design marketing materials and product interfaces for the Webflow platform.',                                    'remote',  'full-time', ARRAY['Remote', 'Full-time', 'Design'],    now() - interval '2 days');
```

---

## Entity Relationship Diagram

```
┌──────────────┐       ┌──────────────────┐
│  companies   │       │  job_listings    │
├──────────────┤       ├──────────────────┤
│ id (PK)      │──┐    │ id (PK)          │
│ name         │  │    │ company_id (FK)  │◄─┘
│ logo_url     │  └───▶│ job_title        │
│ is_active    │       │ location         │
│ created_at   │       │ salary           │
└──────────────┘       │ description      │
                       │ work_mode        │
┌──────────────┐       │ job_type         │
│  profiles    │       │ tags             │
├──────────────┤       │ is_active        │
│ id (PK/FK)   │       │ posted_at        │
│ full_name    │       │ created_at       │
│ username     │       └──────────────────┘
│ bio          │
│ avatar_url   │       ┌──────────────────────────┐
│ country_code │       │ companies_with_open_jobs │
│ expertises   │       │ (VIEW)                   │
│ ...          │       ├──────────────────────────┤
└──────────────┘       │ id                       │
                       │ company_name             │
                       │ logo_url                 │
                       │ open_jobs_count (COUNT)  │
                       └──────────────────────────┘
```

## Query examples for the Home screen

```sql
-- Hot Vacancies (companies with job count)
SELECT * FROM companies_with_open_jobs;

-- Best Matches (all active jobs with company info)
SELECT
  jl.id, jl.job_title, jl.location, jl.salary, jl.description,
  jl.work_mode, jl.job_type, jl.tags, jl.posted_at,
  c.name AS company_name, c.logo_url AS company_logo_url
FROM job_listings jl
INNER JOIN companies c ON c.id = jl.company_id
WHERE jl.is_active = TRUE
ORDER BY jl.posted_at DESC;

-- Best Matches filtered by job type (e.g. filter chips)
SELECT
  jl.id, jl.job_title, jl.location, jl.salary, jl.description,
  jl.work_mode, jl.job_type, jl.tags, jl.posted_at,
  c.name AS company_name, c.logo_url AS company_logo_url
FROM job_listings jl
INNER JOIN companies c ON c.id = jl.company_id
WHERE jl.is_active = TRUE
  AND jl.job_type = 'full-time'
ORDER BY jl.posted_at DESC;

-- Most Recent (latest 10 jobs)
SELECT
  jl.id, jl.job_title, jl.location, jl.salary, jl.description,
  jl.tags,
  c.name AS company_name, c.logo_url AS company_logo_url
FROM job_listings jl
INNER JOIN companies c ON c.id = jl.company_id
WHERE jl.is_active = TRUE
ORDER BY jl.posted_at DESC
LIMIT 10;
```

---

## 8. Notifications table and RLS policies

Stores user-specific notifications for the Notifications page.

```sql
CREATE TABLE public.notifications (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL DEFAULT 'general',
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  actor_name TEXT,
  actor_avatar_url TEXT,
  icon_emoji TEXT,
  target_route TEXT,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  read_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id)
);

CREATE INDEX idx_notifications_user_created_at
  ON public.notifications(user_id, created_at DESC);

CREATE INDEX idx_notifications_user_is_read
  ON public.notifications(user_id, is_read);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own notifications"
ON public.notifications FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications"
ON public.notifications FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
```

### Seed examples (ready to run)

```sql
INSERT INTO public.notifications (
  user_id,
  type,
  title,
  message,
  actor_name,
  actor_avatar_url,
  icon_emoji,
  target_route,
  created_at
) VALUES
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'networking',
    'Networking Opportunity',
    'Expand your network, Aaron. Join our virtual networking event tomorrow to connect with industry leaders.',
    'Aaron Stone',
    NULL,
    '🤝',
    '/notifications',
    now() - interval '2 hours'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'interview',
    'Interview Invitation',
    'Congratulations, Aaron. You have been invited to interview for the Web Developer position at Google.',
    NULL,
    NULL,
    '💻',
    '/interviews',
    now() - interval '4 hours'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'application',
    'Application Status Updated',
    'Good news, Aaron. Your application for Web Developer at Google has been received.',
    NULL,
    NULL,
    '🎉',
    '/notifications',
    now() - interval '1 day'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'system',
    'Profile Completion Reminder',
    'Complete your profile to increase visibility for recruiters and receive more relevant job matches.',
    NULL,
    NULL,
    '📝',
    '/account',
    now() - interval '26 hours'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'job_alert',
    'New Match: Senior Flutter Developer',
    'A new remote Flutter role was posted that matches your profile preferences.',
    'Recruiter Team',
    NULL,
    '🚀',
    '/search',
    now() - interval '3 days'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'interview',
    'Interview Confirmed',
    'Your interview with Meta has been confirmed for Monday at 10:30 AM. Please review the preparation checklist.',
    NULL,
    NULL,
    '✅',
    '/interviews',
    now() - interval '5 days'
  );
```

---

## 9. Bookmarks table and RLS policies

Stores user-saved (bookmarked) job listings. A user can bookmark a job to save it for later review.

```sql
CREATE TABLE public.bookmarks (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  job_listing_id UUID NOT NULL REFERENCES public.job_listings(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id),
  CONSTRAINT unique_user_bookmark UNIQUE (user_id, job_listing_id)
);

-- Index for fast lookups by user
CREATE INDEX idx_bookmarks_user_id ON public.bookmarks(user_id);

ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

-- Users can view only their own bookmarks
CREATE POLICY "Users can view their own bookmarks"
ON public.bookmarks FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Users can insert their own bookmarks
CREATE POLICY "Users can insert their own bookmarks"
ON public.bookmarks FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Users can delete their own bookmarks
CREATE POLICY "Users can delete their own bookmarks"
ON public.bookmarks FOR DELETE
TO authenticated
USING (auth.uid() = user_id);
```

### Column reference

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Auto-generated primary key |
| `user_id` | UUID | FK → `auth.users.id` — the user who bookmarked |
| `job_listing_id` | UUID | FK → `job_listings.id` — the bookmarked job |
| `created_at` | TIMESTAMPTZ | When the bookmark was created |

### Constraint reference

| Constraint | Description |
|------------|-------------|
| `unique_user_bookmark` | Prevents a user from bookmarking the same job twice |

---

## 10. Interviews table and RLS policies

Stores the user's scheduled interviews shown in the Interviews page. The
"Ongoing" and "History" tabs read from this table filtered by `status`.

```sql
CREATE TABLE public.interviews (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role_title TEXT NOT NULL,
  company_name TEXT NOT NULL,
  company_logo_url TEXT NOT NULL,
  scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
  media TEXT NOT NULL DEFAULT 'Google Meet',
  meeting_url TEXT,
  status TEXT NOT NULL DEFAULT 'ongoing',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id),
  CONSTRAINT valid_interview_status CHECK (status IN ('ongoing', 'history'))
);

-- Index for the common query (user's interviews ordered by schedule date)
CREATE INDEX idx_interviews_user_scheduled_at
  ON public.interviews(user_id, scheduled_at DESC);

ALTER TABLE public.interviews ENABLE ROW LEVEL SECURITY;

-- Users can view only their own interviews
CREATE POLICY "Users can view their own interviews"
ON public.interviews FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Users can insert their own interviews
CREATE POLICY "Users can insert their own interviews"
ON public.interviews FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Users can update their own interviews
CREATE POLICY "Users can update their own interviews"
ON public.interviews FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
```

### Column reference

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Auto-generated primary key |
| `user_id` | UUID | FK → `auth.users.id` — the interview owner |
| `role_title` | TEXT | Position being interviewed for (e.g. "User Interface Designer") |
| `company_name` | TEXT | Company name (e.g. "Pinterest") |
| `company_logo_url` | TEXT | Company logo URL |
| `scheduled_at` | TIMESTAMPTZ | Interview date and time |
| `media` | TEXT | Meeting media (e.g. "Google Meet", "Zoom") |
| `meeting_url` | TEXT | Meeting join link (nullable) — opened by "Click to Join" |
| `status` | TEXT | `ongoing` (upcoming) or `history` (past) |
| `created_at` | TIMESTAMPTZ | Row creation timestamp |

### Constraint reference

| Constraint | Values |
|------------|--------|
| `valid_interview_status` | `ongoing`, `history` |

### Seed examples (ready to run)

> Replace the `user_id` with a real `auth.users.id` from your project.

```sql
INSERT INTO public.interviews (
  user_id, role_title, company_name, company_logo_url, scheduled_at, media, meeting_url, status
) VALUES
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'User Interface Designer', 'Pinterest',
    'https://cdn-icons-png.flaticon.com/512/145/145808.png',
    now() + interval '2 days', 'Google Meet', 'https://meet.google.com/abc-defg-hij', 'ongoing'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'Graphic Designer', 'Webflow',
    'https://cdn-icons-png.flaticon.com/128/5968/5968672.png',
    now() + interval '3 days', 'Google Meet', 'https://meet.google.com/klm-nopq-rst', 'ongoing'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'Product Designer', 'Meta',
    'https://cdn-icons-png.flaticon.com/128/6033/6033716.png',
    now() - interval '10 days', 'Zoom', NULL, 'history'
  ),
  (
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'Frontend Developer', 'Shopify',
    'https://cdn-icons-png.flaticon.com/128/5968/5968919.png',
    now() - interval '20 days', 'Google Meet', NULL, 'history'
  );
```

---

## 11. Conversations & Messages tables and RLS policies

Powers the Inbox (message list) and the Chat details screen. A `conversation`
is a thread between the current user and a contact; `messages` holds the
individual chat bubbles.

```sql
-- ===== Conversations =====
CREATE TABLE public.conversations (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  contact_name TEXT NOT NULL,
  contact_avatar_url TEXT NOT NULL,
  last_message TEXT,
  last_message_at TIMESTAMP WITH TIME ZONE,
  unread_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id)
);

CREATE INDEX idx_conversations_user_last_message_at
  ON public.conversations(user_id, last_message_at DESC);

ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own conversations"
ON public.conversations FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own conversations"
ON public.conversations FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own conversations"
ON public.conversations FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- ===== Messages =====
CREATE TABLE public.messages (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  is_mine BOOLEAN NOT NULL DEFAULT TRUE,
  body TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

  PRIMARY KEY (id)
);

CREATE INDEX idx_messages_conversation_created_at
  ON public.messages(conversation_id, created_at ASC);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own messages"
ON public.messages FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own messages"
ON public.messages FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);
```

### Trigger: keep the conversation preview in sync

Whenever a message is inserted, update the parent conversation's
`last_message` / `last_message_at` automatically.

```sql
CREATE OR REPLACE FUNCTION public.handle_new_message()
RETURNS trigger AS $$
BEGIN
  UPDATE public.conversations
  SET last_message = NEW.body,
      last_message_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_message_created
  AFTER INSERT ON public.messages
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_message();
```

### Column reference — conversations

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Auto-generated primary key |
| `user_id` | UUID | FK → `auth.users.id` — inbox owner |
| `contact_name` | TEXT | Name of the other participant |
| `contact_avatar_url` | TEXT | Avatar of the other participant |
| `last_message` | TEXT | Preview of the latest message (kept by trigger) |
| `last_message_at` | TIMESTAMPTZ | Timestamp of the latest message (ordering) |
| `unread_count` | INTEGER | Unread messages counter |
| `created_at` | TIMESTAMPTZ | Row creation timestamp |

### Column reference — messages

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Auto-generated primary key |
| `conversation_id` | UUID | FK → `conversations.id` |
| `user_id` | UUID | FK → `auth.users.id` — owner (for RLS) |
| `is_mine` | BOOLEAN | `true` when sent by the current user |
| `body` | TEXT | Message text |
| `created_at` | TIMESTAMPTZ | When the message was sent |

### Seed examples (ready to run)

> Replace the `user_id` with a real `auth.users.id` from your project.

```sql
-- Conversations
INSERT INTO public.conversations (
  id, user_id, contact_name, contact_avatar_url, last_message, last_message_at, unread_count
) VALUES
  (
    'b2c3d4e5-0001-4000-8000-000000000001',
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'Olivia Bennett', 'https://i.pravatar.cc/150?img=5',
    'Lorem Ipsum is simply dummy text of the printing.', now() - interval '1 hour', 2
  ),
  (
    'b2c3d4e5-0002-4000-8000-000000000002',
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'William Parker', 'https://i.pravatar.cc/150?img=12',
    'The Sr. Java Developer position is a great opportunity.', now() - interval '2 hours', 2
  ),
  (
    'b2c3d4e5-0003-4000-8000-000000000003',
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba',
    'Noah Henderson', 'https://i.pravatar.cc/150?img=33',
    'Lorem Ipsum is simply dummy text.', now() - interval '1 day', 0
  );

-- Messages for the William Parker conversation
INSERT INTO public.messages (conversation_id, user_id, is_mine, body, created_at) VALUES
  (
    'b2c3d4e5-0002-4000-8000-000000000002',
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba', TRUE,
    'Hi! I recently came across the Sr. Java Developer position at Netflix on your profile, and I''m really interested. Could you share more details about the role and what qualifications you''re looking for?',
    now() - interval '2 hours 5 minutes'
  ),
  (
    'b2c3d4e5-0002-4000-8000-000000000002',
    'a1314df4-9f26-4c7c-8dcb-487a74fc4fba', FALSE,
    'Hi John Doe! Thanks for reaching out. The Sr. Java Developer position at Netflix is a great opportunity. We''re looking for someone with experience in java programming, and ideally someone who has worked in entertainment. Could you tell me a little about your background?',
    now() - interval '2 hours'
  );
```
