from sui import SuiClient
from models import BridgeTransaction, ChainState
from database import SessionLocal


class SuiListener:
    def __init__(self):
        self.client = SuiClient(config.SUI_RPC_URL)

    async def listen_events(self):
        while True:
            db = SessionLocal()
            last_checkpoint = db.query(ChainState).filter_by(chain_name='sui').first().last_block
            current_checkpoint = self.client.get_latest_checkpoint()

            if current_checkpoint > last_checkpoint:
                events = self.client.query_events(
                    event_type="UnlockEvent",
                    start_checkpoint=last_checkpoint + 1,
                    end_checkpoint=current_checkpoint
                )

                for event in events:
                    self.handle_unlock_event(event)

                # Update last processed checkpoint
                db.query(ChainState).filter_by(chain_name='sui').update({'last_block': current_checkpoint})
                db.commit()

            await asyncio.sleep(config.SUI_POLL_INTERVAL)

    def handle_unlock_event(self, event):
        db = SessionLocal()
        tx = BridgeTransaction(
            tx_hash=event.id.tx_digest,
            user_address=event.parsed_json.user,
            amount=event.parsed_json.amount,
            source_chain='sui',
            dest_chain='ethereum',
            status='pending'
        )
        db.add(tx)
        db.commit()