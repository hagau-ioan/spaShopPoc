# Next.js Project Setup Guide

This guide covers how to use the `setup-project.sh` script to create a feature-rich Next.js project with TypeScript, Tailwind, Redux, RxDB, NextAuth, and testing tools.

## Prerequisites

Before running the script, make sure you have the following installed:

- Node.js (16.x or higher recommended)
- pnpm (if not installed, run `npm install -g pnpm`)
- Bash shell (comes with macOS and Linux, Git Bash or WSL on Windows)

## Setup Process

### 1. Create the script file

Save the script content to a file named `setup-project.sh`.

### 2. Make the script executable

```bash
chmod +x setup-project.sh
```

### 3. Run the script with your project name

```bash
./setup-project.sh my-project-name
```

Replace `my-project-name` with your desired project name.

### 4. Navigate to the project directory

```bash
cd my-project-name
```

### 5. Install dependencies

```bash
pnpm install
```

### 6. Start the development server

```bash
pnpm dev
```

Your project will be available at http://localhost:3000

## Available Commands

Once your project is set up, you can use these commands:

| Command | Description |
| ------- | ----------- |
| `pnpm dev -p 4000` | Start development server on a specific port |
| `pnpm dev  --turbo` | Start development server with Turbopack |
| `pnpm build` | Build for production |
| `pnpm build --analyze` | Build and analyze bundle |
| `pnpm start` | Start production server |
| `pnpm lint` | Run ESLint on the project |
| `pnpm format` | Run Prettier to format code |
| `pnpm test` | Run Jest tests |
| `pnpm test --coverage` | Run tests with coverage |
| `pnpm test:watch` | Run tests in watch mode |

## Troubleshooting

### "pnpm: command not found"

If you encounter this error, install pnpm first:

```bash
npm install -g pnpm
```

### Permission denied

If you encounter permission issues when running the script:

```bash
chmod +x setup-project.sh
```

### Next.js or Node.js version issues

The script assumes recent versions of Next.js and Node.js. If you encounter compatibility issues, check that you're using Node.js 16 or higher.

## Project Structure

The script creates a well-organized project structure:

```
my-project-name/
├── src/                       
│   ├── api/                   # API client & endpoints
│   ├── assets/                # Images, fonts, etc.
│   ├── components/            # Reusable UI components
│   ├── config/                # Application configuration
│   ├── db/                    # RxDB setup & schemas
│   ├── features/              # Feature modules with Redux slices
│   ├── hooks/                 # Custom React hooks
│   ├── layouts/               # Page layout components
│   ├── lib/                   # Utility libraries
│   ├── pages/                 # Next.js pages & API routes
│   ├── store/                 # Redux store configuration
│   ├── styles/                # Global styles & Tailwind
│   ├── types/                 # TypeScript type definitions
│   └── utils/                 # Utility functions
├── tests/                     # Test configuration
└── [config files]             # Various configuration files
```

## Customization

After setup, you can customize your project by:

1. Updating the Tailwind configuration in `tailwind.config.js`
2. Configuring NextAuth in `src/features/auth/nextauth.ts`
3. Adding RxDB schemas in `src/db/schemas/`
4. Creating additional Redux slices in the features directory
