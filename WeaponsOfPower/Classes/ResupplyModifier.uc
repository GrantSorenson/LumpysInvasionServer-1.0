class ResupplyModifier extends LinearUpgradeWeaponModifier;

var bool bActive;

////////////////////////////////////////////////////////////////////////////////

static function bool AllowSuperWeapons() {
	if (default.Configuration == class'ResupplyModifierConfiguration') {
		return class<ResupplyModifierConfiguration>(default.Configuration).default.AllowSuperWeaponResupply;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Checks to see if this modifier can be applied for the specified player
///		and the specified weapon.
///	</summary>
///	<param name="Owner">
///		The player that owns the weapon.
///	</param>
///	<param name="Weapon">
///		The weapon to apply the modifier to.
///	</param>
///	<returns>
///		Returns true if this weapon modifier can be applied to the specified
///		player and weapon.
///	</returns>
static function bool CanApply(
	Actor         Owner,
	WeaponOfPower Weapon
) {
	if (super.CanApply(Owner, Weapon) == false) {
		return false;
	}

	if (
		(Weapon.bNoAmmoInstances == false) ||
		(Weapon.AmmoClass[0]     == None)
	) {
		Weapon.NotifyOwner(class'ResupplyModifier', 1);
	}

	if (
		(AllowSuperWeapons() == false) &&
		(Weapon.ModifiedWeapon.default.FireModeClass[0] != None) &&
		(Weapon.ModifiedWeapon.default.FireModeClass[0].default.AmmoClass != None) &&
		(
			class'MutLumpysRPG'.static.IsSuperWeaponAmmo(
				Weapon.ModifiedWeapon.default.FireModeClass[0].default.AmmoClass
			)
		)
	) {
		Weapon.NotifyOwner(class'ResupplyModifier', 1);
		return false;
	}

	return true;
}

////////////////////////////////////////////////////////////////////////////////

simulated event WeaponTick(
	float deltaTime
) {
	if (bActive == false) {
		bActive = true;

		SetTimer(3.0, true);
	}
}

////////////////////////////////////////////////////////////////////////////////

function Timer() {
	if (
		(PlayerOwner == None) ||
		(PlayerOwner.Health <= 0) ||
		(AttachedWeapon == None) ||
		(AttachedWeapon.ModifiedWeapon == None)
	) {
		bActive = false;
		SetTimer(0.0, false);
		return;
	}

	AttachedWeapon.AddAmmo(
		CurrentLevel * (1 + AttachedWeapon.AmmoClass[0].default.MaxAmmo / 100),
		0
	);

	if (
		(AttachedWeapon.AmmoClass[0] != AttachedWeapon.AmmoClass[1]) &&
		(AttachedWeapon.AmmoClass[1] != None)
	) {
		AttachedWeapon.AddAmmo(
			CurrentLevel * (1 + AttachedWeapon.AmmoClass[1].default.MaxAmmo / 100),
			1
		);
	}
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 1:
			return "Resupply cannot be applied to the current weapon!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.ResupplyWeaponShader'
    ModifierColor=(R=188,G=215,B=255,A=0),
    configuration=Class'ResupplyModifierConfiguration'
    Artifact=Class'ResupplyModifierArtifact'
}
