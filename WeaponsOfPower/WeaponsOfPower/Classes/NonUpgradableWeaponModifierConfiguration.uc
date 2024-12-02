class NonUpgradableWeaponModifierConfiguration extends WeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		The number of slots required to apply the modifier associated with
///		this configuration.
///	</summary>
var config int RequiredSlots;

var localized string NonUpgradablePropertyText[2];

var localized string NonUpgradablePropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "RequiredSlots", GetPrefix() @ default.NonUpgradablePropertyText[0], 1, 10, "Text", "3;1:999");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "RequiredSlots": return default.NonUpgradablePropertyDesc[0];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    NonUpgradablePropertyText="Required Slots to Apply"
    NonUpgradablePropertyDesc="Number of slots needed to apply the power up."
}
