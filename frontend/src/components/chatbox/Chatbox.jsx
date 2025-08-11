import React, { useState, useEffect } from 'react';
import {
  Box,
  TextField,
  Button,
  Paper,
  Typography,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Slider,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
} from '@mui/material';
import SendIcon from '@mui/icons-material/Send';
import SettingsIcon from '@mui/icons-material/Settings';
import { useAuth } from '../../hooks/useAuth';
import { api } from '../../services/api';

export const Chatbox = () => {
  const { user } = useAuth();
  const [message, setMessage] = useState('');
  const [context, setContext] = useState('');
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(false);
  const [config, setConfig] = useState(null);
  const [openSettings, setOpenSettings] = useState(false);
  const [provider, setProvider] = useState('openai');
  const [apiKey, setApiKey] = useState('');
  const [model, setModel] = useState('');
  const [temperature, setTemperature] = useState(0.7);

  useEffect(() => {
    fetchConfig();
    fetchHistory();
  }, []);

  const fetchConfig = async () => {
    try {
      const response = await api.get('/chatbox/config');
      setConfig(response.data);
      setProvider(response.data.provider);
      setModel(response.data.default_model);
      setTemperature(response.data.temperature);
    } catch (error) {
      console.error('Error fetching config:', error);
    }
  };

  const fetchHistory = async () => {
    try {
      const response = await api.get('/chatbox/history');
      setMessages(response.data);
    } catch (error) {
      console.error('Error fetching history:', error);
    }
  };

  const handleSend = async () => {
    if (!message.trim()) return;

    try {
      setLoading(true);
      const response = await api.post('/chatbox/chat', {
        message,
        context: context || undefined,
        model,
        temperature,
      });

      setMessages([
        ...messages,
        {
          message,
          response: response.data.message,
          model: response.data.model,
          created_at: response.data.created_at,
        },
      ]);
      setMessage('');
    } catch (error) {
      console.error('Error sending message:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSaveConfig = async () => {
    try {
      await api.post('/chatbox/config', {
        provider,
        api_key: apiKey,
        default_model: model,
        temperature,
      });
      setOpenSettings(false);
      fetchConfig();
    } catch (error) {
      console.error('Error saving config:', error);
    }
  };

  return (
    <Box sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <Box sx={{ p: 2, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <Typography variant="h6">AI Assistant</Typography>
        {user?.isAdmin && (
          <Button
            startIcon={<SettingsIcon />}
            onClick={() => setOpenSettings(true)}
          >
            Settings
          </Button>
        )}
      </Box>

      <Paper
        sx={{
          flex: 1,
          mb: 2,
          mx: 2,
          p: 2,
          overflow: 'auto',
          backgroundColor: 'background.default',
        }}
      >
        {messages.map((msg, index) => (
          <Box key={index} sx={{ mb: 2 }}>
            <Box sx={{ display: 'flex', mb: 1 }}>
              <Typography
                variant="body1"
                sx={{ fontWeight: 'bold', color: 'primary.main' }}
              >
                You:
              </Typography>
            </Box>
            <Typography variant="body1" sx={{ ml: 2, mb: 2 }}>
              {msg.message}
            </Typography>
            <Box sx={{ display: 'flex', mb: 1 }}>
              <Typography
                variant="body1"
                sx={{ fontWeight: 'bold', color: 'secondary.main' }}
              >
                Assistant:
              </Typography>
            </Box>
            <Typography variant="body1" sx={{ ml: 2 }}>
              {msg.response}
            </Typography>
          </Box>
        ))}
      </Paper>

      <Box sx={{ p: 2 }}>
        <TextField
          fullWidth
          multiline
          rows={2}
          variant="outlined"
          placeholder="Enter your message..."
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          sx={{ mb: 2 }}
        />
        <TextField
          fullWidth
          variant="outlined"
          placeholder="Optional context..."
          value={context}
          onChange={(e) => setContext(e.target.value)}
          sx={{ mb: 2 }}
        />
        <Button
          fullWidth
          variant="contained"
          color="primary"
          endIcon={<SendIcon />}
          onClick={handleSend}
          disabled={loading || !message.trim()}
        >
          {loading ? 'Sending...' : 'Send'}
        </Button>
      </Box>

      <Dialog open={openSettings} onClose={() => setOpenSettings(false)}>
        <DialogTitle>Chatbox Settings</DialogTitle>
        <DialogContent>
          <FormControl fullWidth sx={{ mt: 2 }}>
            <InputLabel>Provider</InputLabel>
            <Select
              value={provider}
              onChange={(e) => setProvider(e.target.value)}
              label="Provider"
            >
              <MenuItem value="openai">OpenAI</MenuItem>
              <MenuItem value="anthropic">Anthropic</MenuItem>
            </Select>
          </FormControl>

          <TextField
            fullWidth
            type="password"
            label="API Key"
            value={apiKey}
            onChange={(e) => setApiKey(e.target.value)}
            sx={{ mt: 2 }}
          />

          <FormControl fullWidth sx={{ mt: 2 }}>
            <InputLabel>Default Model</InputLabel>
            <Select
              value={model}
              onChange={(e) => setModel(e.target.value)}
              label="Default Model"
            >
              {provider === 'openai' ? (
                <>
                  <MenuItem value="gpt-4">GPT-4</MenuItem>
                  <MenuItem value="gpt-3.5-turbo">GPT-3.5 Turbo</MenuItem>
                </>
              ) : (
                <>
                  <MenuItem value="claude-2">Claude 2</MenuItem>
                  <MenuItem value="claude-instant-1">Claude Instant</MenuItem>
                </>
              )}
            </Select>
          </FormControl>

          <Box sx={{ mt: 2 }}>
            <Typography gutterBottom>Temperature</Typography>
            <Slider
              value={temperature}
              onChange={(_, value) => setTemperature(value)}
              min={0}
              max={1}
              step={0.1}
              valueLabelDisplay="auto"
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenSettings(false)}>Cancel</Button>
          <Button onClick={handleSaveConfig} variant="contained">
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};
