class LinearUpgradeWeaponModifier extends WeaponModifier;

////////////////////////////////////////////////////////////////////////////////

static function int GetInitialSlotCost() {
	if (ClassIsChildOf(default.Configuration, class'LinearUpgradeWeaponModifierConfiguration') == true) {
		return class<LinearUpgradeWeaponModifierConfiguration>(default.Configuration).default.InitialSlotCost;
	}

	return 1;
}

////////////////////////////////////////////////////////////////////////////////

static function int GetUpgradeSlotCost() {
	if (ClassIsChildOf(default.Configuration, class'LinearUpgradeWeaponModifierConfiguration') == true) {
		return class<LinearUpgradeWeaponModifierConfiguration>(default.Configuration).default.UpgradeSlotCost;
	}
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Checks to see if this modifier can be applied in order to upgrade the
///		weapon for the current player.
///	</summary>
///	<param name="Owner">
///		The player that owns the weapon.
///	</param>
///	<param name="Weapon">
///		The weapon to upgrade the modifier of.
///	</param>
function bool CanUpgrade() {
	// Checks the cost requirements.
	if (super.CanUpgrade() == false) {
		return false;
	}

	// Sanity check. Should never happen.
	if (CurrentLevel > GetMaxLevel()) {
		CurrentLevel = GetMaxLevel();
	}

	if (CurrentLevel >= GetMaxLevel()) {
		GetWeapon().NotifyOwner(class, 0);
		return false;
	}

	return true;
}

///	<summary>
///	</summary>
simulated function Upgrade() {
	super.Upgrade();
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

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return GetModifierName() $ " power up level has been maxed out!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    configuration=Class'LinearUpgradeWeaponModifierConfiguration'
}
