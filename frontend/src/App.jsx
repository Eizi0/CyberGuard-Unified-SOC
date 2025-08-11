import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';

import Layout from './layouts/Layout';
import Dashboard from './components/Dashboard';
import AgentsList from './components/wazuh/AgentsList';
import AlertsList from './components/wazuh/AlertsList';

// Create a theme instance
const theme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
    background: {
      default: '#121212',
      paper: '#1e1e1e',
    },
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/wazuh" element={<AgentsList />} />
            <Route path="/wazuh/alerts" element={<AlertsList />} />
            {/* Add more routes for other components */}
          </Routes>
        </Layout>
      </Router>
    </ThemeProvider>
  );
}

export default App;
