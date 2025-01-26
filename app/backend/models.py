from sqlalchemy import Column, Integer, String, Numeric, DateTime
from database import Base


class BridgeTransaction(Base):
    __tablename__ = "bridge_transactions"

    id = Column(Integer, primary_key=True)
    tx_hash = Column(String(255), unique=True)
    user_address = Column(String(255))
    amount = Column(Numeric(36, 18))
    source_chain = Column(String(50))
    dest_chain = Column(String(50))
    status = Column(String(20), default='pending')
    created_at = Column(DateTime)
    completed_at = Column(DateTime)
    nonce = Column(Integer)


class ChainState(Base):
    __tablename__ = "chain_states"

    id = Column(Integer, primary_key=True)
    chain_name = Column(String(50), unique=True)
    last_block = Column(Integer, default=0)