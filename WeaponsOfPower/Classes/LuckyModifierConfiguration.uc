class LuckyModifierConfiguration extends LinearUpgradeWeaponModifierConfiguration config(WeaponsOfPower);

var config int EnhancedLuckySpawnRate;

var localized string LuckyPropertyText[2];

var localized string LuckyPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "EnhancedLuckySpawnRate", GetPrefix() @ default.LuckyPropertyText[0], 1, 10, "Text", "4;1:9999");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "EnhancedLuckySpawnRate": return default.LinearUpgradePropertyDesc[0];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    EnhancedLuckySpawnRate=10
    LuckyPropertyText="Enhanced Lucky Spawn Rate"
    LuckyPropertyDesc="Minimum time for enhanced lucky spawns to occur"
    ConfigMaxLevel=10
    ModifierName="Lucky"
}
