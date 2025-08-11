import React from 'react';
import {
  Box,
  Grid,
  Card,
  CardContent,
  Typography,
  LinearProgress
} from '@mui/material';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import ErrorIcon from '@mui/icons-material/Error';
import WarningIcon from '@mui/icons-material/Warning';

const ServiceStatus = ({ data }) => {
  const getStatusIcon = (status) => {
    switch (status.toLowerCase()) {
      case 'healthy':
        return <CheckCircleIcon color="success" />;
      case 'warning':
        return <WarningIcon color="warning" />;
      case 'error':
        return <ErrorIcon color="error" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status) => {
    switch (status.toLowerCase()) {
      case 'healthy':
        return 'success.main';
      case 'warning':
        return 'warning.main';
      case 'error':
        return 'error.main';
      default:
        return 'grey.500';
    }
  };

  return (
    <Box>
      <Grid container spacing={2}>
        {Object.entries(data).map(([service, status]) => (
          <Grid item xs={12} key={service}>
            <Card variant="outlined">
              <CardContent>
                <Box display="flex" alignItems="center" mb={1}>
                  {getStatusIcon(status.status)}
                  <Typography variant="subtitle1" sx={{ ml: 1 }}>
                    {service}
                  </Typography>
                </Box>
                <Box display="flex" alignItems="center">
                  <Box flexGrow={1} mr={2}>
                    <LinearProgress
                      variant="determinate"
                      value={status.health}
                      sx={{
                        height: 8,
                        borderRadius: 4,
                        backgroundColor: 'grey.200',
                        '& .MuiLinearProgress-bar': {
                          backgroundColor: getStatusColor(status.status),
                        },
                      }}
                    />
                  </Box>
                  <Typography variant="body2" color="textSecondary">
                    {status.health}%
                  </Typography>
                </Box>
                {status.message && (
                  <Typography variant="body2" color="textSecondary" mt={1}>
                    {status.message}
                  </Typography>
                )}
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default ServiceStatus;
