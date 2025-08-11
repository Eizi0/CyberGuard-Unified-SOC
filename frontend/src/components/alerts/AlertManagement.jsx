import React, { useState, useEffect, useMemo } from 'react';
import {
  Box,
  Grid,
  Paper,
  Typography,
  Card,
  CardContent,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  TextField,
  Chip,
  IconButton,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
} from '@mui/material';
import FilterListIcon from '@mui/icons-material/FilterList';
import VisibilityIcon from '@mui/icons-material/Visibility';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import ErrorIcon from '@mui/icons-material/Error';
import { useApi } from '../../hooks/useApi';
import { useSnackbar } from '../../contexts/SnackbarContext';

const severityColors = {
  critical: 'error',
  high: 'error',
  medium: 'warning',
  low: 'info',
  info: 'success',
};

const statusColors = {
  new: 'info',
  investigating: 'warning',
  resolved: 'success',
  false_positive: 'default',
};

const AlertManagement = () => {
  const [alerts, setAlerts] = useState([]);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [filters, setFilters] = useState({
    severity: '',
    status: '',
    source: '',
    timeRange: '24h',
  });
  const [showFilters, setShowFilters] = useState(false);
  const [selectedAlert, setSelectedAlert] = useState(null);
  const [correlations, setCorrelations] = useState([]);

  const api = useApi();
  const { showMessage } = useSnackbar();

  useEffect(() => {
    fetchAlerts();
  }, [filters, page, rowsPerPage]);

  const fetchAlerts = async () => {
    try {
      const params = {
        ...filters,
        page: page + 1,
        limit: rowsPerPage,
      };
      const data = await api.get('/alerts', { params });
      setAlerts(data.alerts);
    } catch (error) {
      showMessage('Failed to fetch alerts', 'error');
    }
  };

  const handleFilterChange = (name, value) => {
    setFilters(prev => ({
      ...prev,
      [name]: value,
    }));
    setPage(0);
  };

  const handleViewAlert = async (alert) => {
    setSelectedAlert(alert);
    try {
      const correlatedAlerts = await api.get(`/alerts/${alert.id}/correlations`);
      setCorrelations(correlatedAlerts);
    } catch (error) {
      showMessage('Failed to fetch alert correlations', 'error');
    }
  };

  const handleStatusChange = async (alertId, newStatus) => {
    try {
      await api.put(`/alerts/${alertId}`, { status: newStatus });
      showMessage('Alert status updated successfully', 'success');
      fetchAlerts();
    } catch (error) {
      showMessage('Failed to update alert status', 'error');
    }
  };

  const handleBulkAction = async (action) => {
    try {
      await api.post('/alerts/bulk', {
        action,
        filters,
      });
      showMessage('Bulk action completed successfully', 'success');
      fetchAlerts();
    } catch (error) {
      showMessage('Failed to perform bulk action', 'error');
    }
  };

  return (
    <Box p={3}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h5">Alert Management</Typography>
        <Box>
          <IconButton onClick={() => setShowFilters(!showFilters)}>
            <FilterListIcon />
          </IconButton>
          <Button
            variant="contained"
            color="primary"
            onClick={() => handleBulkAction('resolve')}
            sx={{ ml: 1 }}
          >
            Resolve Selected
          </Button>
        </Box>
      </Box>

      {showFilters && (
        <Paper sx={{ p: 2, mb: 3 }}>
          <Grid container spacing={2}>
            <Grid item xs={12} sm={3}>
              <FormControl fullWidth>
                <InputLabel>Severity</InputLabel>
                <Select
                  value={filters.severity}
                  onChange={(e) => handleFilterChange('severity', e.target.value)}
                >
                  <MenuItem value="">All</MenuItem>
                  <MenuItem value="critical">Critical</MenuItem>
                  <MenuItem value="high">High</MenuItem>
                  <MenuItem value="medium">Medium</MenuItem>
                  <MenuItem value="low">Low</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={3}>
              <FormControl fullWidth>
                <InputLabel>Status</InputLabel>
                <Select
                  value={filters.status}
                  onChange={(e) => handleFilterChange('status', e.target.value)}
                >
                  <MenuItem value="">All</MenuItem>
                  <MenuItem value="new">New</MenuItem>
                  <MenuItem value="investigating">Investigating</MenuItem>
                  <MenuItem value="resolved">Resolved</MenuItem>
                  <MenuItem value="false_positive">False Positive</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={3}>
              <FormControl fullWidth>
                <InputLabel>Source</InputLabel>
                <Select
                  value={filters.source}
                  onChange={(e) => handleFilterChange('source', e.target.value)}
                >
                  <MenuItem value="">All</MenuItem>
                  <MenuItem value="wazuh">Wazuh</MenuItem>
                  <MenuItem value="graylog">Graylog</MenuItem>
                  <MenuItem value="thehive">TheHive</MenuItem>
                  <MenuItem value="misp">MISP</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={3}>
              <FormControl fullWidth>
                <InputLabel>Time Range</InputLabel>
                <Select
                  value={filters.timeRange}
                  onChange={(e) => handleFilterChange('timeRange', e.target.value)}
                >
                  <MenuItem value="1h">Last Hour</MenuItem>
                  <MenuItem value="24h">Last 24 Hours</MenuItem>
                  <MenuItem value="7d">Last 7 Days</MenuItem>
                  <MenuItem value="30d">Last 30 Days</MenuItem>
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </Paper>
      )}

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Title</TableCell>
              <TableCell>Severity</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Source</TableCell>
              <TableCell>Created</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {alerts.map((alert) => (
              <TableRow key={alert.id}>
                <TableCell>{alert.id}</TableCell>
                <TableCell>{alert.title}</TableCell>
                <TableCell>
                  <Chip
                    label={alert.severity}
                    color={severityColors[alert.severity]}
                    size="small"
                  />
                </TableCell>
                <TableCell>
                  <Chip
                    label={alert.status}
                    color={statusColors[alert.status]}
                    size="small"
                  />
                </TableCell>
                <TableCell>{alert.source}</TableCell>
                <TableCell>
                  {new Date(alert.createdAt).toLocaleString()}
                </TableCell>
                <TableCell>
                  <IconButton onClick={() => handleViewAlert(alert)}>
                    <VisibilityIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
        <TablePagination
          rowsPerPageOptions={[5, 10, 25, 50]}
          component="div"
          count={alerts.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={(event, newPage) => setPage(newPage)}
          onRowsPerPageChange={(event) => {
            setRowsPerPage(parseInt(event.target.value, 10));
            setPage(0);
          }}
        />
      </TableContainer>

      <Dialog
        open={!!selectedAlert}
        onClose={() => setSelectedAlert(null)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>Alert Details</DialogTitle>
        <DialogContent>
          {selectedAlert && (
            <Grid container spacing={2}>
              <Grid item xs={12}>
                <Typography variant="h6">{selectedAlert.title}</Typography>
              </Grid>
              <Grid item xs={12} sm={6}>
                <Typography variant="subtitle2">Description</Typography>
                <Typography>{selectedAlert.description}</Typography>
              </Grid>
              <Grid item xs={12} sm={6}>
                <Typography variant="subtitle2">Source Details</Typography>
                <Typography>
                  {JSON.stringify(selectedAlert.sourceDetails, null, 2)}
                </Typography>
              </Grid>
              <Grid item xs={12}>
                <Typography variant="subtitle2">Related Alerts</Typography>
                {correlations.map((correlation) => (
                  <Chip
                    key={correlation.id}
                    label={correlation.title}
                    onClick={() => handleViewAlert(correlation)}
                    sx={{ m: 0.5 }}
                  />
                ))}
              </Grid>
            </Grid>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setSelectedAlert(null)}>Close</Button>
          <Button
            onClick={() => handleStatusChange(selectedAlert.id, 'investigating')}
            color="primary"
          >
            Start Investigation
          </Button>
          <Button
            onClick={() => handleStatusChange(selectedAlert.id, 'resolved')}
            color="success"
          >
            Mark as Resolved
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default AlertManagement;
