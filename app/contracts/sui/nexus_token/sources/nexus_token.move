module nexus_token::nexus_token {
    use sui::transfer::{Self, Receiving};
    const DEPLOYER_ADDRESS: address = @0x195db0a3f4e5651cd5f608cedd9b3bcb57895cce075f41382d29e4ac6b860ca7;

    public struct NexusToken has key, store {
        id: UID,
        balance: u64,
    }

    public struct LockedBalance has key, store {
        id: UID,
        user: address,
        amount: u64,
    }

    /// /// /// /// /// ///
    /// minting tokens ///
    /// /// /// /// /// ///
    public fun mint(to: address, amount: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);
        let nexus_token = NexusToken {
            id: object::new(ctx),
            balance: amount,
        };
        transfer::transfer(nexus_token, to);
    }

    /// /// /// /// /// ///
    /// burning tokens ///
    /// /// /// /// /// ///
    public fun burn(nexus_token: NexusToken, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);
        let NexusToken { id, balance: _ } = nexus_token;
        object::delete(id);
    }

    /// /// /// /// /// ///
    /// locking tokens ///
    /// /// /// /// /// ///
    public fun lock(user: address, amount: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);
        let locked = LockedBalance {
            id: object::new(ctx),
            user: user,
            amount: amount,
        };
        transfer::transfer(locked, user);
    }

    /// /// /// /// /// ///
    /// unlocking tokens ///
    /// /// /// /// /// ///

    public fun unlock(user: address, amount: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);

        let temp_uid = object::new(ctx);


        let locked_balance: LockedBalance = transfer::public_receive<LockedBalance>(
            &mut temp_uid,
            object::id_from_address(user)
        );

        assert!(locked_balance.amount >= amount, 1);

        locked_balance.amount = locked_balance.amount - amount;

        transfer::transfer(locked_balance, user);


        mint(user, amount, ctx);
    }
    /// /// /// ///
    /// getters ///
    /// /// /// ///

    public fun get_balance(nexus_token: &NexusToken): u64 {
        nexus_token.balance
    }

    public fun get_locked_amount(locked_balance: &LockedBalance): u64 {
        locked_balance.amount
    }

}
