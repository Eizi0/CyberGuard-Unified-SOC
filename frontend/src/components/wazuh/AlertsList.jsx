import { useState, useEffect } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  Button
} from '@mui/material';
import RefreshIcon from '@mui/icons-material/Refresh';
import { useWazuhApi } from '../../hooks/useWazuhApi';

const AlertsList = () => {
  const [alerts, setAlerts] = useState([]);
  const [loading, setLoading] = useState(true);
  const wazuhApi = useWazuhApi();

  const fetchAlerts = async () => {
    setLoading(true);
    try {
      const data = await wazuhApi.getAlerts();
      setAlerts(data);
    } catch (error) {
      console.error('Error fetching alerts:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = () => {
    fetchAlerts();
  };

  useEffect(() => {
    fetchAlerts();
  }, []);

  const getLevelColor = (level) => {
    switch (true) {
      case level >= 12:
        return 'error';
      case level >= 8:
        return 'warning';
      case level >= 4:
        return 'info';
      default:
        return 'default';
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Card>
        <CardContent>
          <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
            <Typography variant="h5" component="h2">
              Wazuh Alerts
            </Typography>
            <Button
              startIcon={<RefreshIcon />}
              onClick={handleRefresh}
              disabled={loading}
            >
              Refresh
            </Button>
          </Box>
          
          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Timestamp</TableCell>
                  <TableCell>Rule ID</TableCell>
                  <TableCell>Level</TableCell>
                  <TableCell>Description</TableCell>
                  <TableCell>Agent</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {alerts.map((alert) => (
                  <TableRow key={alert.id}>
                    <TableCell>{new Date(alert.timestamp).toLocaleString()}</TableCell>
                    <TableCell>{alert.rule.id}</TableCell>
                    <TableCell>
                      <Chip
                        label={alert.rule.level}
                        color={getLevelColor(alert.rule.level)}
                        size="small"
                      />
                    </TableCell>
                    <TableCell>{alert.rule.description}</TableCell>
                    <TableCell>{alert.agent.name}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </CardContent>
      </Card>
    </Box>
  );
};

export default AlertsList;
