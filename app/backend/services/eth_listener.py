from web3 import Web3
from models import BridgeTransaction, ChainState
from database import SessionLocal


class EthListener:
    def __init__(self):
        self.w3 = Web3(Web3.HTTPProvider(config.ETH_RPC_URL))
        self.contract = self.w3.eth.contract(
            address=config.ETH_CONTRACT_ADDRESS,
            abi=config.ETH_CONTRACT_ABI
        )

    async def listen_events(self):
        while True:
            db = SessionLocal()
            last_block = db.query(ChainState).filter_by(chain_name='ethereum').first().last_block
            current_block = self.w3.eth.block_number

            if current_block > last_block:
                events = self.contract.events.Locked.get_logs(
                    fromBlock=last_block + 1,
                    toBlock=current_block
                )

                for event in events:
                    self.handle_lock_event(event)

                # Update last processed block
                db.query(ChainState).filter_by(chain_name='ethereum').update({'last_block': current_block})
                db.commit()

            await asyncio.sleep(config.ETH_POLL_INTERVAL)

    def handle_lock_event(self, event):
        db = SessionLocal()
        tx = BridgeTransaction(
            tx_hash=event.transactionHash.hex(),
            user_address=event.args.user,
            amount=event.args.amount,
            source_chain='ethereum',
            dest_chain='sui',
            status='pending'
        )
        db.add(tx)
        db.commit()