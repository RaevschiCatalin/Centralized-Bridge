module nexus_token::tests {
    use sui::coin::{TreasuryCap, balance};
    use sui::tx_context::TxContext;

    #[test]
    fun test_token_operations(ctx: &mut TxContext) {
        let cap = TreasuryCap<NexusToken>{};
        let alice = 0xA1;
        let bob = 0xB2;

        let alice_balance = balance<NexusToken>(&cap);
        assert!(alice_balance.amount == 0, "Alice should have 0 tokens");

        // Example adjustments for balance checks
        let bob_balance = balance<NexusToken>(&cap);
        assert!(bob_balance.amount == 1000, "Bob should have 1000 tokens");
    }

}
