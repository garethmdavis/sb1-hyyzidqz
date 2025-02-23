/*
  # Initial Schema Setup for Building Management System

  1. New Tables
    - `user_roles`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `role` (text, enum: guest, contributor, admin)
      - `created_at` (timestamp)
    
    - `buildings`
      - `id` (uuid, primary key)
      - `name` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
      - `created_by` (uuid, references auth.users)
      - `updated_by` (uuid, references auth.users)

    - `building_details`
      - `id` (uuid, primary key)
      - `building_id` (uuid, references buildings)
      - `height` (numeric)
      - `area` (numeric)
      - `floors` (integer)
      - `energy_consumption` (numeric)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
      - `created_by` (uuid, references auth.users)
      - `updated_by` (uuid, references auth.users)

    - `change_logs`
      - `id` (uuid, primary key)
      - `table_name` (text)
      - `record_id` (uuid)
      - `change_type` (text)
      - `old_values` (jsonb)
      - `new_values` (jsonb)
      - `user_id` (uuid, references auth.users)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for role-based access
*/

-- Create enum for user roles
CREATE TYPE user_role AS ENUM ('guest', 'contributor', 'admin');

-- Create user_roles table
CREATE TABLE user_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  role user_role NOT NULL DEFAULT 'guest',
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id)
);

-- Create buildings table
CREATE TABLE buildings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users NOT NULL,
  updated_by uuid REFERENCES auth.users NOT NULL
);

-- Create building_details table
CREATE TABLE building_details (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings ON DELETE CASCADE NOT NULL,
  height numeric,
  area numeric,
  floors integer,
  energy_consumption numeric,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users NOT NULL,
  updated_by uuid REFERENCES auth.users NOT NULL
);

-- Create change_logs table
CREATE TABLE change_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name text NOT NULL,
  record_id uuid NOT NULL,
  change_type text NOT NULL,
  old_values jsonb,
  new_values jsonb,
  user_id uuid REFERENCES auth.users NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE buildings ENABLE ROW LEVEL SECURITY;
ALTER TABLE building_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE change_logs ENABLE ROW LEVEL SECURITY;

-- Policies for user_roles
CREATE POLICY "Users can read their own role"
  ON user_roles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Only admins can manage roles"
  ON user_roles
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid()
      AND role = 'admin'
    )
  );

-- Policies for buildings
CREATE POLICY "Everyone can read buildings"
  ON buildings
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Contributors and admins can insert buildings"
  ON buildings
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid()
      AND role IN ('contributor', 'admin')
    )
  );

CREATE POLICY "Contributors and admins can update buildings"
  ON buildings
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid()
      AND role IN ('contributor', 'admin')
    )
  );

-- Similar policies for building_details
CREATE POLICY "Everyone can read building details"
  ON building_details
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Contributors and admins can manage building details"
  ON building_details
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid()
      AND role IN ('contributor', 'admin')
    )
  );

-- Policies for change_logs
CREATE POLICY "Everyone can read change logs"
  ON change_logs
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "System can create change logs"
  ON change_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Functions and triggers for logging changes
CREATE OR REPLACE FUNCTION log_changes()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO change_logs (
      table_name,
      record_id,
      change_type,
      old_values,
      new_values,
      user_id
    )
    VALUES (
      TG_TABLE_NAME,
      CASE 
        WHEN TG_TABLE_NAME = 'buildings' THEN OLD.id
        WHEN TG_TABLE_NAME = 'building_details' THEN OLD.id
      END,
      TG_OP,
      row_to_json(OLD),
      row_to_json(NEW),
      auth.uid()
    );
  ELSIF TG_OP = 'INSERT' THEN
    INSERT INTO change_logs (
      table_name,
      record_id,
      change_type,
      new_values,
      user_id
    )
    VALUES (
      TG_TABLE_NAME,
      NEW.id,
      TG_OP,
      row_to_json(NEW),
      auth.uid()
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers for logging changes
CREATE TRIGGER buildings_audit
  AFTER INSERT OR UPDATE
  ON buildings
  FOR EACH ROW
  EXECUTE FUNCTION log_changes();

CREATE TRIGGER building_details_audit
  AFTER INSERT OR UPDATE
  ON building_details
  FOR EACH ROW
  EXECUTE FUNCTION log_changes();