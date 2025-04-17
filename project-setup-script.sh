#!/bin/bash
# Script to set up a Next.js project with TypeScript, Tailwind UI,
# RxDB, Redux Toolkit, Jest + React Testing Library, ESLint + Prettier, NextAuth.js

# Enable error handling
set -e

# Enable debug mode - shows commands as they execute
set -x

# Function to log steps
log_step() {
  echo "==================================="
  echo "STEP: $1"
  echo "==================================="
}

# Function to check file creation was successful
check_file() {
  if [ -f "$1" ]; then
    echo "✅ Successfully created: $1"
  else
    echo "❌ Failed to create: $1"
    echo "Checking write permissions and disk space..."
    touch test_write_permission.tmp
    if [ $? -eq 0 ]; then
      echo "Write permissions are OK"
      rm test_write_permission.tmp
    else
      echo "Failed to write to directory. Check permissions."
      exit 1
    fi
  fi
}

# Check if project name was provided
if [ -z "$1" ]; then
  echo "Please provide a project name"
  echo "Usage: ./setup-project.sh my-spa"
  exit 1
fi

PROJECT_NAME=$1
log_step "Setting up project: $PROJECT_NAME"

# Create the project using Next.js template
log_step "Creating Next.js project"
pnpm create next-app $PROJECT_NAME --typescript
cd $PROJECT_NAME

# Remove default Next.js files to start fresh
log_step "Cleaning up default files"
if [ -f "public/vercel.svg" ]; then
  echo "Removing default Vercel SVG..."
  rm -f public/vercel.svg
fi

# Create ext-resources directory for ExtJS if needed
mkdir -p public/ext-resources
check_file "public/ext-resources/.gitkeep"

# Install core dependencies
log_step "Installing core dependencies"
pnpm add react react-dom next

# Install TypeScript related dependencies
log_step "Installing TypeScript dependencies"
pnpm add typescript @types/react @types/react-dom @types/node -D

# Install Tailwind CSS and UI dependencies
log_step "Installing Tailwind CSS and UI dependencies"
pnpm add tailwindcss postcss autoprefixer -D
pnpm add @headlessui/react @heroicons/react

# Install RxDB and related packages
log_step "Installing RxDB and related packages"
pnpm add rxdb rxjs

# Install Redux Toolkit and React-Redux
log_step "Installing Redux Toolkit and React-Redux"
pnpm add @reduxjs/toolkit react-redux

# Install NextAuth.js
log_step "Installing NextAuth.js"
pnpm add next-auth

# Install testing libraries
log_step "Installing testing libraries"
pnpm add jest @testing-library/react @testing-library/jest-dom @testing-library/user-event jest-environment-jsdom ts-jest -D

# Install ESLint and Prettier
log_step "Installing ESLint and Prettier"
pnpm add eslint prettier eslint-config-next eslint-plugin-react @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier eslint-plugin-prettier -D

# Create project structure
log_step "Creating project structure"

# Create main directories
log_step "Creating main directories"
mkdir -p .github/workflows
mkdir -p docs/diagrams
mkdir -p scripts
mkdir -p src/{api/{endpoints,interceptors},assets/{images,fonts},components/ui,config,db/{schemas,queries},features/{auth,user,dashboard}/components,hooks,layouts,lib,pages,store,styles/tailwind,types,utils}

# Create basic files to ensure directories are tracked in git
log_step "Creating placeholder files for git tracking"
touch .github/workflows/.gitkeep
touch docs/architecture.md
touch docs/diagrams/.gitkeep
touch scripts/build.js
touch scripts/setup.js

# Create src structure
log_step "Creating API structure"
touch src/api/client.ts
touch src/api/endpoints/.gitkeep
touch src/api/interceptors/.gitkeep
touch src/assets/images/.gitkeep
touch src/assets/fonts/.gitkeep

# Create example component structure
log_step "Creating component structure"
mkdir -p src/components/ui/Button/__tests__
touch src/components/ui/Button/Button.tsx
touch src/components/ui/Button/index.ts
touch src/components/ui/Button/__tests__/Button.test.tsx

# Create config files
log_step "Creating config files"
touch src/config/constants.ts
touch src/config/environment.ts
touch src/config/routes.ts

# Create database related files
log_step "Creating database structure"
touch src/db/index.ts
touch src/db/schemas/.gitkeep
touch src/db/queries/.gitkeep

# Create feature related files
log_step "Creating feature structure"
for feature in auth user dashboard; do
  mkdir -p src/features/$feature/{__tests__,components,hooks}
  touch src/features/$feature/__tests__/.gitkeep
  touch src/features/$feature/components/.gitkeep
  touch src/features/$feature/hooks/.gitkeep
  touch src/features/$feature/${feature}Slice.ts
  touch src/features/$feature/index.ts
done

# Add NextAuth configuration
touch src/features/auth/nextauth.ts

# Create hooks
log_step "Creating hooks"
mkdir -p src/hooks/__tests__
touch src/hooks/__tests__/.gitkeep
touch src/hooks/useAuth.ts
touch src/hooks/useApi.ts

# Create layouts
log_step "Creating layouts"
touch src/layouts/MainLayout.tsx
touch src/layouts/AuthLayout.tsx

# Create utility files
log_step "Creating utility files"
touch src/lib/extjs.ts
touch src/lib/formatters.ts
touch src/lib/validation.ts

# Set up Next.js pages
log_step "Creating Next.js pages structure"
mkdir -p src/pages/api/auth
mkdir -p src/pages/dashboard
touch src/pages/_app.tsx
touch src/pages/_document.tsx
touch src/pages/index.tsx
touch src/pages/login.tsx
touch src/pages/dashboard/index.tsx
touch src/pages/api/auth/[...nextauth].ts
mkdir -p src/pages/__tests__
touch src/pages/__tests__/.gitkeep

# Create store files
log_step "Creating store files"
touch src/store/index.ts
touch src/store/middleware.ts

# Create style files
log_step "Creating style files"
touch src/styles/globals.css
touch src/styles/tailwind/.gitkeep
touch src/styles/variables.css

# Create type definitions
log_step "Creating type definitions"
touch src/types/api.ts
touch src/types/index.ts

# Create utility files
log_step "Creating utility files"
mkdir -p src/utils/__tests__
touch src/utils/__tests__/.gitkeep
touch src/utils/helpers.ts

# Create configuration files
log_step "Creating configuration files"

# Create ESLint configuration
log_step "Creating ESLint configuration"
cat > .eslintrc.js << 'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  extends: [
    'next/core-web-vitals',
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended'
  ],
  plugins: ['@typescript-eslint', 'react', 'prettier'],
  rules: {
    'react/react-in-jsx-scope': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off'
  }
};
EOF
check_file ".eslintrc.js"

# Create Prettier configuration
log_step "Creating Prettier configuration"
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
EOF
check_file ".prettierrc"

# Create Jest configuration
log_step "Creating Jest configuration"
cat > jest.config.ts << 'EOF'
import type { Config } from 'jest';
import nextJest from 'next/jest';

const createJestConfig = nextJest({
  dir: './',
});

const config: Config = {
  testEnvironment: 'jest-environment-jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  testPathIgnorePatterns: ['<rootDir>/node_modules/', '<rootDir>/.next/'],
};

export default createJestConfig(config);
EOF
check_file "jest.config.ts"

# Create Jest setup file
log_step "Creating Jest setup file"
cat > jest.setup.ts << 'EOF'
import '@testing-library/jest-dom';
EOF
check_file "jest.setup.ts"

# Create Tailwind configuration
log_step "Creating Tailwind configuration"
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx}',
    './pages/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}',
    './app/**/*.{js,ts,jsx,tsx}',
    './features/**/*.{js,ts,jsx,tsx}',
    './layouts/**/*.{js,ts,jsx,tsx}'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF
check_file "tailwind.config.js"

# Create PostCSS configuration
log_step "Creating PostCSS configuration"
cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
EOF
check_file "postcss.config.js"

# Create TypeScript configuration
log_step "Creating TypeScript configuration"
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF
check_file "tsconfig.json"

# Create environment files
log_step "Creating environment files"

# Create standard .env file
log_step "Creating .env file"
cat > .env << 'EOF'
# Next Auth
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=base_secret_key_override_in_env_local

# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:3000/api
API_TIMEOUT=5000
API_KEY=base_backend_api_key

# Database Configuration
DATABASE_URL=postgresql://postgres:password@localhost:5432/myapp
MONGODB_URI=mongodb://localhost:27017/myapp

# RxDB Configuration
RXDB_ENCRYPTION_KEY=base_encryption_key

# Feature Flags
NEXT_PUBLIC_ENABLE_NEW_DASHBOARD=false
NEXT_PUBLIC_ENABLE_BETA_FEATURES=false
EOF
check_file ".env"

# Create .env.example file with mock values
log_step "Creating .env.example file"
cat > .env.example << 'EOF'
# Next Auth
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-nextauth-secret

# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:3000/api
API_TIMEOUT=5000
API_KEY=mock_backend_api_key_12345

# Database Configuration
DATABASE_URL=postgresql://postgres:password@localhost:5432/myapp
MONGODB_URI=mongodb://localhost:27017/myapp

# RxDB Configuration
RXDB_ENCRYPTION_KEY=mock_encryption_key_98765

# Feature Flags
NEXT_PUBLIC_ENABLE_NEW_DASHBOARD=true
NEXT_PUBLIC_ENABLE_BETA_FEATURES=false
EOF
check_file ".env.example"

# Create actual .env.local file (for immediate use, gitignored)
log_step "Creating .env.local file"
cat > .env.local << 'EOF'
# Next Auth
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=development_secret_key_replace_in_production

# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:3000/api
API_TIMEOUT=5000
API_KEY=dev_backend_api_key_12345

# Database Configuration
DATABASE_URL=postgresql://postgres:password@localhost:5432/myapp
MONGODB_URI=mongodb://localhost:27017/myapp

# RxDB Configuration
RXDB_ENCRYPTION_KEY=dev_encryption_key_98765

# Feature Flags
NEXT_PUBLIC_ENABLE_NEW_DASHBOARD=true
NEXT_PUBLIC_ENABLE_BETA_FEATURES=true
EOF
check_file ".env.local"

# Create environment.ts file
log_step "Creating environment.ts file"
cat > src/config/environment.ts << 'EOF'
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
EOF
check_file "src/config/environment.ts"

# Create a .npmrc file to handle build scripts
log_step "Creating .npmrc file"
cat > .npmrc << 'EOF'
# Allow specific packages to run build scripts
public-hoist-pattern[]=*@firebase/util*
public-hoist-pattern[]=*protobufjs*
public-hoist-pattern[]=*rxdb*
public-hoist-pattern[]=*sharp*

# Alternative approach using allow-scripts
allow-scripts[@firebase/util]=true
allow-scripts[protobufjs]=true
allow-scripts[rxdb]=true
allow-scripts[sharp]=true

# Or enable for all packages (less secure but easier):
# unsafe-perm=true
EOF
check_file ".npmrc"

# We'll also set up a post-install script to automatically approve these packages
log_step "Creating approve-builds.js script"
mkdir -p scripts
cat > scripts/approve-builds.js << 'EOF'
#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Packages we want to approve
const packagesToApprove = [
  '@firebase/util',
  'protobufjs',
  'rxdb',
  'sharp'
];

try {
  // Try to execute the command silently to approve builds
  console.log('Attempting to approve build scripts for required packages...');
  
  // Create a temporary script to feed input to pnpm approve-builds
  const tempFile = path.join(__dirname, 'temp-approve-input.txt');
  
  // Create input that will select all of our packages (y) and then exit (q)
  const inputText = packagesToApprove.map(() => 'y').join('\n') + '\nq\n';
  fs.writeFileSync(tempFile, inputText);
  
  // Run the approve-builds command with our input
  execSync('cat ' + tempFile + ' | pnpm approve-builds', { 
    stdio: 'inherit',
    shell: true
  });
  
  // Clean up
  fs.unlinkSync(tempFile);
  console.log('Successfully approved build scripts.');
} catch (error) {
  console.log('Could not automatically approve builds. You may need to run:');
  console.log('  pnpm approve-builds');
  console.log('And approve the following packages:');
  packagesToApprove.forEach(pkg => console.log('  - ' + pkg));
}
EOF
check_file "scripts/approve-builds.js"

# Make the script executable
chmod +x scripts/approve-builds.js

# Create a basic _app.tsx
log_step "Creating _app.tsx"
cat > src/pages/_app.tsx << 'EOF'
import { Provider } from 'react-redux';
import { SessionProvider } from 'next-auth/react';
import { store } from '@/store';
import '@/styles/globals.css';
import type { AppProps } from 'next/app';

function MyApp({ Component, pageProps: { session, ...pageProps } }: AppProps) {
  return (
    <SessionProvider session={session}>
      <Provider store={store}>
        <Component {...pageProps} />
      </Provider>
    </SessionProvider>
  );
}

export default MyApp;
EOF
check_file "src/pages/_app.tsx"

# Create _document.tsx
log_step "Creating _document.tsx"
cat > src/pages/_document.tsx << 'EOF'
import { Html, Head, Main, NextScript } from 'next/document';

export default function Document() {
  return (
    <Html lang="en">
      <Head />
      <body>
        <Main />
        <NextScript />
      </body>
    </Html>
  );
}
EOF
check_file "src/pages/_document.tsx"

# Create a basic index page
log_step "Creating index.tsx"
cat > src/pages/index.tsx << 'EOF'
import React from 'react';
import MainLayout from '@/layouts/MainLayout';
import { NextPage } from 'next';

const HomePage: NextPage = () => {
  return (
    <MainLayout>
      <div className="bg-white p-8 rounded-lg shadow">
        <h2 className="text-2xl font-bold mb-4">Welcome to your SPA</h2>
        <p className="text-gray-600">
          This is a starter template for your Next.js SPA with TypeScript, Tailwind UI,
          RxDB, Redux Toolkit, and more.
        </p>
      </div>
    </MainLayout>
  );
};

export default HomePage;
EOF
check_file "src/pages/index.tsx"

# Create an example NextAuth API route
log_step "Creating [...nextauth].ts"
cat > src/pages/api/auth/[...nextauth].ts << 'EOF'
import NextAuth from 'next-auth';
import { authOptions } from '@/features/auth/nextauth';

export default NextAuth(authOptions);
EOF
check_file "src/pages/api/auth/[...nextauth].ts"

# Create an example Redux store setup
log_step "Creating store/index.ts"
cat > src/store/index.ts << 'EOF'
import { configureStore } from '@reduxjs/toolkit';
import { setupListeners } from '@reduxjs/toolkit/query';
import authReducer from '../features/auth/authSlice';
import userReducer from '../features/user/userSlice';
import dashboardReducer from '../features/dashboard/dashboardSlice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    user: userReducer,
    dashboard: dashboardReducer,
  },
  middleware: (getDefaultMiddleware) => 
    getDefaultMiddleware({
      serializableCheck: false,
    }),
});

setupListeners(store.dispatch);

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
EOF
check_file "src/store/index.ts"

# Create a gitignore file
log_step "Creating .gitignore"
cat > .gitignore << 'EOF'
# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build
/dist

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# local env files
.env.local
.env.development.local
.env.test.local
.env.production.local
.env

# vercel
.vercel

# IDE
.idea
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
EOF
check_file ".gitignore"

# Create a README.md file
log_step "Creating README.md"
cat > README.md << EOF
# $PROJECT_NAME

A modern Single Page Application built with Next.js, TypeScript, Tailwind UI, RxDB, Redux Toolkit, and more.

## Features

- Next.js for server-rendered React applications
- TypeScript for type safety
- Tailwind UI for styling
- RxDB for offline-first database
- Redux Toolkit for state management
- NextAuth.js for authentication
- Jest and React Testing Library for testing
- ESLint and Prettier for code quality

## Project Structure

The project follows a feature-based architecture with clear separation of concerns.

## Getting Started

\`\`\`bash
# Install dependencies
pnpm install

# Start development server
pnpm dev

# Build for production
pnpm build

# Run tests
pnpm test
\`\`\`

## License

[MIT](LICENSE)
EOF
check_file "README.md"

# Update next.config.js
log_step "Creating next.config.js"
cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  // Configure paths from src directory
  pageExtensions: ['tsx', 'ts'],
  eslint: {
    dirs: ['src'],
  },
};

module.exports = nextConfig;
EOF
check_file "next.config.js"

# Create globals.css
log_step "Creating globals.css"
cat > src/styles/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Custom global styles go here */
EOF
check_file "src/styles/globals.css"

# Update package.json scripts
log_step "Updating package.json"
# Update package.json scripts
# Create a new package.json with updated scripts
node -e "
  const fs = require('fs');
  try {
    console.log('Reading package.json...');
    const pkg = JSON.parse(fs.readFileSync('./package.json'));
    
    console.log('Updating scripts in package.json...');
    // Merge the scripts
    pkg.scripts = {
      'dev': 'next dev',
      'build': 'next build',
      'start': 'next start',
      'lint': 'eslint \"**/*.{ts,tsx}\"',
      'format': 'prettier --write \"**/*.{ts,tsx,js,json,css}\"',
      'test': 'jest',
      'test:watch': 'jest --watch',
      'postinstall': 'node scripts/approve-builds.js'
    };
    
    console.log('Writing updated package.json...');
    // Write the updated package.json
    fs.writeFileSync('./package.json', JSON.stringify(pkg, null, 2));
    console.log('Successfully updated package.json');
  } catch (error) {
    console.error('Error updating package.json:', error.message);
  }
"



# Create basic feature slices
log_step "Creating feature slices"
for feature in auth user dashboard
do
  # Capitalize the first letter of the feature
  feature_name=$(echo "${feature}" | sed 's/^\(.\)/\U\1/')

  cat <<EOF > "src/features/${feature}/${feature}.slice.ts"
import { createSlice } from '@reduxjs/toolkit';

interface ${feature_name}State {
  loading: boolean;
  error: string | null;
}

const initialState: ${feature_name}State = {
  loading: false,
  error: null,
};

const ${feature}Slice = createSlice({
  name: '${feature}',
  initialState,
  reducers: {
    // Add reducers here
  },
});

export const ${feature}Actions = ${feature}Slice.actions;
export default ${feature}Slice.reducer;
EOF
done


# Create a basic NextAuth.js configuration
log_step "Creating nextauth.ts"
cat > src/features/auth/nextauth.ts << 'EOF'
import { NextAuthOptions } from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        username: { label: 'Username', type: 'text' },
        password: { label: 'Password', type: 'password' }
      },
      async authorize(credentials) {
        // Add your authentication logic here
        if (credentials?.username === 'user' && credentials?.password === 'password') {
          return { id: '1', name: 'User', email: 'user@example.com' };
        }
        return null;
      }
    })
  ],
  session: {
    strategy: 'jwt',
  },
  pages: {
    signIn: '/login',
  },
  secret: process.env.NEXTAUTH_SECRET,
};

export default authOptions;
EOF
check_file "src/features/auth/nextauth.ts"

# Create example MainLayout
log_step "Creating MainLayout.tsx"
cat > src/layouts/MainLayout.tsx << 'EOF'
import React from 'react';

interface MainLayoutProps {
  children: React.ReactNode;
}

const MainLayout: React.FC<MainLayoutProps> = ({ children }) => {
  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        </div>
      </header>
      <main>
        <div className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
          {children}
        </div>
      </main>
    </div>
  );
};

export default MainLayout;
EOF
check_file "src/layouts/MainLayout.tsx"

# Add RxDB setup
log_step "Creating db/index.ts"
cat > src/db/index.ts << 'EOF'
import { createRxDatabase, addRxPlugin } from 'rxdb';
import { getRxStorageDexie } from 'rxdb/plugins/storage-dexie';
// Import your schemas here
// import { userSchema } from './schemas/userSchema';

export const setupDatabase = async () => {
  const db = await createRxDatabase({
    name: 'my_spa_db',
    storage: getRxStorageDexie(),
  });
  
  // Add your collections here
  // const collections = await db.addCollections({
  //   users: {
  //     schema: userSchema
  //   }
  // });
  
  return db;
};

export default setupDatabase;
EOF
check_file "src/db/index.ts"




log_step "Project setup complete!"
echo ""
echo "Project setup complete! Your new project structure is ready in: $PROJECT_NAME"
echo ""
echo "To get started:"
echo "cd $PROJECT_NAME"
echo "pnpm install"
echo "pnpm dev"

# Disable debug mode
set +x