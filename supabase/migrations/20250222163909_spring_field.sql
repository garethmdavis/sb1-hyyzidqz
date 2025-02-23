/*
  # Fix change logs trigger function

  1. Changes
    - Update log_changes() function to properly handle user_id
    - Ensure user_id is set from auth.uid() in the trigger function
    - Add safety checks for auth.uid()
*/

CREATE OR REPLACE FUNCTION log_changes()
RETURNS TRIGGER AS $$
DECLARE
  current_user_id uuid;
BEGIN
  -- Get the current user ID
  SELECT auth.uid() INTO current_user_id;
  
  -- Ensure we have a user ID
  IF current_user_id IS NULL THEN
    current_user_id := COALESCE(NEW.updated_by, NEW.created_by);
  END IF;

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
      current_user_id
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
      current_user_id
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;