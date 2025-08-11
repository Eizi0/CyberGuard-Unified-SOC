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
  IconButton,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Chip,
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import { useApi } from '../../hooks/useApi';
import { useSnackbar } from '../../contexts/SnackbarContext';

const WorkflowAutomation = () => {
  const [workflows, setWorkflows] = useState([]);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedWorkflow, setSelectedWorkflow] = useState(null);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    trigger: {
      type: 'event',
      configuration: {}
    },
    actions: []
  });

  const api = useApi();
  const { showMessage } = useSnackbar();

  useEffect(() => {
    fetchWorkflows();
  }, []);

  const fetchWorkflows = async () => {
    try {
      const data = await api.get('/workflows');
      setWorkflows(data);
    } catch (error) {
      showMessage('Failed to fetch workflows', 'error');
    }
  };

  const handleCreateWorkflow = () => {
    setSelectedWorkflow(null);
    setFormData({
      name: '',
      description: '',
      trigger: {
        type: 'event',
        configuration: {}
      },
      actions: []
    });
    setOpenDialog(true);
  };

  const handleEditWorkflow = (workflow) => {
    setSelectedWorkflow(workflow);
    setFormData(workflow);
    setOpenDialog(true);
  };

  const handleDeleteWorkflow = async (workflowId) => {
    try {
      await api.delete(`/workflows/${workflowId}`);
      showMessage('Workflow deleted successfully', 'success');
      fetchWorkflows();
    } catch (error) {
      showMessage('Failed to delete workflow', 'error');
    }
  };

  const handleExecuteWorkflow = async (workflowId) => {
    try {
      await api.post(`/workflows/${workflowId}/execute`);
      showMessage('Workflow execution started', 'success');
    } catch (error) {
      showMessage('Failed to execute workflow', 'error');
    }
  };

  const handleSaveWorkflow = async () => {
    try {
      if (selectedWorkflow) {
        await api.put(`/workflows/${selectedWorkflow.id}`, formData);
      } else {
        await api.post('/workflows', formData);
      }
      showMessage('Workflow saved successfully', 'success');
      setOpenDialog(false);
      fetchWorkflows();
    } catch (error) {
      showMessage('Failed to save workflow', 'error');
    }
  };

  const handleAddAction = () => {
    setFormData(prev => ({
      ...prev,
      actions: [
        ...prev.actions,
        {
          type: 'action',
          service: '',
          command: '',
          parameters: {}
        }
      ]
    }));
  };

  const handleActionChange = (index, field, value) => {
    setFormData(prev => ({
      ...prev,
      actions: prev.actions.map((action, i) => 
        i === index ? { ...action, [field]: value } : action
      )
    }));
  };

  const handleRemoveAction = (index) => {
    setFormData(prev => ({
      ...prev,
      actions: prev.actions.filter((_, i) => i !== index)
    }));
  };

  return (
    <Box p={3}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h5">Workflow Automation</Typography>
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={handleCreateWorkflow}
        >
          Create Workflow
        </Button>
      </Box>

      <Grid container spacing={3}>
        {workflows.map((workflow) => (
          <Grid item xs={12} md={6} key={workflow.id}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  {workflow.name}
                </Typography>
                <Typography variant="body2" color="textSecondary" gutterBottom>
                  {workflow.description}
                </Typography>
                <Box mt={2}>
                  <Typography variant="subtitle2">Trigger:</Typography>
                  <Chip
                    label={workflow.trigger.type}
                    size="small"
                    color="primary"
                    sx={{ mt: 1 }}
                  />
                </Box>
                <Box mt={2}>
                  <Typography variant="subtitle2">Actions:</Typography>
                  <List dense>
                    {workflow.actions.map((action, index) => (
                      <ListItem key={index}>
                        <ListItemText
                          primary={action.service}
                          secondary={action.command}
                        />
                      </ListItem>
                    ))}
                  </List>
                </Box>
              </CardContent>
              <CardActions>
                <IconButton onClick={() => handleExecuteWorkflow(workflow.id)}>
                  <PlayArrowIcon />
                </IconButton>
                <IconButton onClick={() => handleEditWorkflow(workflow)}>
                  <EditIcon />
                </IconButton>
                <IconButton onClick={() => handleDeleteWorkflow(workflow.id)}>
                  <DeleteIcon />
                </IconButton>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>

      <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
        <DialogTitle>
          {selectedWorkflow ? 'Edit Workflow' : 'Create Workflow'}
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
                <InputLabel>Trigger Type</InputLabel>
                <Select
                  value={formData.trigger.type}
                  onChange={(e) => setFormData(prev => ({
                    ...prev,
                    trigger: { ...prev.trigger, type: e.target.value }
                  }))}
                >
                  <MenuItem value="event">Event</MenuItem>
                  <MenuItem value="schedule">Schedule</MenuItem>
                  <MenuItem value="webhook">Webhook</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12}>
              <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                <Typography variant="subtitle1">Actions</Typography>
                <Button startIcon={<AddIcon />} onClick={handleAddAction}>
                  Add Action
                </Button>
              </Box>
              {formData.actions.map((action, index) => (
                <Card key={index} variant="outlined" sx={{ mb: 2 }}>
                  <CardContent>
                    <Grid container spacing={2}>
                      <Grid item xs={12} sm={6}>
                        <FormControl fullWidth>
                          <InputLabel>Service</InputLabel>
                          <Select
                            value={action.service}
                            onChange={(e) => handleActionChange(index, 'service', e.target.value)}
                          >
                            <MenuItem value="wazuh">Wazuh</MenuItem>
                            <MenuItem value="graylog">Graylog</MenuItem>
                            <MenuItem value="thehive">TheHive</MenuItem>
                            <MenuItem value="misp">MISP</MenuItem>
                          </Select>
                        </FormControl>
                      </Grid>
                      <Grid item xs={12} sm={6}>
                        <TextField
                          fullWidth
                          label="Command"
                          value={action.command}
                          onChange={(e) => handleActionChange(index, 'command', e.target.value)}
                        />
                      </Grid>
                    </Grid>
                  </CardContent>
                  <CardActions>
                    <Button size="small" onClick={() => handleRemoveAction(index)}>
                      Remove
                    </Button>
                  </CardActions>
                </Card>
              ))}
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
          <Button onClick={handleSaveWorkflow} color="primary" variant="contained">
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default WorkflowAutomation;
