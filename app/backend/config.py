import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    # Ethereum
    eth_rpc_url: str
    eth_contract_address: str
    eth_deployer_address: str
    eth_private_key: str

    # Sui
    sui_rpc_url: str
    sui_contract_address: str
    sui_deployer_address: str

    # Database
    postgres_user: str
    postgres_password: str
    postgres_db: str
    postgres_host: str
    postgres_port: str

    # App
    eth_poll_interval: int = 15
    sui_poll_interval: int = 10

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"

config = Settings()