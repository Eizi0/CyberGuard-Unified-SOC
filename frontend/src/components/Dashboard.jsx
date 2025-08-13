import React from 'react';
import { Grid, Card, CardContent, Typography, Box } from '@mui/material';
import { useWazuhApi } from '../hooks/useWazuhApi';
import csuLogo from '../assets/csu-logo.png';

const DashboardMetric = ({ title, value, color }) => (
  <Card sx={{ height: '100%' }}>
    <CardContent>
      <Typography variant="h6" component="div" gutterBottom>
        {title}
      </Typography>
      <Typography variant="h4" component="div" color={color}>
        {value}
      </Typography>
    </CardContent>
  </Card>
);

const Dashboard = () => {
  // Add hooks for each service here
  const wazuhApi = useWazuhApi();

  return (
    <Box sx={{ flexGrow: 1, p: 3 }}>
      {/* Header with Logo */}
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 4 }}>
        <img 
          src={csuLogo} 
          alt="CSU Logo" 
          style={{ 
            height: '60px', 
            width: 'auto',
            marginRight: '16px'
          }} 
        />
        <Box>
          <Typography variant="h4" gutterBottom sx={{ mb: 0 }}>
            CyberGuard Unified SOC
          </Typography>
          <Typography variant="subtitle1" color="text.secondary">
            Security Operations Center Dashboard
          </Typography>
        </Box>
      </Box>
      
      <Grid container spacing={3}>
        {/* Wazuh Metrics */}
        <Grid item xs={12} md={3}>
          <DashboardMetric
            title="Total Agents"
            value="25"
            color="primary.main"
          />
        </Grid>
        <Grid item xs={12} md={3}>
          <DashboardMetric
            title="Critical Alerts"
            value="3"
            color="error.main"
          />
        </Grid>
        <Grid item xs={12} md={3}>
          <DashboardMetric
            title="Active Cases"
            value="7"
            color="warning.main"
          />
        </Grid>
        <Grid item xs={12} md={3}>
          <DashboardMetric
            title="Total IoCs"
            value="152"
            color="info.main"
          />
        </Grid>

        {/* Add more metric cards for other services */}
        
        {/* Charts and other visualizations will be added here */}
      </Grid>
    </Box>
  );
};

export default Dashboard;
