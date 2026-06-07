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
│  companies   │       │  job_listings     │
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
│ country_code │       │ companies_with_open_jobs  │
│ expertises   │       │ (VIEW)                   │
│ ...          │       ├──────────────────────────┤
└──────────────┘       │ id                       │
                       │ company_name             │
                       │ logo_url                 │
                       │ open_jobs_count (COUNT)   │
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
