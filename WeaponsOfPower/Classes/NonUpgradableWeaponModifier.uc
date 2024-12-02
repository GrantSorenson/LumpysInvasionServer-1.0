class NonUpgradableWeaponModifier extends WeaponModifier;

////////////////////////////////////////////////////////////////////////////////

static function int GetRequiredSlotCost() {
	if (ClassIsChildOf(default.Configuration, class'NonUpgradableWeaponModifierConfiguration') == true) {
		return class<NonUpgradableWeaponModifierConfiguration>(default.Configuration).default.RequiredSlots;
	}

	return 1;
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
	GetWeapon().NotifyOwner(class'NonUpgradableWeaponModifier', 1);

	return false;
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
	return GetRequiredSlotCost();
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 1:
			return "Cannot upgrade power up!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
}
