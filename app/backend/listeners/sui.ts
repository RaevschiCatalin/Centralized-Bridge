// import { SuiClient, getFullnodeUrl } from '@mysten/sui/client';
// import { query } from '../database';
// import dotenv from 'dotenv';
// import { WebSocket } from 'ws';
//
// dotenv.config();
//
// const SUI_RPC_URL = process.env.SUI_RPC_URL || getFullnodeUrl('testnet');
// const SUI_PACKAGE_ID = process.env.SUI_PACKAGE_ID!;
// const SUI_DEPLOYER_ID = process.env.SUI_DEPLOYER_ID!;
// globalThis.WebSocket = WebSocket as any;
// // Create Sui client
// const client = new SuiClient({ url: SUI_RPC_URL });
// console.log(client)
// export async function startSuiListener() {
//   console.log('Starting Sui listener...');
//
//   // Subscribe to LockEvent events from your Move contract
//   const unsubscribe = await client.subscribeEvent({
//     filter: {
//       MoveEventType: `${SUI_PACKAGE_ID}::nexus_token::LockEvent`,
//     },
//     onMessage(event) {
//       handleLockEvent(event).catch(console.error);
//     },
//   });
//
//   console.log('Sui listener started');
//   return unsubscribe;
// }
//
// async function handleLockEvent(event: any) {
//   try {
//     const parsedEvent = event.parsedJson as {
//       user: string;
//       amount: string;
//     };
//
//     console.log('LockEvent detected:', parsedEvent);
//
//     // Create unique event identifier
//     const eventId = `${parsedEvent.user}-${parsedEvent.amount}-${event.id.txDigest}-${event.id.eventSeq}`;
//
//     // Check if event was already processed
//     const res = await query(
//       'SELECT * FROM processed_events WHERE event_identifier = $1',
//       [eventId]
//     );
//
//     if (res.rowCount && res.rowCount > 0) {
//       console.log('Event already processed:', eventId);
//       return;
//     }
//
//     console.log('Processing Sui lock event:', eventId);
//
//     // Store in database
//     await query(
//       'INSERT INTO processed_events (source_chain, event_identifier) VALUES ($1, $2)',
//       ['sui', eventId]
//     );
//
//     // Here you would add logic to mint tokens on Ethereum
//     console.log(`Should unlock ${parsedEvent.amount} tokens for ${parsedEvent.user} on Ethereum`);
//
//   } catch (error) {
//     console.error('Error processing Sui event:', error);
//   }
// }