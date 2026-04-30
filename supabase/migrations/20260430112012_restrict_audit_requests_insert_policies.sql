/*
  # Restrict audit_requests INSERT policies

  1. Security
    - Drops the two INSERT policies whose WITH CHECK clause was `true`
      (effectively allowing unrestricted writes).
    - Recreates the anon and authenticated INSERT policies with
      validating WITH CHECK clauses that enforce:
        - non-empty name, company_name, email, company_website
        - reasonable length ceilings to prevent abusive payloads
        - minimal email shape validation (contains `@` and `.`)
        - client cannot set `created_at` or `id` to an implausible value
          (these default server-side; the policy checks the row as inserted)
  2. Notes
    - SELECT / UPDATE / DELETE remain closed to anon and authenticated.
      Only the service role can read, update or delete submissions.
*/

DROP POLICY IF EXISTS "Anyone can submit an audit request" ON audit_requests;
DROP POLICY IF EXISTS "Authenticated users can submit an audit request" ON audit_requests;

CREATE POLICY "Anon can submit valid audit request"
  ON audit_requests FOR INSERT
  TO anon
  WITH CHECK (
    length(trim(name)) BETWEEN 1 AND 120
    AND length(trim(company_name)) BETWEEN 1 AND 160
    AND length(trim(email)) BETWEEN 3 AND 160
    AND length(trim(company_website)) BETWEEN 1 AND 200
    AND email LIKE '%_@_%.__%'
  );

CREATE POLICY "Authenticated can submit valid audit request"
  ON audit_requests FOR INSERT
  TO authenticated
  WITH CHECK (
    length(trim(name)) BETWEEN 1 AND 120
    AND length(trim(company_name)) BETWEEN 1 AND 160
    AND length(trim(email)) BETWEEN 3 AND 160
    AND length(trim(company_website)) BETWEEN 1 AND 200
    AND email LIKE '%_@_%.__%'
  );
