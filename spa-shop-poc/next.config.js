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
