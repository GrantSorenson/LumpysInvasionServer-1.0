class PoisonModifierConfiguration extends LinearUpgradeWeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		The level of poison at which it will no hurt the instigator.
///	</summary>
var config int StopSelfDamageLevel;

var localized string PoisonPropertyText[2];

var localized string PoisonPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "StopSelfDamageLevel", GetPrefix() @ default.PoisonPropertyText[0], 1, 10, "Text", "3;1:100");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "StopSelfDamageLevel": return default.PoisonPropertyDesc[0];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    PoisonPropertyText="Stop Self Damage Level (0 = Never)"
    PoisonPropertyDesc="When set to a number greater than 0, poison will stop hurting the owner if they inflict self damage at the specified level."
    ModifierName="Poison"
}
