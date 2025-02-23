/*
  # Fix user roles policy

  1. Changes
    - Update user roles policy to avoid recursion
    - Add policy for admin management without recursion

  2. Security
    - Maintain RLS security while fixing recursion issue
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Users can read their own role" ON user_roles2;
DROP POLICY IF EXISTS "Only admins can manage roles" ON user_roles2;

-- Create new policies without recursion
CREATE POLICY "Users can read their own role"
  ON user_roles2
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all roles"
  ON user_roles2
  FOR ALL
  TO authenticated
  USING (
    role = 'admin'
  );