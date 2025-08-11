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
  TextField,
  Switch,
  FormControlLabel,
  CircularProgress,
} from '@mui/material';
import { useApi } from '../../hooks/useApi';
import { useSnackbar } from '../../contexts/SnackbarContext';

const ServiceConfiguration = () => {
  const [services, setServices] = useState({});
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const api = useApi();
  const { showMessage } = useSnackbar();

  useEffect(() => {
    fetchServiceConfigs();
  }, []);

  const fetchServiceConfigs = async () => {
    try {
      const configs = await api.get('/services/config');
      setServices(configs);
    } catch (error) {
      showMessage('Failed to fetch service configurations', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleConfigChange = (serviceName, field, value) => {
    setServices(prev => ({
      ...prev,
      [serviceName]: {
        ...prev[serviceName],
        config: {
          ...prev[serviceName].config,
          [field]: value
        }
      }
    }));
  };

  const handleToggleService = (serviceName) => {
    setServices(prev => ({
      ...prev,
      [serviceName]: {
        ...prev[serviceName],
        enabled: !prev[serviceName].enabled
      }
    }));
  };

  const saveServiceConfig = async (serviceName) => {
    setSaving(true);
    try {
      await api.put(`/services/${serviceName}/config`, services[serviceName]);
      showMessage(`${serviceName} configuration saved successfully`, 'success');
    } catch (error) {
      showMessage(`Failed to save ${serviceName} configuration`, 'error');
    } finally {
      setSaving(false);
    }
  };

  const testConnection = async (serviceName) => {
    try {
      const result = await api.post(`/services/${serviceName}/test`);
      showMessage(result.message, result.success ? 'success' : 'error');
    } catch (error) {
      showMessage(`Connection test failed for ${serviceName}`, 'error');
    }
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box p={3}>
      <Typography variant="h5" gutterBottom>
        Service Configuration
      </Typography>

      <Grid container spacing={3}>
        {Object.entries(services).map(([serviceName, serviceData]) => (
          <Grid item xs={12} md={6} key={serviceName}>
            <Card>
              <CardContent>
                <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                  <Typography variant="h6">
                    {serviceName.charAt(0).toUpperCase() + serviceName.slice(1)}
                  </Typography>
                  <FormControlLabel
                    control={
                      <Switch
                        checked={serviceData.enabled}
                        onChange={() => handleToggleService(serviceName)}
                        color="primary"
                      />
                    }
                    label={serviceData.enabled ? 'Enabled' : 'Disabled'}
                  />
                </Box>

                {Object.entries(serviceData.config).map(([field, value]) => (
                  <TextField
                    key={field}
                    label={field.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
                    fullWidth
                    margin="normal"
                    value={value}
                    onChange={(e) => handleConfigChange(serviceName, field, e.target.value)}
                    type={field.includes('password') || field.includes('key') ? 'password' : 'text'}
                    disabled={!serviceData.enabled}
                  />
                ))}
              </CardContent>
              <CardActions>
                <Button
                  size="small"
                  color="primary"
                  onClick={() => saveServiceConfig(serviceName)}
                  disabled={!serviceData.enabled || saving}
                >
                  Save Configuration
                </Button>
                <Button
                  size="small"
                  onClick={() => testConnection(serviceName)}
                  disabled={!serviceData.enabled || saving}
                >
                  Test Connection
                </Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default ServiceConfiguration;
