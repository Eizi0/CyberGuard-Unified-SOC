import React from 'react';
import {
  Box,
  Typography,
  Timeline,
  TimelineItem,
  TimelineSeparator,
  TimelineConnector,
  TimelineContent,
  TimelineDot
} from '@mui/material';
import { format } from 'date-fns';

const getSeverityColor = (severity) => {
  switch (severity.toLowerCase()) {
    case 'critical':
      return '#ff1744';
    case 'high':
      return '#f44336';
    case 'medium':
      return '#ff9800';
    case 'low':
      return '#ffeb3b';
    default:
      return '#4caf50';
  }
};

const AlertTimeline = ({ data }) => {
  return (
    <Box>
      <Timeline>
        {data.map((alert, index) => (
          <TimelineItem key={index}>
            <TimelineSeparator>
              <TimelineDot sx={{ bgcolor: getSeverityColor(alert.severity) }} />
              {index < data.length - 1 && <TimelineConnector />}
            </TimelineSeparator>
            <TimelineContent>
              <Typography variant="subtitle2">
                {alert.title}
              </Typography>
              <Typography variant="body2" color="textSecondary">
                {format(new Date(alert.timestamp), 'PP pp')}
              </Typography>
              <Typography variant="body2">
                Source: {alert.source}
              </Typography>
              {alert.description && (
                <Typography variant="body2" color="textSecondary">
                  {alert.description}
                </Typography>
              )}
            </TimelineContent>
          </TimelineItem>
        ))}
      </Timeline>
      {data.length === 0 && (
        <Box textAlign="center" py={2}>
          <Typography variant="body2" color="textSecondary">
            No recent alerts
          </Typography>
        </Box>
      )}
    </Box>
  );
};

export default AlertTimeline;
