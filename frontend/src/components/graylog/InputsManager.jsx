import React, { useEffect, useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Grid,
  Typography,
  Button,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import DeleteIcon from '@mui/icons-material/Delete';
import { useGraylogApi } from '../../hooks/useGraylogApi';

const InputsManager = () => {
  const [inputs, setInputs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [openDialog, setOpenDialog] = useState(false);
  const [newInput, setNewInput] = useState({
    title: '',
    type: 'tcp',
    configuration: {}
  });
  
  const graylogApi = useGraylogApi();

  const fetchInputs = async () => {
    setLoading(true);
    try {
      const data = await graylogApi.getInputs();
      setInputs(data);
    } catch (error) {
      console.error('Error fetching inputs:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInputs();
  }, []);

  const handleCreateInput = async () => {
    try {
      await graylogApi.createInput(newInput);
      setOpenDialog(false);
      fetchInputs();
    } catch (error) {
      console.error('Error creating input:', error);
    }
  };

  const handleDeleteInput = async (inputId) => {
    try {
      await graylogApi.deleteInput(inputId);
      fetchInputs();
    } catch (error) {
      console.error('Error deleting input:', error);
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Card>
        <CardContent>
          <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
            <Typography variant="h5" component="h2">
              Input Management
            </Typography>
            <Button
              startIcon={<AddIcon />}
              variant="contained"
              color="primary"
              onClick={() => setOpenDialog(true)}
            >
              Add Input
            </Button>
          </Box>

          <List>
            {inputs.map((input) => (
              <ListItem key={input.id}>
                <ListItemText
                  primary={input.title}
                  secondary={`Type: ${input.type} | Status: ${input.status}`}
                />
                <ListItemSecondaryAction>
                  <IconButton
                    edge="end"
                    aria-label="delete"
                    onClick={() => handleDeleteInput(input.id)}
                  >
                    <DeleteIcon />
                  </IconButton>
                </ListItemSecondaryAction>
              </ListItem>
            ))}
          </List>
        </CardContent>
      </Card>

      <Dialog open={openDialog} onClose={() => setOpenDialog(false)}>
        <DialogTitle>Create New Input</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Title"
                value={newInput.title}
                onChange={(e) => setNewInput({ ...newInput, title: e.target.value })}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Type"
                value={newInput.type}
                onChange={(e) => setNewInput({ ...newInput, type: e.target.value })}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
          <Button onClick={handleCreateInput} color="primary">
            Create
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default InputsManager;
