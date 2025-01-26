import { SuiClient, getFullnodeUrl } from '@mysten/sui/client';
import { MIST_PER_SUI } from '@mysten/sui/utils';
import { WebSocket } from 'ws';


if (typeof window === 'undefined') {
  globalThis.WebSocket = WebSocket as any;
}

const httpClient = new SuiClient({ url: getFullnodeUrl('testnet') });
const websocketClient = new SuiClient({
  url: getFullnodeUrl('testnet').replace('http', 'ws'),
  WebSocketClass: WebSocket
});

export const suiService = {
  // Existing balance functionality
  async getBalance(address: string) {
    try {
      const result = await httpClient.getBalance({ owner: address });
      return Number(result.totalBalance) / Number(MIST_PER_SUI);
    } catch (error) {
      console.error("Balance error:", error);
      throw new Error("Failed to fetch balance");
    }
  },


  async listenForEvents(packageId: string, eventType: string, callback: (event: any) => void) {
    const unsubscribe = await websocketClient.subscribeEvent({
      filter: {
        MoveEventType: `${packageId}::${eventType}`,
      },
      onMessage(event) {
        try {
          const parsed = this.parseEvent(event);
          callback(parsed);
        } catch (error) {
          console.error("Event processing error:", error);
        }
      },
      onError(error) {
        console.error("Subscription error:", error);
      }
    });

    return unsubscribe;
  },


  parseEvent(event: any) {
    return {
      txDigest: event.id.txDigest,
      sender: event.sender,
      parsed: event.parsedJson
    };
  }
};


async function main() {

  const balance = await suiService.getBalance('0x...');
  console.log(`Balance: ${balance.toFixed(2)} SUI`);


  const unsubscribe = await suiService.listenForEvents(
    process.env.SUI_PACKAGE_ID!,
    'nexus_token::LockEvent',
    (event) => {
      console.log('New lock event:', event);

    }
  );


}