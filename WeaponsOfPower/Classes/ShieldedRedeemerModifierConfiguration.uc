class ShieldedRedeemerModifierConfiguration extends NonUpgradableWeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		The ammount of ammo consumed when spread is enabled.
///	</summary>
var config int ShieldedRedeemerAdrenalineCost;

var localized string ShieldedRedeemerPropertyText[2];
var localized string ShieldedRedeemerPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "ShieldedRedeemerAdrenalineCost", GetPrefix() @ default.ShieldedRedeemerPropertyText[0], 1, 10, "Text", "3;1:999");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "ShieldedRedeemerAdrenalineCost": return default.ShieldedRedeemerPropertyDesc[0];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ShieldedRedeemerAdrenalineCost=100
    ShieldedRedeemerPropertyText="Adrenaline required"
    ShieldedRedeemerPropertyDesc="The adrenaline required to shoot a true shot redeemer."
    RequiredSlots=5
    ModifierName="Shielded Redeemer"
}
