/**
 * Centralized environment configuration
 * Provides typed access to environment variables with defaults
 */
export const environment = {
  api: {
    url: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api',
    timeout: parseInt(process.env.API_TIMEOUT || '5000'),
    key: process.env.API_KEY,
  },
  auth: {
    nextAuthUrl: process.env.NEXTAUTH_URL,
    nextAuthSecret: process.env.NEXTAUTH_SECRET,
  },
  database: {
    postgresUrl: process.env.DATABASE_URL,
    mongoDbUri: process.env.MONGODB_URI,
    rxDbEncryptionKey: process.env.RXDB_ENCRYPTION_KEY,
  },
  features: {
    enableNewDashboard: process.env.NEXT_PUBLIC_ENABLE_NEW_DASHBOARD === 'true',
    enableBetaFeatures: process.env.NEXT_PUBLIC_ENABLE_BETA_FEATURES === 'true',
  },
  // Helper function to validate required environment variables
  validate: () => {
    const required = [
      'NEXTAUTH_URL',
      'NEXTAUTH_SECRET',
      'NEXT_PUBLIC_API_URL',
    ];
    
    const missing = required.filter(
      (key) => !process.env[key]
    );
    
    if (missing.length > 0) {
      throw new Error(
        `Missing required environment variables: ${missing.join(', ')}`
      );
    }
    
    return true;
  },
};

export default environment;
