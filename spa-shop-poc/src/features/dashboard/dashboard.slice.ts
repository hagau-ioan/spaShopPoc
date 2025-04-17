import { createSlice } from '@reduxjs/toolkit';

interface UdashboardState {
  loading: boolean;
  error: string | null;
}

const initialState: UdashboardState = {
  loading: false,
  error: null,
};

const dashboardSlice = createSlice({
  name: 'dashboard',
  initialState,
  reducers: {
    // Add reducers here
  },
});

export const dashboardActions = dashboardSlice.actions;
export default dashboardSlice.reducer;
