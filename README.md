# Offline Todo App

Simple example app on how you can use [Hydrated Bloc](https://pub.dev/packages/hydrated_bloc) with Supabase to create an app with offline caching ability.

![Screenshot](https://raw.githubusercontent.com/dshukertjr/supabase-offline-todo/main/screenshot.png "App running on iOS")

## Table definition

```sql
create table if not exists public.tasks (
    id uuid not null primary key DEFAULT uuid_generate_v4 (),
    title text not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
```