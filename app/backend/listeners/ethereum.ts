import { ethers } from 'ethers';
import { query } from '../database';
import dotenv from 'dotenv';
import NexusTokenABI from "../abis/NexusToken.json";

dotenv.config();

const ETH_RPC_URL = process.env.ETH_RPC_URL!;
const ETH_CONTRACT_ADDRESS = process.env.ETH_CONTRACT_ADDRESS!;

export async function startEthereumListener() {
  const provider = new ethers.JsonRpcProvider(ETH_RPC_URL);
  const contract = new ethers.Contract(ETH_CONTRACT_ADDRESS, NexusTokenABI, provider);

  contract.on('Locked', async (user: string, amount: string) => {
    console.log('Locked event detected:', { user, amount });

    const eventId = `${user}-${amount}`;
    const res = await query('SELECT * FROM processed_events WHERE event_identifier = $1', [eventId]);

    if (res.rowCount && res.rowCount > 0) {
      console.log('Event already processed:', eventId);
      return;
    }

    console.log('Processing event:', eventId);

    await query(
      'INSERT INTO processed_events (source_chain, event_identifier) VALUES ($1, $2)',
      ['ethereum', eventId]
    );
  });

  console.log('Ethereum listener started');
}