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
