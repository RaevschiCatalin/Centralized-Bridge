#[test_only]
module nexus_token::nexus_token_tests {
    use sui::test_scenario;
    use nexus_token::nexus_token::{Self, NexusToken, LockedBalance, get_locked_amount, get_balance};

    // Define test addresses
    const DEPLOYER: address = @0x195db0a3f4e5651cd5f608cedd9b3bcb57895cce075f41382d29e4ac6b860ca7; // Deployer address
const USER: address = @0x1; // User address

    // Test minting functionality
    #[test]
    fun test_mint() {
        let mut scenario = test_scenario::begin(DEPLOYER); // Start scenario with deployer

        // Mint tokens to USER (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        nexus_token::mint(USER, 1000, test_scenario::ctx(&mut scenario));

        // Verify the minted tokens
        test_scenario::next_tx(&mut scenario, USER); // Simulate a new transaction with USER as sender
        let nexus_token = test_scenario::take_from_address<NexusToken>(&scenario, USER);
        assert!(get_balance(&nexus_token) == 1000, 0);

        // Return the object to the USER address
        test_scenario::return_to_address(USER, nexus_token);

        test_scenario::end(scenario);
    }

    // Test burning functionality
    #[test]
    fun test_burn() {
        let mut scenario = test_scenario::begin(DEPLOYER); // Start scenario with deployer

        // Mint tokens to DEPLOYER (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        nexus_token::mint(DEPLOYER, 1000, test_scenario::ctx(&mut scenario));

        // Burn tokens (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        let nexus_token = test_scenario::take_from_address<NexusToken>(&scenario, DEPLOYER);
        nexus_token::burn(nexus_token, test_scenario::ctx(&mut scenario));

        // Verify the tokens are burned
        assert!(!test_scenario::has_most_recent_for_address<NexusToken>(DEPLOYER), 0);

        test_scenario::end(scenario);
    }

    // Test locking functionality
    #[test]
    fun test_lock() {
        let mut scenario = test_scenario::begin(DEPLOYER); // Start scenario with deployer

        // Mint tokens to USER (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        nexus_token::mint(USER, 1000, test_scenario::ctx(&mut scenario));

        // Lock tokens (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        nexus_token::lock(USER, 500, test_scenario::ctx(&mut scenario));

        // Verify the locked tokens
        test_scenario::next_tx(&mut scenario, USER); // Simulate a new transaction with USER as sender
        let locked_balance = test_scenario::take_from_address<LockedBalance>(&scenario, USER);
        assert!(get_locked_amount(&locked_balance) == 500, 0);

        // Return the object to the USER address
        test_scenario::return_to_address(USER, locked_balance);

        test_scenario::end(scenario);
    }

    // Test unlocking functionality
    #[test]
    fun test_unlock() {
        let mut scenario = test_scenario::begin(DEPLOYER); // Start scenario with deployer

        // Mint tokens to USER (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        nexus_token::mint(USER, 1000, test_scenario::ctx(&mut scenario));

        // Lock tokens (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        nexus_token::lock(USER, 500, test_scenario::ctx(&mut scenario));

        // Unlock tokens (must be called by DEPLOYER)
        test_scenario::next_tx(&mut scenario, DEPLOYER); // Simulate a new transaction with DEPLOYER as sender
        nexus_token::unlock(USER, 300, test_scenario::ctx(&mut scenario));

        // Verify the unlocked tokens
        test_scenario::next_tx(&mut scenario, USER); // Simulate a new transaction with USER as sender
        let locked_balance = test_scenario::take_from_address<LockedBalance>(&scenario, USER);
        assert!(get_locked_amount(&locked_balance) == 200, 0); // 500 - 300 = 200

        // Return the object to the USER address
        test_scenario::return_to_address(USER, locked_balance);

        test_scenario::end(scenario);
    }
}