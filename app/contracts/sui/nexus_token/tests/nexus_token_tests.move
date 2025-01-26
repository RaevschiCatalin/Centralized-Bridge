#[test_only]
module nexus_token::nexus_token_tests {
    use sui::test_scenario;
    use nexus_token::nexus_token::{Self, NexusToken, get_balance};

    // Define test addresses
    const DEPLOYER: address = @0x195db0a3f4e5651cd5f608cedd9b3bcb57895cce075f41382d29e4ac6b860ca7;
    const USER: address = @0x1;

    // Test minting functionality
    #[test]
    fun test_mint() {
        let mut scenario = test_scenario::begin(DEPLOYER);
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        let deployer = nexus_token::init_deployer(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        nexus_token::mint(USER, 1000, test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, USER);
        let nexus_token = test_scenario::take_from_address<NexusToken>(&scenario, USER);
        assert!(get_balance(&nexus_token) == 1000, 0);
        test_scenario::return_to_address(USER, nexus_token);
        nexus_token::delete_deployer(deployer);
        test_scenario::end(scenario);
    }

    // Test burning functionality
    #[test]
    fun test_burn() {
        let mut scenario = test_scenario::begin(DEPLOYER);
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        let deployer = nexus_token::init_deployer(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        nexus_token::mint(DEPLOYER, 1000, test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        let nexus_token = test_scenario::take_from_address<NexusToken>(&scenario, DEPLOYER);
        nexus_token::burn(nexus_token, test_scenario::ctx(&mut scenario));
        assert!(!test_scenario::has_most_recent_for_address<NexusToken>(DEPLOYER), 0);
        nexus_token::delete_deployer(deployer);
        test_scenario::end(scenario);
    }

    // Test locking functionality
    #[test]
    fun test_lock() {
        let mut scenario = test_scenario::begin(DEPLOYER);
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        let mut deployer = nexus_token::init_deployer(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        nexus_token::mint(USER, 1000, test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        nexus_token::lock(&mut deployer, USER, 500, test_scenario::ctx(&mut scenario));
        let locked_amount = nexus_token::get_locked_amount(&deployer, USER);
        assert!(locked_amount == 500, 0);
        nexus_token::delete_deployer(deployer);
        test_scenario::end(scenario);
    }

    // Test unlocking functionality
    #[test]
    fun test_unlock() {
        let mut scenario = test_scenario::begin(DEPLOYER);
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        let mut deployer = nexus_token::init_deployer(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        nexus_token::mint(USER, 1000, test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        nexus_token::lock(&mut deployer, USER, 500, test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, DEPLOYER);
        nexus_token::unlock(&mut deployer, USER, 300, test_scenario::ctx(&mut scenario));
        let locked_amount = nexus_token::get_locked_amount(&deployer, USER);
        assert!(locked_amount == 200, 0);
        nexus_token::delete_deployer(deployer);
        test_scenario::end(scenario);
    }
}