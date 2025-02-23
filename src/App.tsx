import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { useAuthStore } from './store/authStore';
import Login from './pages/Login';
import Layout from './components/Layout';
import DataManagement from './pages/DataManagement';
import MapViewer from './pages/MapViewer';
import Analytics from './pages/Analytics';

function App() {
  const { isAuthenticated, checkAuth } = useAuthStore();

  useEffect(() => {
    checkAuth();
  }, [checkAuth]);

  return (
    <Router>
      <Routes>
        <Route path="/login" element={!isAuthenticated ? <Login /> : <Navigate to="/" />} />
        <Route
          path="/"
          element={isAuthenticated ? <Layout /> : <Navigate to="/login" />}
        >
          <Route path="data" element={<DataManagement />} />
          <Route path="map" element={<MapViewer />} />
          <Route path="analytics" element={<Analytics />} />
          <Route index element={<Navigate to="/data" replace />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;