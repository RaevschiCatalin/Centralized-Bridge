import { startEthereumListener } from './listeners/ethereum';
// import { startSuiListener } from './listeners/sui';

async function main() {
  console.log('Starting bridge backend...');
  await startEthereumListener();
  // await startSuiListener();
}

main().catch((err) => {
  console.error('Error in main:', err);
  process.exit(1);
});