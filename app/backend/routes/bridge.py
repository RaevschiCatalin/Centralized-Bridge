from fastapi import APIRouter, HTTPException
from schemas import BridgeRequest
from services.bridge_processor import process_pending_transactions

router = APIRouter()

@router.post("/initiate")
async def initiate_bridge(request: BridgeRequest):
    try:
        transaction = await process_pending_transactions(request)
        return {"message": "Transaction initiated", "tx_id": transaction.id}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))