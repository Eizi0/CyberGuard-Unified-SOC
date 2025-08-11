import React, { createContext, useContext, useState, useEffect } from 'react';
import { useApi } from '../hooks/useApi';
import { useSnackbar } from './SnackbarContext';

const AuthContext = createContext(null);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const api = useApi();
  const { showMessage } = useSnackbar();

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const token = localStorage.getItem('token');
      if (token) {
        const userData = await api.get('/users/me');
        setUser(userData);
      }
    } catch (error) {
      console.error('Authentication check failed:', error);
      logout();
    } finally {
      setLoading(false);
    }
  };

  const login = async (credentials) => {
    try {
      const response = await api.login(credentials);
      setUser(response.user);
      showMessage('Login successful', 'success');
      return response;
    } catch (error) {
      showMessage(error.message || 'Login failed', 'error');
      throw error;
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
    showMessage('Logged out successfully', 'success');
  };

  const updateProfile = async (data) => {
    try {
      const updatedUser = await api.put('/users/me', data);
      setUser(updatedUser);
      showMessage('Profile updated successfully', 'success');
    } catch (error) {
      showMessage(error.message || 'Failed to update profile', 'error');
      throw error;
    }
  };

  const value = {
    user,
    loading,
    login,
    logout,
    updateProfile,
    isAuthenticated: !!user,
  };

  if (loading) {
    return null; // or a loading spinner
  }

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

export default AuthContext;
