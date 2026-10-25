PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS contracts (
    contract_id TEXT PRIMARY KEY,
    tax_rule_id TEXT NOT NULL,
    currency TEXT NOT NULL CHECK (currency = 'BRL')
);

CREATE TABLE IF NOT EXISTS tax_rules (
    tax_rule_id TEXT PRIMARY KEY,
    tax_type TEXT NOT NULL,
    rate REAL NOT NULL CHECK (rate >= 0 AND rate <= 1),
    effective_from TEXT NOT NULL,
    effective_to TEXT
);

CREATE TABLE IF NOT EXISTS investment_operations (
    operation_id TEXT PRIMARY KEY,
    contract_id TEXT NOT NULL REFERENCES contracts(contract_id),
    event_date TEXT NOT NULL,
    principal_cents INTEGER NOT NULL CHECK (principal_cents >= 0),
    status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS taxation_events (
    tax_event_id TEXT PRIMARY KEY,
    operation_id TEXT NOT NULL REFERENCES investment_operations(operation_id),
    tax_type TEXT NOT NULL,
    taxable_base_cents INTEGER NOT NULL CHECK (taxable_base_cents >= 0),
    processed_tax_cents INTEGER NOT NULL CHECK (processed_tax_cents >= 0)
);

CREATE TABLE IF NOT EXISTS accounting_entries (
    entry_id TEXT PRIMARY KEY,
    operation_id TEXT NOT NULL REFERENCES investment_operations(operation_id),
    event_date TEXT NOT NULL,
    amount_cents INTEGER NOT NULL,
    account_code TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS integration_events (
    integration_event_id TEXT PRIMARY KEY,
    operation_id TEXT NOT NULL REFERENCES investment_operations(operation_id),
    destination TEXT NOT NULL,
    status TEXT NOT NULL,
    occurred_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS reconciliation_results (
    reconciliation_id TEXT PRIMARY KEY,
    operation_id TEXT NOT NULL REFERENCES investment_operations(operation_id),
    expected_cents INTEGER NOT NULL,
    processed_cents INTEGER NOT NULL,
    difference_cents INTEGER NOT NULL,
    observed_at TEXT NOT NULL
);
