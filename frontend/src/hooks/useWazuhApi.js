import { useCallback } from 'react';
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';

export const useWazuhApi = () => {
  const getAgents = useCallback(async (status = null) => {
    try {
      const params = status ? { status } : {};
      const response = await axios.get(`${API_BASE_URL}/wazuh/agents`, { params });
      return response.data;
    } catch (error) {
      console.error('Error fetching agents:', error);
      throw error;
    }
  }, []);

  const getAgent = useCallback(async (agentId) => {
    try {
      const response = await axios.get(`${API_BASE_URL}/wazuh/agents/${agentId}`);
      return response.data;
    } catch (error) {
      console.error('Error fetching agent:', error);
      throw error;
    }
  }, []);

  const getAlerts = useCallback(async (limit = 100, offset = 0) => {
    try {
      const response = await axios.get(`${API_BASE_URL}/wazuh/alerts`, {
        params: { limit, offset }
      });
      return response.data;
    } catch (error) {
      console.error('Error fetching alerts:', error);
      throw error;
    }
  }, []);

  const getRules = useCallback(async (limit = 100, offset = 0) => {
    try {
      const response = await axios.get(`${API_BASE_URL}/wazuh/rules`, {
        params: { limit, offset }
      });
      return response.data;
    } catch (error) {
      console.error('Error fetching rules:', error);
      throw error;
    }
  }, []);

  const restartAgent = useCallback(async (agentId) => {
    try {
      const response = await axios.put(`${API_BASE_URL}/wazuh/agents/${agentId}/restart`);
      return response.data;
    } catch (error) {
      console.error('Error restarting agent:', error);
      throw error;
    }
  }, []);

  const getAgentConfig = useCallback(async (agentId, component) => {
    try {
      const response = await axios.get(
        `${API_BASE_URL}/wazuh/agents/${agentId}/config/${component}`
      );
      return response.data;
    } catch (error) {
      console.error('Error fetching agent config:', error);
      throw error;
    }
  }, []);

  return {
    getAgents,
    getAgent,
    getAlerts,
    getRules,
    restartAgent,
    getAgentConfig,
  };
};
