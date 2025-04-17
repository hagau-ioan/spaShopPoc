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
