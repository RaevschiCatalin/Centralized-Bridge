from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class BridgeRequest(BaseModel):
    user_address: str
    amount: float
    source_chain: str
    dest_chain: str

class BridgeTransactionResponse(BaseModel):
    id: int
    tx_hash: str
    user_address: str
    amount: float
    source_chain: str
    dest_chain: str
    status: str
    created_at: datetime
    completed_at: Optional[datetime]
    nonce: Optional[int]

    class Config:
        orm_mode = True