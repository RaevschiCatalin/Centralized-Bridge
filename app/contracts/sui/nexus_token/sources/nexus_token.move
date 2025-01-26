/// /// /// /// ///
/// Token module ///
/// /// /// /// ///
module nexus_token::nexus_token {
    use sui::dynamic_field as df;
    use sui::event;

    const DEPLOYER_ADDRESS: address = @0x195db0a3f4e5651cd5f608cedd9b3bcb57895cce075f41382d29e4ac6b860ca7;

    /// /// /// /// ///
    /// Token struct ///
    /// /// /// /// ///
    public struct NexusToken has key, store {
        id: UID,
        balance: u64,
    }

    /// /// /// /// ///
    /// Locked balance ///
    /// /// /// /// ///
    public struct LockedBalance has key, store {
        id: UID,
        user: address,
        amount: u64,
    }

    /// /// /// /// ///
    /// User balance ///
    /// /// /// /// ///
    public struct UserLockedBalance has copy, drop, store {
        user: address,
    }

    /// /// /// ///
    /// Events ///
    /// /// /// ///
    public struct LockEvent has copy, drop {
        user: address,
        amount: u64,
    }

    public struct UnlockEvent has copy, drop {
        user: address,
        amount: u64,
    }


    /// /// /// /// ///
    /// Deployer struct ///
    /// /// /// /// ///
    public struct Deployer has key {
        id: UID,
    }

    /// /// /// /// ///
    /// Init deployer ///
    /// /// /// /// ///
    public fun init_deployer(ctx: &mut TxContext): Deployer {
        let deployer = Deployer {
            id: object::new(ctx),
        };
        transfer::transfer(deployer, tx_context::sender(ctx));
        Deployer {
            id: object::new(ctx),
        }
    }

    /// /// /// /// ///
    /// Delete deployer ///
    /// /// /// /// ///
    public fun delete_deployer(deployer: Deployer) {
        let Deployer { id } = deployer;
        object::delete(id);
    }

    /// /// /// /// ///
    /// Mint tokens ///
    /// /// /// /// ///
    public fun mint(to: address, amount: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);
        let nexus_token = NexusToken {
            id: object::new(ctx),
            balance: amount,
        };
        transfer::transfer(nexus_token, to);
    }

    /// /// /// /// ///
    /// Burn tokens ///
    /// /// /// /// ///
    public fun burn(nexus_token: NexusToken, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);
        let NexusToken { id, balance: _ } = nexus_token;
        object::delete(id);
    }

    /// /// /// /// ///
    /// Lock tokens ///
    /// /// /// /// ///
    public fun lock(deployer: &mut Deployer, user: address, amount: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);

        let user_locked_balance = UserLockedBalance { user };

        if (df::exists_(&deployer.id, user_locked_balance)) {
            let balance: &mut LockedBalance = df::borrow_mut(&mut deployer.id, user_locked_balance);
            balance.amount = balance.amount + amount;
        } else {
            let locked = LockedBalance {
                id: object::new(ctx),
                user: user,
                amount: amount,
            };
            df::add(&mut deployer.id, user_locked_balance, locked);
        };
        event::emit(LockEvent { user, amount });
    }

    /// /// /// /// ///
    /// Unlock tokens ///
    /// /// /// /// ///
    public fun unlock(deployer: &mut Deployer, user: address, amount: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == DEPLOYER_ADDRESS, 0);

        let user_locked_balance = UserLockedBalance { user };

        assert!(df::exists_(&deployer.id, user_locked_balance), 1);

        let locked_balance: &mut LockedBalance = df::borrow_mut(&mut deployer.id, user_locked_balance);

        assert!(locked_balance.amount >= amount, 2);

        locked_balance.amount = locked_balance.amount - amount;

        let nexus_token = NexusToken {
            id: object::new(ctx),
            balance: amount,
        };
        transfer::transfer(nexus_token, user);
        event::emit(UnlockEvent { user, amount });


        if (locked_balance.amount == 0) {
            let locked_balance_value: LockedBalance = df::remove(&mut deployer.id, user_locked_balance);
            let LockedBalance { id, user: _, amount: _ } = locked_balance_value;
            object::delete(id);
        }
    }

    /// /// /// /// /// ///
    /// Get locked amount ///
    /// /// /// /// /// ///
    public fun get_locked_amount(deployer: &Deployer, user: address): u64 {
        let user_locked_balance = UserLockedBalance { user };

        if (df::exists_(&deployer.id, user_locked_balance)) {
            let locked_balance: &LockedBalance = df::borrow(&deployer.id, user_locked_balance);
            locked_balance.amount
        } else {
            0
        }
    }

    /// /// /// /// ///
    /// Get balance ///
    /// /// /// /// ///
    public fun get_balance(nexus_token: &NexusToken): u64 {
        nexus_token.balance
    }
}