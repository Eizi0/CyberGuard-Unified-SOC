import { useState } from 'react';
import axios from 'axios';

const GRAYLOG_API_URL = process.env.REACT_APP_GRAYLOG_API_URL || 'http://localhost:9000/api';

export const useGraylogApi = () => {
  const [error, setError] = useState(null);

  const handleApiError = (error) => {
    setError(error.response?.data?.message || error.message);
    throw error;
  };

  const api = {
    // Input Management
    async getInputs() {
      try {
        const response = await axios.get(`${GRAYLOG_API_URL}/system/inputs`);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    async createInput(inputData) {
      try {
        const response = await axios.post(`${GRAYLOG_API_URL}/system/inputs`, inputData);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    async deleteInput(inputId) {
      try {
        const response = await axios.delete(`${GRAYLOG_API_URL}/system/inputs/${inputId}`);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    async updateInput(inputId, inputData) {
      try {
        const response = await axios.put(`${GRAYLOG_API_URL}/system/inputs/${inputId}`, inputData);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    // Search
    async search(query, timerange, streams = []) {
      try {
        const response = await axios.post(`${GRAYLOG_API_URL}/search/universal/absolute`, {
          query,
          timerange,
          streams,
        });
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    // Stream Management
    async getStreams() {
      try {
        const response = await axios.get(`${GRAYLOG_API_URL}/streams`);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    async createStream(streamData) {
      try {
        const response = await axios.post(`${GRAYLOG_API_URL}/streams`, streamData);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    // Dashboard Management
    async getDashboards() {
      try {
        const response = await axios.get(`${GRAYLOG_API_URL}/dashboards`);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    async createDashboard(dashboardData) {
      try {
        const response = await axios.post(`${GRAYLOG_API_URL}/dashboards`, dashboardData);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    // Alert Management
    async getAlerts() {
      try {
        const response = await axios.get(`${GRAYLOG_API_URL}/alerts`);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    async createAlert(alertData) {
      try {
        const response = await axios.post(`${GRAYLOG_API_URL}/alerts`, alertData);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    // System Overview
    async getSystemOverview() {
      try {
        const response = await axios.get(`${GRAYLOG_API_URL}/system/overview`);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    },

    // Node Status
    async getNodeStatus() {
      try {
        const response = await axios.get(`${GRAYLOG_API_URL}/system/nodes`);
        return response.data;
      } catch (error) {
        return handleApiError(error);
      }
    }
  };

  return { ...api, error };
};

export default useGraylogApi;
