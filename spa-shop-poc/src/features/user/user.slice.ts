import { createSlice } from '@reduxjs/toolkit';

interface UuserState {
  loading: boolean;
  error: string | null;
}

const initialState: UuserState = {
  loading: false,
  error: null,
};

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    // Add reducers here
  },
});

export const userActions = userSlice.actions;
export default userSlice.reducer;
