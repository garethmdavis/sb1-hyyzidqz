/*
  # Rename user_roles table to user_roles2

  1. Changes
    - Rename table from user_roles to user_roles2
    - Update policies to reference new table name
    - Preserve all data and constraints
*/

-- Create new table with the same structure
CREATE TABLE user_roles2 (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  role user_role NOT NULL DEFAULT 'guest',
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id)
);

-- Copy data from old to new table
INSERT INTO user_roles2 (id, user_id, role, created_at)
SELECT id, user_id, role, created_at
FROM user_roles;

-- Enable RLS on new table
ALTER TABLE user_roles2 ENABLE ROW LEVEL SECURITY;

-- Recreate policies for the new table
CREATE POLICY "Users can read their own role"
  ON user_roles2
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Only admins can manage roles"
  ON user_roles2
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles2
      WHERE user_id = auth.uid()
      AND role = 'admin'
    )
  );

-- Drop old table
DROP TABLE user_roles;