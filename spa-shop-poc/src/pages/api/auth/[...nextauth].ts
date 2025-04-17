import NextAuth from 'next-auth';
import { authOptions } from '@/features/auth/nextauth';

export default NextAuth(authOptions);
