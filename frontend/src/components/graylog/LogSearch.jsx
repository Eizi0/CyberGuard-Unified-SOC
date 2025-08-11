import React, { useEffect, useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Grid,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  TextField,
  Button,
  IconButton
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import RefreshIcon from '@mui/icons-material/Refresh';
import { useGraylogApi } from '../../hooks/useGraylogApi';

const LogSearch = () => {
  const [query, setQuery] = useState('');
  const [timeRange, setTimeRange] = useState('15m');
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(false);
  const graylogApi = useGraylogApi();

  const handleSearch = async () => {
    setLoading(true);
    try {
      const data = await graylogApi.searchMessages(query, { range: timeRange });
      setMessages(data);
    } catch (error) {
      console.error('Error searching messages:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = () => {
    handleSearch();
  };

  return (
    <Box sx={{ p: 3 }}>
      <Card>
        <CardContent>
          <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
            <Typography variant="h5" component="h2">
              Log Search
            </Typography>
            <Button
              startIcon={<RefreshIcon />}
              onClick={handleRefresh}
              disabled={loading}
            >
              Refresh
            </Button>
          </Box>

          <Grid container spacing={2} sx={{ mb: 3 }}>
            <Grid item xs={9}>
              <TextField
                fullWidth
                label="Search Query"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
              />
            </Grid>
            <Grid item xs={2}>
              <TextField
                fullWidth
                label="Time Range"
                value={timeRange}
                onChange={(e) => setTimeRange(e.target.value)}
              />
            </Grid>
            <Grid item xs={1}>
              <IconButton 
                color="primary" 
                onClick={handleSearch}
                disabled={loading}
                size="large"
              >
                <SearchIcon />
              </IconButton>
            </Grid>
          </Grid>

          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Timestamp</TableCell>
                  <TableCell>Source</TableCell>
                  <TableCell>Message</TableCell>
                  <TableCell>Level</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {messages.map((message) => (
                  <TableRow key={message.id}>
                    <TableCell>
                      {new Date(message.timestamp).toLocaleString()}
                    </TableCell>
                    <TableCell>{message.source}</TableCell>
                    <TableCell>{message.message}</TableCell>
                    <TableCell>{message.level}</TableCell>
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

export default LogSearch;
