import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  Typography,
  Grid,
  Card,
  CardContent,
  CardActions,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
} from '@mui/material';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import StopIcon from '@mui/icons-material/Stop';
import HistoryIcon from '@mui/icons-material/History';
import { useApi } from '../../hooks/useApi';
import { useSnackbar } from '../../contexts/SnackbarContext';

const PlaybookManager = () => {
  const [playbooks, setPlaybooks] = useState([]);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedPlaybook, setSelectedPlaybook] = useState(null);
  const [executionHistory, setExecutionHistory] = useState([]);
  const [showHistory, setShowHistory] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    type: 'incident_response',
    content: '',
    tags: []
  });

  const api = useApi();
  const { showMessage } = useSnackbar();

  useEffect(() => {
    fetchPlaybooks();
  }, []);

  const fetchPlaybooks = async () => {
    try {
      const data = await api.get('/playbooks');
      setPlaybooks(data);
    } catch (error) {
      showMessage('Failed to fetch playbooks', 'error');
    }
  };

  const fetchPlaybookHistory = async (playbookId) => {
    try {
      const data = await api.get(`/playbooks/${playbookId}/history`);
      setExecutionHistory(data);
      setShowHistory(true);
    } catch (error) {
      showMessage('Failed to fetch playbook history', 'error');
    }
  };

  const handleCreatePlaybook = () => {
    setSelectedPlaybook(null);
    setFormData({
      name: '',
      description: '',
      type: 'incident_response',
      content: '',
      tags: []
    });
    setOpenDialog(true);
  };

  const handleEditPlaybook = (playbook) => {
    setSelectedPlaybook(playbook);
    setFormData(playbook);
    setOpenDialog(true);
  };

  const handleSavePlaybook = async () => {
    try {
      if (selectedPlaybook) {
        await api.put(`/playbooks/${selectedPlaybook.id}`, formData);
      } else {
        await api.post('/playbooks', formData);
      }
      showMessage('Playbook saved successfully', 'success');
      setOpenDialog(false);
      fetchPlaybooks();
    } catch (error) {
      showMessage('Failed to save playbook', 'error');
    }
  };

  const handleExecutePlaybook = async (playbookId) => {
    try {
      await api.post(`/playbooks/${playbookId}/execute`);
      showMessage('Playbook execution started', 'success');
    } catch (error) {
      showMessage('Failed to execute playbook', 'error');
    }
  };

  const handleStopPlaybook = async (playbookId) => {
    try {
      await api.post(`/playbooks/${playbookId}/stop`);
      showMessage('Playbook execution stopped', 'success');
    } catch (error) {
      showMessage('Failed to stop playbook', 'error');
    }
  };

  return (
    <Box p={3}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h5">Playbook Manager</Typography>
        <Button
          variant="contained"
          color="primary"
          onClick={handleCreatePlaybook}
        >
          Create Playbook
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Type</TableCell>
              <TableCell>Description</TableCell>
              <TableCell>Last Execution</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {playbooks.map((playbook) => (
              <TableRow key={playbook.id}>
                <TableCell>{playbook.name}</TableCell>
                <TableCell>{playbook.type}</TableCell>
                <TableCell>{playbook.description}</TableCell>
                <TableCell>
                  {playbook.lastExecution
                    ? new Date(playbook.lastExecution).toLocaleString()
                    : 'Never'}
                </TableCell>
                <TableCell>{playbook.status}</TableCell>
                <TableCell>
                  <IconButton
                    onClick={() => handleExecutePlaybook(playbook.id)}
                    disabled={playbook.status === 'running'}
                  >
                    <PlayArrowIcon />
                  </IconButton>
                  <IconButton
                    onClick={() => handleStopPlaybook(playbook.id)}
                    disabled={playbook.status !== 'running'}
                  >
                    <StopIcon />
                  </IconButton>
                  <IconButton onClick={() => fetchPlaybookHistory(playbook.id)}>
                    <HistoryIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
        <DialogTitle>
          {selectedPlaybook ? 'Edit Playbook' : 'Create Playbook'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Name"
                value={formData.name}
                onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                multiline
                rows={3}
                label="Description"
                value={formData.description}
                onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
              />
            </Grid>
            <Grid item xs={12}>
              <FormControl fullWidth>
                <InputLabel>Type</InputLabel>
                <Select
                  value={formData.type}
                  onChange={(e) => setFormData(prev => ({ ...prev, type: e.target.value }))}
                >
                  <MenuItem value="incident_response">Incident Response</MenuItem>
                  <MenuItem value="threat_hunting">Threat Hunting</MenuItem>
                  <MenuItem value="compliance">Compliance</MenuItem>
                  <MenuItem value="vulnerability_management">Vulnerability Management</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                multiline
                rows={10}
                label="Playbook Content"
                value={formData.content}
                onChange={(e) => setFormData(prev => ({ ...prev, content: e.target.value }))}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
          <Button onClick={handleSavePlaybook} color="primary" variant="contained">
            Save
          </Button>
        </DialogActions>
      </Dialog>

      <Dialog open={showHistory} onClose={() => setShowHistory(false)} maxWidth="md" fullWidth>
        <DialogTitle>Execution History</DialogTitle>
        <DialogContent>
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Execution Time</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Duration</TableCell>
                  <TableCell>Result</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {executionHistory.map((execution) => (
                  <TableRow key={execution.id}>
                    <TableCell>
                      {new Date(execution.timestamp).toLocaleString()}
                    </TableCell>
                    <TableCell>{execution.status}</TableCell>
                    <TableCell>{execution.duration}s</TableCell>
                    <TableCell>{execution.result}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setShowHistory(false)}>Close</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default PlaybookManager;
