import { create } from 'zustand';
import { supabase, UserRole } from '../lib/supabase';

interface AuthState {
  isAuthenticated: boolean;
  userRole: UserRole | null;
  userId: string | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  checkAuth: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) => ({
  isAuthenticated: false,
  userRole: null,
  userId: null,

  login: async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) throw error;
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (user) {
      const { data: roleData } = await supabase
        .from('user_roles2')
        .select('role')
        .eq('user_id', user.id)
        .single();

      set({
        isAuthenticated: true,
        userRole: roleData?.role || 'guest',
        userId: user.id,
      });
    }
  },

  logout: async () => {
    await supabase.auth.signOut();
    set({ isAuthenticated: false, userRole: null, userId: null });
  },

  checkAuth: async () => {
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (user) {
      const { data: roleData } = await supabase
        .from('user_roles2')
        .select('role')
        .eq('user_id', user.id)
        .single();

      set({
        isAuthenticated: true,
        userRole: roleData?.role || 'guest',
        userId: user.id,
      });
    } else {
      set({ isAuthenticated: false, userRole: null, userId: null });
    }
  },
}));