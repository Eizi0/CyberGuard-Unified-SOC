import { useState } from 'react';
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

export const useApi = () => {
  const [error, setError] = useState(null);

  // Get token from localStorage
  const getToken = () => localStorage.getItem('token');

  // Create axios instance with default config
  const api = axios.create({
    baseURL: API_BASE_URL,
    headers: {
      'Content-Type': 'application/json',
    },
  });

  // Add token to requests
  api.interceptors.request.use((config) => {
    const token = getToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  // Handle errors globally
  api.interceptors.response.use(
    (response) => response.data,
    (error) => {
      setError(error.response?.data?.message || error.message);
      throw error;
    }
  );

  const methods = {
    // Generic request method
    async request(method, url, data = null, config = {}) {
      try {
        const response = await api.request({
          method,
          url,
          data,
          ...config,
        });
        return response;
      } catch (error) {
        throw error;
      }
    },

    // GET request
    async get(url, config = {}) {
      return methods.request('get', url, null, config);
    },

    // POST request
    async post(url, data, config = {}) {
      return methods.request('post', url, data, config);
    },

    // PUT request
    async put(url, data, config = {}) {
      return methods.request('put', url, data, config);
    },

    // DELETE request
    async delete(url, config = {}) {
      return methods.request('delete', url, null, config);
    },

    // Authentication
    async login(credentials) {
      const response = await methods.post('/auth/token', credentials);
      if (response.access_token) {
        localStorage.setItem('token', response.access_token);
      }
      return response;
    },

    async logout() {
      localStorage.removeItem('token');
    },

    // Alert Management
    async getAlerts(params = {}) {
      return methods.get('/alerts', { params });
    },

    async updateAlert(alertId, data) {
      return methods.put(`/alerts/${alertId}`, data);
    },

    // Service Status
    async getServiceStatus() {
      return methods.get('/services/status');
    },

    // Metrics
    async getMetrics(timeRange = '24h') {
      return methods.get('/metrics', { params: { timeRange } });
    },

    // Correlations
    async getCorrelations(params = {}) {
      return methods.get('/correlations', { params });
    },

    // Integrations
    async getIntegrationConfig(integration) {
      return methods.get(`/integrations/${integration}/config`);
    },

    async updateIntegrationConfig(integration, config) {
      return methods.put(`/integrations/${integration}/config`, config);
    },

    // Workflows
    async getWorkflows() {
      return methods.get('/workflows');
    },

    async executeWorkflow(workflowId, data) {
      return methods.post(`/workflows/${workflowId}/execute`, data);
    },
  };

  return { ...methods, error };
};

export default useApi;
