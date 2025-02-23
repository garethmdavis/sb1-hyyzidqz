import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
  },
});

export type UserRole = 'guest' | 'contributor' | 'admin';

export interface Building {
  id: string;
  name: string;
  latitude: number;
  longitude: number;
  created_at: string;
  updated_at: string;
  created_by: string;
  updated_by: string;
}

export interface BuildingDetails {
  id: string;
  building_id: string;
  height: number;
  area: number;
  floors: number;
  energy_consumption: number;
  created_at: string;
  updated_at: string;
  created_by: string;
  updated_by: string;
}

export interface ChangeLog {
  id: string;
  table_name: string;
  record_id: string;
  change_type: string;
  old_values: any;
  new_values: any;
  user_id: string;
  created_at: string;
}