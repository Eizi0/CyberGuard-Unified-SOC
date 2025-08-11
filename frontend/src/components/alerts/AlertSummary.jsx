import React from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Grid,
  Chip,
  LinearProgress
} from '@mui/material';

const severityColors = {
  critical: 'error',
  high: 'error',
  medium: 'warning',
  low: 'info',
  info: 'success'
};

const AlertSummary = ({ data }) => {
  const { recentAlerts, alertsBySource, severityDistribution } = data;

  return (
    <Box>
      <Grid container spacing={2}>
        {/* Severity Distribution */}
        <Grid item xs={12}>
          <Card variant="outlined">
            <CardContent>
              <Typography variant="subtitle1" gutterBottom>
                Alert Severity Distribution
              </Typography>
              <Grid container spacing={1}>
                {Object.entries(severityDistribution).map(([severity, count]) => (
                  <Grid item xs={12} key={severity}>
                    <Box mb={1}>
                      <Box display="flex" justifyContent="space-between" mb={0.5}>
                        <Typography variant="body2">
                          {severity.charAt(0).toUpperCase() + severity.slice(1)}
                        </Typography>
                        <Typography variant="body2">
                          {count.percentage}%
                        </Typography>
                      </Box>
                      <LinearProgress
                        variant="determinate"
                        value={count.percentage}
                        color={severityColors[severity]}
                        sx={{ height: 8, borderRadius: 4 }}
                      />
                    </Box>
                  </Grid>
                ))}
              </Grid>
            </CardContent>
          </Card>
        </Grid>

        {/* Alerts by Source */}
        <Grid item xs={12}>
          <Card variant="outlined">
            <CardContent>
              <Typography variant="subtitle1" gutterBottom>
                Alerts by Source
              </Typography>
              <Box display="flex" flexWrap="wrap" gap={1}>
                {Object.entries(alertsBySource).map(([source, count]) => (
                  <Chip
                    key={source}
                    label={`${source}: ${count}`}
                    color="primary"
                    variant="outlined"
                  />
                ))}
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Recent Critical Alerts */}
        <Grid item xs={12}>
          <Card variant="outlined">
            <CardContent>
              <Typography variant="subtitle1" gutterBottom>
                Recent Critical Alerts
              </Typography>
              <Grid container spacing={1}>
                {recentAlerts.map((alert, index) => (
                  <Grid item xs={12} key={index}>
                    <Card variant="outlined">
                      <CardContent>
                        <Box display="flex" justifyContent="space-between" alignItems="center">
                          <Typography variant="body2">
                            {alert.title}
                          </Typography>
                          <Chip
                            size="small"
                            label={alert.severity}
                            color={severityColors[alert.severity.toLowerCase()]}
                          />
                        </Box>
                        <Typography variant="caption" color="textSecondary">
                          {new Date(alert.timestamp).toLocaleString()}
                        </Typography>
                      </CardContent>
                    </Card>
                  </Grid>
                ))}
              </Grid>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default AlertSummary;
