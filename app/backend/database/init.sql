-- Table for address mapping
CREATE TABLE IF NOT EXISTS address_mapping (
    id SERIAL PRIMARY KEY,
    eth_address CHAR(42) NOT NULL,
    sui_address VARCHAR(66) NOT NULL,
    UNIQUE(eth_address),
    UNIQUE(sui_address)
);

-- Table for processed events
CREATE TABLE IF NOT EXISTS processed_events (
    id SERIAL PRIMARY KEY,
    source_chain VARCHAR(20) NOT NULL,
    event_identifier VARCHAR(255) NOT NULL,
    processed_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(source_chain, event_identifier)
);