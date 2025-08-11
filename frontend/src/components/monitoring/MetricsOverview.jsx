import React from 'react';
import {
  Box,
  Grid,
  Card,
  CardContent,
  Typography,
  CircularProgress
} from '@mui/material';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import TrendingDownIcon from '@mui/icons-material/TrendingDown';

const MetricsCard = ({ title, value, trend, trendValue, icon: Icon }) => {
  const isTrendUp = trend === 'up';
  const trendColor = isTrendUp ? 'success.main' : 'error.main';

  return (
    <Card variant="outlined">
      <CardContent>
        <Box display="flex" alignItems="center" mb={1}>
          {Icon && <Icon color="primary" sx={{ mr: 1 }} />}
          <Typography variant="subtitle2" color="textSecondary">
            {title}
          </Typography>
        </Box>
        <Typography variant="h4" component="div">
          {value}
        </Typography>
        <Box display="flex" alignItems="center" mt={1}>
          {isTrendUp ? (
            <TrendingUpIcon sx={{ color: trendColor, mr: 0.5 }} />
          ) : (
            <TrendingDownIcon sx={{ color: trendColor, mr: 0.5 }} />
          )}
          <Typography
            variant="body2"
            sx={{ color: trendColor }}
          >
            {trendValue}%
          </Typography>
        </Box>
      </CardContent>
    </Card>
  );
};

const MetricsOverview = ({ data }) => {
  const {
    totalAlerts,
    criticalAlerts,
    resolvedAlerts,
    averageResponseTime,
    incidentsToday,
    systemHealth
  } = data;

  return (
    <Box>
      <Grid container spacing={2}>
        <Grid item xs={12}>
          <Card variant="outlined">
            <CardContent>
              <Typography variant="h6" gutterBottom>
                System Health
              </Typography>
              <Box display="flex" alignItems="center" justifyContent="center">
                <CircularProgress
                  variant="determinate"
                  value={systemHealth}
                  size={80}
                  thickness={4}
                  sx={{
                    color: systemHealth > 70 ? 'success.main' : 'error.main',
                  }}
                />
                <Typography
                  variant="h4"
                  component="div"
                  sx={{ position: 'absolute' }}
                >
                  {systemHealth}%
                </Typography>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6}>
          <MetricsCard
            title="Total Alerts"
            value={totalAlerts.value}
            trend={totalAlerts.trend}
            trendValue={totalAlerts.trendValue}
          />
        </Grid>

        <Grid item xs={12} sm={6}>
          <MetricsCard
            title="Critical Alerts"
            value={criticalAlerts.value}
            trend={criticalAlerts.trend}
            trendValue={criticalAlerts.trendValue}
          />
        </Grid>

        <Grid item xs={12} sm={6}>
          <MetricsCard
            title="Resolved Alerts"
            value={resolvedAlerts.value}
            trend={resolvedAlerts.trend}
            trendValue={resolvedAlerts.trendValue}
          />
        </Grid>

        <Grid item xs={12} sm={6}>
          <MetricsCard
            title="Average Response Time"
            value={`${averageResponseTime.value}m`}
            trend={averageResponseTime.trend}
            trendValue={averageResponseTime.trendValue}
          />
        </Grid>

        <Grid item xs={12}>
          <MetricsCard
            title="Incidents Today"
            value={incidentsToday.value}
            trend={incidentsToday.trend}
            trendValue={incidentsToday.trendValue}
          />
        </Grid>
      </Grid>
    </Box>
  );
};

export default MetricsOverview;
