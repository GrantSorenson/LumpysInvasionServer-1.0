class ResupplyModifierConfiguration extends LinearUpgradeWeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		If true, allow super weapons such as the Redeemer to have resupply.
///		(This is just crazy.)
///	</summary>
var config bool AllowSuperWeaponResupply;

var localized string InfinityPropertyText[3];

var localized string InfinityPropertyDesc[3];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "AllowSuperWeaponResupply", GetPrefix() @ default.InfinityPropertyText[0], 1, 10, "Check");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "AllowSuperWeaponResupply": return default.LinearUpgradePropertyDesc[0];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    InfinityPropertyText="Allow Super Weapon Resupply"
    InfinityPropertyDesc="Allow resupply to be applied to super weapons."
    InitialSlotCost=2
    ModifierName="Resupply"
}
