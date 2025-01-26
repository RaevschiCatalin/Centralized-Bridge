from web3 import Web3
from sui import SuiClient
from models import BridgeTransaction
from database import SessionLocal


class BridgeProcessor:
    def __init__(self):
        self.eth_w3 = Web3(Web3.HTTPProvider(config.ETH_RPC_URL))
        self.sui_client = SuiClient(config.SUI_RPC_URL)

    async def process_pending_transactions(self):
        db = SessionLocal()
        pending_txs = db.query(BridgeTransaction).filter_by(status='pending').all()

        for tx in pending_txs:
            try:
                if tx.source_chain == 'ethereum' and tx.dest_chain == 'sui':
                    # Mint tokens on Sui
                    self.sui_client.mint(
                        tx.user_address,
                        tx.amount,
                        config.SUI_DEPLOYER_ADDRESS
                    )
                    tx.status = 'completed'
                elif tx.source_chain == 'sui' and tx.dest_chain == 'ethereum':
                    # Unlock tokens on Ethereum
                    contract = self.eth_w3.eth.contract(
                        address=config.ETH_CONTRACT_ADDRESS,
                        abi=config.ETH_CONTRACT_ABI
                    )
                    tx = contract.functions.unlock(
                        tx.user_address,
                        tx.amount
                    ).build_transaction({
                        'from': config.ETH_DEPLOYER_ADDRESS,
                        'nonce': self.eth_w3.eth.get_transaction_count(config.ETH_DEPLOYER_ADDRESS)
                    })
                    signed_tx = self.eth_w3.eth.account.sign_transaction(
                        tx, config.ETH_PRIVATE_KEY
                    )
                    tx_hash = self.eth_w3.eth.send_raw_transaction(signed_tx.rawTransaction)
                    tx.status = 'completed'

                db.commit()
            except Exception as e:
                tx.status = 'failed'
                db.commit()
                print(f"Error processing transaction {tx.id}: {str(e)}")