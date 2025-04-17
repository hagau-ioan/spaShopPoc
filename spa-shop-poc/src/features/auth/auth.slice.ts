import { createSlice } from '@reduxjs/toolkit';

interface UauthState {
  loading: boolean;
  error: string | null;
}

const initialState: UauthState = {
  loading: false,
  error: null,
};

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    // Add reducers here
  },
});

export const authActions = authSlice.actions;
export default authSlice.reducer;
