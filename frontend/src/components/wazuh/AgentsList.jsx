import React, { useEffect, useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Grid,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  IconButton,
  Button
} from '@mui/material';
import RefreshIcon from '@mui/icons-material/Refresh';
import RestartAltIcon from '@mui/icons-material/RestartAlt';
import { useWazuhApi } from '../../hooks/useWazuhApi';

const AgentsList = () => {
  const [agents, setAgents] = useState([]);
  const [loading, setLoading] = useState(true);
  const wazuhApi = useWazuhApi();

  const fetchAgents = async () => {
    setLoading(true);
    try {
      const data = await wazuhApi.getAgents();
      setAgents(data);
    } catch (error) {
      console.error('Error fetching agents:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = () => {
    fetchAgents();
  };

  const handleRestartAgent = async (agentId) => {
    try {
      await wazuhApi.restartAgent(agentId);
      // Refresh the agents list after restart
      fetchAgents();
    } catch (error) {
      console.error('Error restarting agent:', error);
    }
  };

  useEffect(() => {
    fetchAgents();
  }, []);

  const getStatusColor = (status) => {
    switch (status.toLowerCase()) {
      case 'active':
        return 'success';
      case 'disconnected':
        return 'error';
      case 'pending':
        return 'warning';
      default:
        return 'default';
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Card>
        <CardContent>
          <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
            <Typography variant="h5" component="h2">
              Wazuh Agents
            </Typography>
            <Button
              startIcon={<RefreshIcon />}
              onClick={handleRefresh}
              disabled={loading}
            >
              Refresh
            </Button>
          </Box>
          
          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>ID</TableCell>
                  <TableCell>Name</TableCell>
                  <TableCell>IP</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Version</TableCell>
                  <TableCell>Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {agents.map((agent) => (
                  <TableRow key={agent.id}>
                    <TableCell>{agent.id}</TableCell>
                    <TableCell>{agent.name}</TableCell>
                    <TableCell>{agent.ip}</TableCell>
                    <TableCell>
                      <Chip
                        label={agent.status}
                        color={getStatusColor(agent.status)}
                        size="small"
                      />
                    </TableCell>
                    <TableCell>{agent.version}</TableCell>
                    <TableCell>
                      <IconButton
                        onClick={() => handleRestartAgent(agent.id)}
                        disabled={agent.status === 'disconnected'}
                      >
                        <RestartAltIcon />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </CardContent>
      </Card>
    </Box>
  );
};

export default AgentsList;
