import React from 'react';
import { Outlet, NavLink } from 'react-router-dom';
import { Database, Map, BarChart, LogOut } from 'lucide-react';
import { useAuthStore } from '../store/authStore';

function Layout() {
  const { logout } = useAuthStore();

  return (
    <div className="flex h-screen bg-gray-100">
      <aside className="w-16 bg-white shadow-md">
        <div className="h-full flex flex-col justify-between py-4">
          <nav className="space-y-4">
            <NavLink
              to="/data"
              className={({ isActive }) =>
                `flex justify-center p-2 hover:bg-gray-100 transition-colors ${
                  isActive ? 'text-blue-600' : 'text-gray-600'
                }`
              }
            >
              <Database className="w-6 h-6" />
            </NavLink>
            <NavLink
              to="/map"
              className={({ isActive }) =>
                `flex justify-center p-2 hover:bg-gray-100 transition-colors ${
                  isActive ? 'text-blue-600' : 'text-gray-600'
                }`
              }
            >
              <Map className="w-6 h-6" />
            </NavLink>
            <NavLink
              to="/analytics"
              className={({ isActive }) =>
                `flex justify-center p-2 hover:bg-gray-100 transition-colors ${
                  isActive ? 'text-blue-600' : 'text-gray-600'
                }`
              }
            >
              <BarChart className="w-6 h-6" />
            </NavLink>
          </nav>
          <button
            onClick={() => logout()}
            className="flex justify-center p-2 text-gray-600 hover:bg-gray-100 transition-colors"
          >
            <LogOut className="w-6 h-6" />
          </button>
        </div>
      </aside>
      <main className="flex-1 overflow-auto">
        <Outlet />
      </main>
    </div>
  );
}

export default Layout