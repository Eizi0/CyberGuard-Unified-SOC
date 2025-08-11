import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination,
  Button,
  IconButton,
  Chip,
  Typography,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
} from '@mui/material';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { useApi } from '../../hooks/useApi';
import { useSnackbar } from '../../contexts/SnackbarContext';
import CaseDialog from './CaseDialog';

const statusColors = {
  new: 'info',
  'in-progress': 'warning',
  resolved: 'success',
  closed: 'default',
};

const CaseManagement = () => {
  const [cases, setCases] = useState([]);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedCase, setSelectedCase] = useState(null);
  const [deleteConfirmOpen, setDeleteConfirmOpen] = useState(false);
  const api = useApi();
  const { showMessage } = useSnackbar();

  useEffect(() => {
    fetchCases();
  }, []);

  const fetchCases = async () => {
    try {
      const data = await api.get('/cases');
      setCases(data);
    } catch (error) {
      showMessage('Failed to fetch cases', 'error');
    }
  };

  const handleCreateCase = () => {
    setSelectedCase(null);
    setOpenDialog(true);
  };

  const handleEditCase = (caseData) => {
    setSelectedCase(caseData);
    setOpenDialog(true);
  };

  const handleDeleteCase = (caseData) => {
    setSelectedCase(caseData);
    setDeleteConfirmOpen(true);
  };

  const confirmDelete = async () => {
    try {
      await api.delete(`/cases/${selectedCase.id}`);
      showMessage('Case deleted successfully', 'success');
      fetchCases();
    } catch (error) {
      showMessage('Failed to delete case', 'error');
    }
    setDeleteConfirmOpen(false);
    setSelectedCase(null);
  };

  const handleDialogClose = () => {
    setOpenDialog(false);
    setSelectedCase(null);
  };

  const handleSaveCase = async (caseData) => {
    try {
      if (selectedCase) {
        await api.put(`/cases/${selectedCase.id}`, caseData);
        showMessage('Case updated successfully', 'success');
      } else {
        await api.post('/cases', caseData);
        showMessage('Case created successfully', 'success');
      }
      fetchCases();
      handleDialogClose();
    } catch (error) {
      showMessage('Failed to save case', 'error');
    }
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  return (
    <Box p={3}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h5">Case Management</Typography>
        <Button variant="contained" color="primary" onClick={handleCreateCase}>
          Create New Case
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Title</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Severity</TableCell>
              <TableCell>Assignee</TableCell>
              <TableCell>Created</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {cases
              .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
              .map((caseItem) => (
                <TableRow key={caseItem.id}>
                  <TableCell>{caseItem.id}</TableCell>
                  <TableCell>{caseItem.title}</TableCell>
                  <TableCell>
                    <Chip
                      label={caseItem.status}
                      color={statusColors[caseItem.status]}
                      size="small"
                    />
                  </TableCell>
                  <TableCell>
                    <Chip
                      label={caseItem.severity}
                      color={caseItem.severity === 'high' ? 'error' : 'warning'}
                      size="small"
                    />
                  </TableCell>
                  <TableCell>{caseItem.assignee}</TableCell>
                  <TableCell>
                    {new Date(caseItem.createdAt).toLocaleDateString()}
                  </TableCell>
                  <TableCell>
                    <IconButton
                      size="small"
                      onClick={() => handleEditCase(caseItem)}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      size="small"
                      onClick={() => handleDeleteCase(caseItem)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))}
          </TableBody>
        </Table>
        <TablePagination
          rowsPerPageOptions={[5, 10, 25]}
          component="div"
          count={cases.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </TableContainer>

      <CaseDialog
        open={openDialog}
        onClose={handleDialogClose}
        onSave={handleSaveCase}
        caseData={selectedCase}
      />

      <Dialog open={deleteConfirmOpen} onClose={() => setDeleteConfirmOpen(false)}>
        <DialogTitle>Confirm Delete</DialogTitle>
        <DialogContent>
          Are you sure you want to delete this case?
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDeleteConfirmOpen(false)}>Cancel</Button>
          <Button onClick={confirmDelete} color="error">
            Delete
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default CaseManagement;
