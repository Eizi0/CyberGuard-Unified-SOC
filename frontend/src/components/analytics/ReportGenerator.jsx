import React, { useState, useEffect } from 'react';
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
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  IconButton,
} from '@mui/material';
import DownloadIcon from '@mui/icons-material/Download';
import EmailIcon from '@mui/icons-material/Email';
import { useApi } from '../../hooks/useApi';
import { useSnackbar } from '../../contexts/SnackbarContext';

const ReportGenerator = () => {
  const [reportType, setReportType] = useState('executive');
  const [timeFrame, setTimeFrame] = useState('weekly');
  const [generatedReports, setGeneratedReports] = useState([]);
  const [loading, setLoading] = useState(false);

  const api = useApi();
  const { showMessage } = useSnackbar();

  useEffect(() => {
    fetchReports();
  }, []);

  const fetchReports = async () => {
    try {
      const data = await api.get('/reports');
      setGeneratedReports(data);
    } catch (error) {
      showMessage('Failed to fetch reports', 'error');
    }
  };

  const generateReport = async () => {
    setLoading(true);
    try {
      const report = await api.post('/reports/generate', {
        type: reportType,
        timeFrame,
      });
      showMessage('Report generated successfully', 'success');
      fetchReports();
    } catch (error) {
      showMessage('Failed to generate report', 'error');
    } finally {
      setLoading(false);
    }
  };

  const downloadReport = async (reportId) => {
    try {
      const response = await api.get(`/reports/${reportId}/download`, {
        responseType: 'blob',
      });
      
      // Create blob link to download
      const url = window.URL.createObjectURL(new Blob([response]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `report-${reportId}.pdf`);
      document.body.appendChild(link);
      link.click();
      link.parentNode.removeChild(link);
    } catch (error) {
      showMessage('Failed to download report', 'error');
    }
  };

  const emailReport = async (reportId) => {
    try {
      await api.post(`/reports/${reportId}/email`);
      showMessage('Report sent successfully', 'success');
    } catch (error) {
      showMessage('Failed to email report', 'error');
    }
  };

  return (
    <Box p={3}>
      <Typography variant="h5" gutterBottom>
        Report Generator
      </Typography>

      <Grid container spacing={3}>
        {/* Report Generation Form */}
        <Grid item xs={12}>
          <Paper sx={{ p: 2 }}>
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} md={4}>
                <FormControl fullWidth>
                  <InputLabel>Report Type</InputLabel>
                  <Select
                    value={reportType}
                    onChange={(e) => setReportType(e.target.value)}
                  >
                    <MenuItem value="executive">Executive Summary</MenuItem>
                    <MenuItem value="technical">Technical Analysis</MenuItem>
                    <MenuItem value="compliance">Compliance Report</MenuItem>
                    <MenuItem value="incident">Incident Report</MenuItem>
                    <MenuItem value="threat">Threat Intelligence Report</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} md={4}>
                <FormControl fullWidth>
                  <InputLabel>Time Frame</InputLabel>
                  <Select
                    value={timeFrame}
                    onChange={(e) => setTimeFrame(e.target.value)}
                  >
                    <MenuItem value="daily">Daily</MenuItem>
                    <MenuItem value="weekly">Weekly</MenuItem>
                    <MenuItem value="monthly">Monthly</MenuItem>
                    <MenuItem value="quarterly">Quarterly</MenuItem>
                    <MenuItem value="yearly">Yearly</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} md={4}>
                <Button
                  variant="contained"
                  color="primary"
                  onClick={generateReport}
                  disabled={loading}
                  fullWidth
                >
                  {loading ? 'Generating...' : 'Generate Report'}
                </Button>
              </Grid>
            </Grid>
          </Paper>
        </Grid>

        {/* Generated Reports Table */}
        <Grid item xs={12}>
          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Report Name</TableCell>
                  <TableCell>Type</TableCell>
                  <TableCell>Time Frame</TableCell>
                  <TableCell>Generated On</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {generatedReports.map((report) => (
                  <TableRow key={report.id}>
                    <TableCell>{report.name}</TableCell>
                    <TableCell>{report.type}</TableCell>
                    <TableCell>{report.timeFrame}</TableCell>
                    <TableCell>
                      {new Date(report.generatedAt).toLocaleString()}
                    </TableCell>
                    <TableCell>{report.status}</TableCell>
                    <TableCell>
                      <IconButton
                        onClick={() => downloadReport(report.id)}
                        disabled={report.status !== 'completed'}
                      >
                        <DownloadIcon />
                      </IconButton>
                      <IconButton
                        onClick={() => emailReport(report.id)}
                        disabled={report.status !== 'completed'}
                      >
                        <EmailIcon />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Grid>
      </Grid>
    </Box>
  );
};

export default ReportGenerator;
