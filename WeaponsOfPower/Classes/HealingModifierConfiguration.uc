class HealingModifierConfiguration extends LinearUpgradeWeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		If true, this will allow the weapon to be upgraded past level 5 which
///		then allows this weapon to heal beyond the 50 past max old limit.
///		Additionally at the max level this will let some shield be recovered.
///	</summary>
var config bool AllowEnhancedHealing;

var localized string HealingPropertyText[2];

var localized string HealingPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "AllowEnhancedHealing", GetPrefix() @ default.HealingPropertyText[0], 1, 10, "Check");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "AllowEnhancedHealing": return default.LinearUpgradePropertyDesc[0];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    AllowEnhancedHealing=True
    HealingPropertyText(0)="Allow Enhanced Healing (Required for levels 5 to 10)"
    HealingPropertyText(1)="Enabled levels 5 to 10 to add an addition 10 more health per level. Additionally at level 10, allows 50 shield to be regained."
    ModifierName="Healing"
    MaxLevel=10
}
