import React, { useState, useEffect } from 'react';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  Grid,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Typography,
} from '@mui/material';
import { useApi } from '../../hooks/useApi';

const CaseDialog = ({ open, onClose, onSave, caseData }) => {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    status: 'new',
    severity: 'medium',
    assignee: '',
    tags: '',
    tlp: 'amber',
    pap: 'amber',
  });

  const [loading, setLoading] = useState(false);
  const api = useApi();

  useEffect(() => {
    if (caseData) {
      setFormData({
        title: caseData.title || '',
        description: caseData.description || '',
        status: caseData.status || 'new',
        severity: caseData.severity || 'medium',
        assignee: caseData.assignee || '',
        tags: (caseData.tags || []).join(', '),
        tlp: caseData.tlp || 'amber',
        pap: caseData.pap || 'amber',
      });
    } else {
      resetForm();
    }
  }, [caseData]);

  const resetForm = () => {
    setFormData({
      title: '',
      description: '',
      status: 'new',
      severity: 'medium',
      assignee: '',
      tags: '',
      tlp: 'amber',
      pap: 'amber',
    });
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async () => {
    setLoading(true);
    try {
      const finalData = {
        ...formData,
        tags: formData.tags.split(',').map((tag) => tag.trim()).filter(Boolean),
      };
      await onSave(finalData);
      resetForm();
    } catch (error) {
      console.error('Error saving case:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle>
        {caseData ? 'Edit Case' : 'Create New Case'}
      </DialogTitle>
      <DialogContent>
        <Grid container spacing={2} sx={{ mt: 1 }}>
          <Grid item xs={12}>
            <TextField
              name="title"
              label="Title"
              fullWidth
              required
              value={formData.title}
              onChange={handleChange}
            />
          </Grid>
          
          <Grid item xs={12}>
            <TextField
              name="description"
              label="Description"
              fullWidth
              multiline
              rows={4}
              value={formData.description}
              onChange={handleChange}
            />
          </Grid>

          <Grid item xs={12} sm={6}>
            <FormControl fullWidth>
              <InputLabel>Status</InputLabel>
              <Select
                name="status"
                value={formData.status}
                label="Status"
                onChange={handleChange}
              >
                <MenuItem value="new">New</MenuItem>
                <MenuItem value="in-progress">In Progress</MenuItem>
                <MenuItem value="resolved">Resolved</MenuItem>
                <MenuItem value="closed">Closed</MenuItem>
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} sm={6}>
            <FormControl fullWidth>
              <InputLabel>Severity</InputLabel>
              <Select
                name="severity"
                value={formData.severity}
                label="Severity"
                onChange={handleChange}
              >
                <MenuItem value="low">Low</MenuItem>
                <MenuItem value="medium">Medium</MenuItem>
                <MenuItem value="high">High</MenuItem>
                <MenuItem value="critical">Critical</MenuItem>
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12}>
            <TextField
              name="assignee"
              label="Assignee"
              fullWidth
              value={formData.assignee}
              onChange={handleChange}
            />
          </Grid>

          <Grid item xs={12}>
            <TextField
              name="tags"
              label="Tags (comma separated)"
              fullWidth
              value={formData.tags}
              onChange={handleChange}
              helperText="Enter tags separated by commas"
            />
          </Grid>

          <Grid item xs={12} sm={6}>
            <FormControl fullWidth>
              <InputLabel>TLP Level</InputLabel>
              <Select
                name="tlp"
                value={formData.tlp}
                label="TLP Level"
                onChange={handleChange}
              >
                <MenuItem value="white">White</MenuItem>
                <MenuItem value="green">Green</MenuItem>
                <MenuItem value="amber">Amber</MenuItem>
                <MenuItem value="red">Red</MenuItem>
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} sm={6}>
            <FormControl fullWidth>
              <InputLabel>PAP Level</InputLabel>
              <Select
                name="pap"
                value={formData.pap}
                label="PAP Level"
                onChange={handleChange}
              >
                <MenuItem value="white">White</MenuItem>
                <MenuItem value="green">Green</MenuItem>
                <MenuItem value="amber">Amber</MenuItem>
                <MenuItem value="red">Red</MenuItem>
              </Select>
            </FormControl>
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button
          onClick={handleSubmit}
          color="primary"
          variant="contained"
          disabled={loading || !formData.title}
        >
          {loading ? 'Saving...' : 'Save'}
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default CaseDialog;
