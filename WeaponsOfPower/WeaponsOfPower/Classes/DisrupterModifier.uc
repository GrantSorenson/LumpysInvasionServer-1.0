class DisrupterModifier extends WeaponModifier;

var WeaponFireMode DisrupterFireMode;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		DisrupterFireMode;
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

	if (Weapon.ModifiedWeapon.IsA('SniperRifle') == false) {
		Weapon.NotifyOwner(class'DisrupterModifier', 0);
		return false;
	}

	return true;
}

///	<summary>
///	</summary>
simulated function Apply() {
	local WeaponOfPower Weapon;

	super.Apply();

	Weapon = GetWeapon();

	DisrupterFireMode = Weapon.CreateFireMode(class'LightningDisrupterFireMode', 0);

	weapon.AddFireMode(DisrupterFireMode);
}

////////////////////////////////////////////////////////////////////////////////

simulated function Remove() {
	local WeaponOfPower Weapon;

	super.Remove();

	Weapon = GetWeapon();

	Weapon.RemoveFireMode(DisrupterFireMode);
}

////////////////////////////////////////////////////////////////////////////////

simulated function DestroyFireMode() {
	local WeaponOfPower Weapon;

	Weapon = GetWeapon();

	if (DisrupterFireMode != None) {
		weapon.RemoveFireMode(DisrupterFireMode);
		DisrupterFireMode = None;
	}
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "Disrupter cannot be applied to the current weapon!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.SpreadWeaponShader'
    ModifierColor=(R=128,G=255,B=128,A=0),
    configuration=Class'DisrupterModifierConfiguration'
    Artifact=Class'DisrupterModifierArtifact'
}
