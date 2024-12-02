class InfinityModifierConfiguration extends LinearUpgradeWeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		If true, allow super weapons such as the Redeemer to be infinified.
///		(This is just crazy.)
///	</summary>
var config bool AllowSuperWeaponInfs;

///	<summary>
///		A limit for the second level of infinity weapon speed doubling.
///	</summary>
var config int MaxWeaponSpeed;

var localized string InfinityPropertyText[2];

var localized string InfinityPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "AllowSuperWeaponInfs", GetPrefix() @ default.InfinityPropertyText[0], 1, 10, "Check");
	PlayInfo.AddSetting(default.PropertyGroupName, "MaxWeaponSpeed",       GetPrefix() @ default.InfinityPropertyText[1], 1, 10, "Text", "4;1:9999");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "AllowSuperWeaponInfs": return default.LinearUpgradePropertyDesc[1];
		case "MaxWeaponSpeed":       return default.LinearUpgradePropertyDesc[2];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    MaxWeaponSpeed=4000
    InfinityPropertyText(0)="Allow Super Weapon Infinities"
    InfinityPropertyText(1)="Maximum Weapon Speed"
    InfinityPropertyDesc(0)="Allow super weapons to have infinity applied to them."
    InfinityPropertyDesc(1)="The maximum weapon speed to allow when multiplying."
    InitialSlotCost=5
    UpgradeSlotCost=5
    ModifierName="Infinity"
    MaxLevel=10
    AllowUnload=False
}
