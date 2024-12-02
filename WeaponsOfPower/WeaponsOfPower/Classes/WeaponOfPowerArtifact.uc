class WeaponOfPowerArtifact extends RPGArtifact config(WeaponsOfPower);

var int RemainingUses;

var bool bTossed;

var class<WeaponModifier> ModifierClass;

var string Description;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		RemainingUses, bTossed;

	reliable if (Role < ROLE_Authority)
		RemoveOne;
}

////////////////////////////////////////////////////////////////////////////////

function Activate() {
	if (Apply() == true) {
		RemoveOne();
	}
}

////////////////////////////////////////////////////////////////////////////////

function RemoveOne() {
	--RemainingUses;

	if (RemainingUses <= 0) {
		if (RemainingUses < 0) {
			Warn("Artifact remaning use count fell below 0.");
		}

		Instigator.NextItem();
		Destroy();
	}
}

////////////////////////////////////////////////////////////////////////////////

function bool Apply() { return true; }

////////////////////////////////////////////////////////////////////////////////

function bool HandlePickupQuery(
	Pickup Item
) {
	if (item.InventoryType == class) {
		// Restrict pickup to configured setting.
		if (class'WeaponModifierArtifactManager'.default.MaxCopiesPerPlayer == -1) {
			return false;
		}

		if (RemainingUses >= class'WeaponModifierArtifactManager'.default.MaxCopiesPerPlayer) {
			return true;
		}

		return false;
	}

	if (Inventory == None) {
		return false;
	}

	return Inventory.HandlePickupQuery(Item);
}

////////////////////////////////////////////////////////////////////////////////

exec function TossArtifact() {
	local vector X, Y, Z;

	// Don't know how this happens, but when it does we're just going to destroy
	// the item instead of generating errors.
	if (Instigator == None) {
		Destroy();
		return;
	}

	// Only switch if this was the last one of the pickups.
	if (RemainingUses <= 1) {
		Instigator.NextItem();
	}

	bTossed = True;

	Velocity = Vector(Instigator.Controller.GetViewRotation());
	Velocity = Velocity * ((Instigator.Velocity Dot Velocity) + 500) + Vect(0,0,200);
	GetAxes(Instigator.Rotation, X, Y, Z);
	DropFrom(Instigator.Location + 0.8 * Instigator.CollisionRadius * X - 0.5 * Instigator.CollisionRadius * Y);
}

////////////////////////////////////////////////////////////////////////////////

function DropFrom(vector StartLocation) {
	local Pickup    P;
	local Inventory TossedInventory;
	local Pawn      OriginalOwner;

	--RemainingUses;

	OriginalOwner = Instigator;

	if (RemainingUses <= 0) {
		// Special code so that we can throw a single instance of this pickup
		// instead of them all.
		if (Instigator != None) {
			DetachFromPawn(Instigator);

			Instigator.DeleteInventory(self);
		}

		SetDefaultDisplayProperties();
		Instigator = None;
		StopAnimating();
		GotoState('');

		TossedInventory = self;
		RemainingUses   = 1;
	} else {
		TossedInventory = spawn(class,,,StartLocation);
	}

	P = spawn(PickupClass,,,StartLocation);

	if (P == None) {
		Destroy();
		return;
	}

	// Only destroy them if they were player items. Monsters can drop them to
	// their hearts content. This also prevents artifacts dropped when a player
	// dies from being picked up.
	if (
		(Level.Game.IsA('Invasion') == false) ||
		(
			(OriginalOwner != None) &&
			(OriginalOwner.PlayerReplicationInfo != None) &&
			(OriginalOwner.PlayerReplicationInfo.Team == Invasion(Level.Game).GetBotTeam())
		)
	) {
		// For now, we won't affect WeaponOfPowerArtifacts with the same rules. This
		// way they act like normal RPG artifacts. It's only the power ups we're
		// going to monitor... for now...
		if (WeaponModifierPickup(P) != None) {
			if (
				(
					(bTossed == False) &&
					(class'WeaponModifierArtifactManager'.default.DestroyOnDeath == true)
				) ||
				(class'WeaponModifierArtifactManager'.default.DestroyWhenTossed == true)
			) {
				WeaponModifierPickup(P).SetDestroying();
			}
		}
	}

	// Cause the power up to respond to physics.
	if (WeaponModifierPickup(P) != None) {
		if (class'WeaponModifierArtifactManager'.default.DroppedModifiersRespondToPhysics == true) {
			WeaponModifierPickup(P).SetRespondToPhysics();
		}
	}

	// Reset tossed flag so its not set next time someone picks it up.
	bTossed = False;

	P.InitDroppedPickupFor(TossedInventory);
	P.Velocity = Velocity;

	if (RemainingUses <= 0) {
		Velocity = vect(0,0,0);
	}
}

////////////////////////////////////////////////////////////////////////////////

function HolderDied() { }

////////////////////////////////////////////////////////////////////////////////

function HolderDeathPrevented() { }

////////////////////////////////////////////////////////////////////////////////

function bool PreventDeath(
	Pawn              Killed,
	Controller        Killer,
	class<DamageType> damageType,
	vector HitLocation
) {
	return false;
}

function bool PreventSever(
	Pawn              Killed,
	name              boneName,
	int               Damage,
	class<DamageType> DamageType
) {
	return false;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    RemainingUses=1
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.DamageIcon'
}
