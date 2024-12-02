//================================================================================
// SpreadModifierConfiguration.
//================================================================================
class SpreadModifierConfiguration extends LinearUpgradeWeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		The ammount of ammo consumed when spread is enabled.
///	</summary>
var config int SpreadLinkAmmoCost;

var config int SpreadBioAmmoCost;

var localized string SpreadPropertyText[2];

var localized string SpreadPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "SpreadLinkAmmoCost", GetPrefix() @ default.SpreadPropertyText[0], 1, 10, "Text", "3;1:999");
	PlayInfo.AddSetting(default.PropertyGroupName, "SpreadBioAmmoCost",  GetPrefix() @ default.SpreadPropertyText[1], 1, 10, "Text", "3;1:999");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "SpreadLinkAmmoCost": return default.SpreadPropertyDesc[0];
		case "SpreadBioAmmoCost":  return default.SpreadPropertyDesc[1];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    SpreadLinkAmmoCost=2
    SpreadBioAmmoCost=2
    SpreadPropertyText(0)="Ammo Used For Link Spread"
    SpreadPropertyText(1)="Ammo Used For Bio Spread"
    SpreadPropertyDesc(0)="The additional ammo per level used while link spreading."
    SpreadPropertyDesc(1)="The additional ammo per level used while bio spreading."
    InitialSlotCost=5
    UpgradeSlotCost=5
    ModifierName="Spread"
    MaxLevel=2
}
