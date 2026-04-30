/*
  # Create audit_requests table

  1. New Tables
    - `audit_requests`
      - `id` (uuid, primary key) - unique identifier
      - `name` (text) - submitter's full name
      - `company_name` (text) - firm name
      - `email` (text) - contact email
      - `company_website` (text) - firm website
      - `created_at` (timestamptz) - submission timestamp
  2. Security
    - Enable RLS on `audit_requests`
    - Allow anonymous (public) INSERTs so the audit form works from the browser
    - No SELECT/UPDATE/DELETE policies for anon or authenticated — data only accessible via service role (admin)
*/

CREATE TABLE IF NOT EXISTS audit_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL DEFAULT '',
  company_name text NOT NULL DEFAULT '',
  email text NOT NULL DEFAULT '',
  company_website text NOT NULL DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE audit_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can submit an audit request"
  ON audit_requests FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Authenticated users can submit an audit request"
  ON audit_requests FOR INSERT
  TO authenticated
  WITH CHECK (true);
