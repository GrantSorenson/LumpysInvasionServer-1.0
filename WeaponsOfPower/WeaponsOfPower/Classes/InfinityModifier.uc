class InfinityModifier extends LinearUpgradeWeaponModifier config(WeaponsOfPower);

var bool bUpdateWeaponSpeed;

////////////////////////////////////////////////////////////////////////////////

static function bool AllowSuperWeapons() {
	if (default.Configuration == class'InfinityModifierConfiguration') {
		return class<InfinityModifierConfiguration>(default.Configuration).default.AllowSuperWeaponInfs;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

static function int GetMaxWeaponSpeed() {
	if (default.Configuration == class'InfinityModifierConfiguration') {
		return class<InfinityModifierConfiguration>(default.Configuration).default.MaxWeaponSpeed;
	}

	return 9999;
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
		(AllowSuperWeapons() == false) &&
		(Weapon.ModifiedWeapon.default.FireModeClass[0] != None) &&
		(Weapon.ModifiedWeapon.default.FireModeClass[0].default.AmmoClass != None) &&
		(
			class'MutLumpysRPG'.static.IsSuperWeaponAmmo(
				Weapon.ModifiedWeapon.default.FireModeClass[0].default.AmmoClass
			)
		)
	) {
		Weapon.NotifyOwner(class'InfinityModifier', 1);
		return false;
	}

	return true;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///	</summary>
simulated function Upgrade() {
	super.Upgrade();

	if (CurrentLevel >= 2) {
		UpdateWeaponSpeed();
	}
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Returns the number of slots required to used this modifier for the first
///		time.
///	</summary>
///	<returns>
///		The base number of slots this modifier requires.
///	</returns>
static function int GetRequiredSlots() {
	return GetInitialSlotCost();
}

///	<summary>
///		Returns the number of slots needed to upgrade this modifier to the next
///		level.
///	</summary>
///	<returns>
///		The number of slots required to upgrade this modifier.
///	</returns>
function int GetRequiredUpgradeSlots() {
	return GetUpgradeSlotCost();
}

////////////////////////////////////////////////////////////////////////////////

simulated function WeaponTick(
	float deltaTime
) {
	local WeaponOfPower Weapon;

	if (bUpdateWeaponSpeed == true) {
		UpdateWeaponSpeed();
		bUpdateWeaponSpeed = false;
	}

	Weapon = GetWeapon();

	Weapon.MaxOutAmmo();
}

////////////////////////////////////////////////////////////////////////////////

simulated function UpdateWeaponSpeed() {
	local RPGStatsInv stats;
	local int         OldWeaponSpeed;
	local int         newWeaponSpeed;

	stats = RPGStatsInv(PlayerOwner.FindInventoryType(class'RPGStatsInv'));

	if (stats != None) {
		OldWeaponSpeed = stats.Data.WeaponSpeed;

		newWeaponSpeed = OldWeaponSpeed * CurrentLevel;

		// Set a max so we don't go overboard.
		if (
			(GetMaxWeaponSpeed() > 0) &&
			(newWeaponSpeed      > GetMaxWeaponSpeed())
		) {
			stats.Data.WeaponSpeed = GetMaxWeaponSpeed();
		} else {
			stats.Data.WeaponSpeed = newWeaponSpeed;
		}

  		stats.AdjustFireRate(GetWeapon().ModifiedWeapon);
		stats.Data.WeaponSpeed = OldWeaponSpeed;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function BringUp(
	optional Weapon PrevWeapon
) {
	if (CurrentLevel >= 2) {
		bUpdateWeaponSpeed = true;
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
			return "Infinity cannot be applied to the current weapon!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.EnhancedInfinityNormalShader'
    ModifierColor=(R=0,G=128,B=196,A=0),
    configuration=Class'InfinityModifierConfiguration'
    Artifact=Class'InfinityModifierArtifact'
}
