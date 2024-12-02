class LinearUpgradeWeaponModifierConfiguration extends WeaponModifierConfiguration config(WeaponsOfPower);

var int ConfigMinLevel;

var int ConfigMaxLevel;

var int ConfigMinInitialSlots;

var int ConfigMaxInitialSlots;

var int ConfigMinUpgradeSlots;

var int ConfigMaxUpgradeSlots;

var config int InitialSlotCost;

var config int UpgradeSlotCost;

var localized string LinearUpgradePropertyText[3];

var localized string LinearUpgradePropertyDesc[3];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "MaxLevel",        GetPrefix() @ default.LinearUpgradePropertyText[0], 1, 10, "Text", "3;" $ default.ConfigMinLevel        $ ":" $ default.ConfigMaxLevel);
	PlayInfo.AddSetting(default.PropertyGroupName, "InitialSlotCost", GetPrefix() @ default.LinearUpgradePropertyText[1], 1, 10, "Text", "3;" $ default.ConfigMinInitialSlots $ ":" $ default.ConfigMaxInitialSlots);
	PlayInfo.AddSetting(default.PropertyGroupName, "UpgradeSlotCost", GetPrefix() @ default.LinearUpgradePropertyText[2], 1, 10, "Text", "3;" $ default.ConfigMinInitialSlots $ ":" $ default.ConfigMaxInitialSlots);
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "MaxLevel":        return default.LinearUpgradePropertyDesc[0];
		case "InitialSlotCost": return default.LinearUpgradePropertyDesc[1];
		case "UpgradeSlotCost": return default.LinearUpgradePropertyDesc[2];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ConfigMinLevel=1
    ConfigMaxLevel=999
    ConfigMinInitialSlots=1
    ConfigMaxInitialSlots=999
    ConfigMinUpgradeSlots=1
    ConfigMaxUpgradeSlots=999
    InitialSlotCost=1
    UpgradeSlotCost=1
    LinearUpgradePropertyText(0)="Maximum Level"
    LinearUpgradePropertyText(1)="Initial Slot Cost"
    LinearUpgradePropertyText(2)="Upgrade Slot Cost"
    LinearUpgradePropertyDesc(0)="Maximum level the power up can be applied to."
    LinearUpgradePropertyDesc(1)="Initial cost to apply the powerup."
    LinearUpgradePropertyDesc(2)="Upgrade cost to upgrade the level of the power up."
    MaxLevel=5
}
