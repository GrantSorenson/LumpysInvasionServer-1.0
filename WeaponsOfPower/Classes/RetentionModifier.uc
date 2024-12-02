class RetentionModifier extends NonUpgradableWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

function HolderDied() {
	local RetentionPlayerModifier RetentionInv;

	if (PlayerOwner.Controller == None) {
		return;
	}

	// If this happens, the weapon is no longer attached to the player which may
	// mean something else is processing it.
	if (AttachedWeapon.Owner != PlayerOwner) {
		return;
	}

	PlayerOwner.Controller.LastPawnWeapon = AttachedWeapon.ModifiedWeapon.Class;
	AttachedWeapon.DetachFromPawn(PlayerOwner);

	RetentionInv        = PlayerOwner.spawn(class'RetentionPlayerModifier', PlayerOwner.Controller);
	RetentionInv.Weapon = AttachedWeapon;

	PlayerOwner.DeleteInventory(AttachedWeapon);

	RetentionInv.Weapon.SetOwner(PlayerOwner.Controller);
	RetentionInv.Weapon.ModifiedWeapon.SetOwner(PlayerOwner.Controller);

	RetentionInv.AmmoAmounts[0] = AttachedWeapon.AmmoAmount(0);
	RetentionInv.AmmoAmounts[1] = AttachedWeapon.AmmoAmount(1);

	RetentionInv.Inventory = PlayerOwner.Controller.Inventory;

	PlayerOwner.Controller.Inventory = RetentionInv;

	if (PlayerOwner.Weapon == AttachedWeapon) {
		PlayerOwner.Weapon = None;
	}

	if (
		(PlayerOwner.PendingWeapon != None) &&
		(PlayerOwner.PendingWeapon == AttachedWeapon)
	) {
		PlayerOwner.Weapon = None;
		PlayerOwner.PendingWeapon = None;
	}
}

////////////////////////////////////////////////////////////////////////////////

function bool OnDenial() {
	// This artifact destroys itself after it has been used to denial a weapon.
	return false;
}

////////////////////////////////////////////////////////////////////////////////

simulated event WeaponTick(
	float deltaTime
) {
	if (
		(Invasion(Level.Game) != None) &&
		(Invasion(Level.Game).WaveNum == Invasion(Level.Game).FinalWave - 1)
	) {
		AttachedWeapon.RemoveModifier(self);
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.RetentionWeaponShader'
    ModifierColor=(R=75,G=139,B=219,A=0),
    configuration=Class'RetentionModifierConfiguration'
    Artifact=Class'RetentionModifierArtifact'
}
