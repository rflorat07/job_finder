# 🎉 Welcome to Job Finder!

## What's inside
- Opinionated theme with Material 3
- Onboarding presentation starter
- Routing scaffold using `go_router`
- State: riverpod
- Backend: Supabase

## Database Setup (Supabase)

This project uses Supabase for the backend. To set up the database and authentication correctly, you must run the following SQL scripts in your Supabase SQL Editor.

### 1. Create the `profiles` table and RLS policies
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
  setup_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  
  PRIMARY KEY (id)
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- A. Allow users to insert their own profile
CREATE POLICY "Users can insert their own profile." 
ON public.profiles FOR INSERT 
WITH CHECK ( auth.uid() = id );

-- B. Allow users to update ONLY their own profile
CREATE POLICY "Users can update their own profile." 
ON public.profiles FOR UPDATE 
USING ( auth.uid() = id );

-- C. Allow any authenticated user to view profiles
CREATE POLICY "Profiles are viewable by everyone." 
ON public.profiles FOR SELECT 
USING ( true );
```

### 2. Auto-create profile on user signup (Trigger)
Run this to automatically create an empty profile row whenever a new user signs up in the `auth.users` table:

```sql
-- Create a function that inserts a row into 'profiles' upon signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, setup_completed)
  VALUES (new.id, FALSE);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a trigger that calls the function whenever someone signs up
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
```

## Getting started
```bash
flutter pub get
flutter run
```