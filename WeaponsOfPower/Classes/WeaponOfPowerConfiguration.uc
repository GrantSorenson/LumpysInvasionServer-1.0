class WeaponOfPowerConfiguration extends Info config(WeaponsOfPower);

var config int WopMinModifier;

var config int WopMaxModifier;

var config int WopMaxUpgradeModifier;

var config bool AllowInitialModifiers;

var config int  MaxInitialModifiers;

var config int  MaxInitialSlotsUsed;

var config int BaseSlotCount;

var config bool AllowDuplicateWops;

var config bool AllowUnload;

var localized string PropertyGroupName;

var localized string PropertyText[6];

var localized string PropertyDesc[6];

////////////////////////////////////////////////////////////////////////////////

static function CheckConfig() {
	local int Swap;

	if (default.BaseSlotCount < 1) {
		default.BaseSlotCount = 1;
	}

	if (default.WopMinModifier > default.WopMaxModifier) {
		Swap                   = default.WopMinModifier;
		default.WopMinModifier = default.WopMaxModifier;
		default.WopMaxModifier = Swap;
	}

	if (default.WopMinModifier + default.BaseSlotCount < 1) {
		default.WopMinModifier = default.BaseSlotCount - 1;
	}
}

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting("WOP: Weapons", "WopMinModifier",        default.PropertyText[0], 1, 10, "Text", "3;-999:999");
	PlayInfo.AddSetting("WOP: Weapons", "WopMaxModifier",        default.PropertyText[1], 1, 10, "Text", "3;-999:999");
	PlayInfo.AddSetting("WOP: Weapons", "WopMaxUpgradeModifier", default.PropertyText[2], 1, 10, "Text", "3;-999:999");
	PlayInfo.AddSetting("WOP: Weapons", "BaseSlotCount",         default.PropertyText[3], 1, 10, "Text", "3;1:999");
	PlayInfo.AddSetting("WOP: Weapons", "AllowDuplicateWops",    default.PropertyText[4], 1, 10, "Check");
	PlayInfo.AddSetting("WOP: Weapons", "AllowUnload",           default.PropertyText[5], 1, 10, "Check");
	PlayInfo.PopClass();
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "WopMinModifier":        return default.PropertyDesc[0];
		case "WopMaxModifier":        return default.PropertyDesc[1];
		case "WopMaxUpgradeModifier": return default.PropertyDesc[2];
		case "BaseSlotCount":         return default.PropertyDesc[3];
		case "AllowDuplicateWops":    return default.PropertyDesc[4];
		case "AllowUnload":           return default.PropertyDesc[5];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    WopMinModifier=-3
    WopMaxModifier=5
    MaxInitialModifiers=1
    MaxInitialSlotsUsed=1
    BaseSlotCount=5
    AllowDuplicateWops=True
    PropertyText(0)="Minimum Modifier"
    PropertyText(1)="Maximum Modifier"
    PropertyText(2)="Maximum Upgraded Modifier"
    PropertyText(3)="Initial Base Slot Count"
    PropertyText(4)="Allow Duplicate Wops"
    PropertyText(5)="Allow Weapon Unloading"
    PropertyDesc(0)="Minimum weapon modifier."
    PropertyDesc(1)="Maximum weapon modifier."
    PropertyDesc(2)="Maximum weapon modifier that can be acheived by weapon upgrading."
    PropertyDesc(3)="Number of slot the weapon has prior to applying the modifier."
    PropertyDesc(4)="Allows a player to pick up wops multiple times."
    PropertyDesc(5)="Allows players to use unloadweapon to remove power ups from their current weapon and place them back in their inventory."
    Role=3
}
