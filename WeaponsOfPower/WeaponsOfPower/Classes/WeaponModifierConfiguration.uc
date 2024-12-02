class WeaponModifierConfiguration extends Info config(WeaponsOfPower);

///	<summary>
///		Name of this modifier.
///	</summary>
var localized string ModifierName;

///	<summary>
///		The maximum number of power ups of this class that can be applied to a
///		single weapon.
///	</summary>
var config int MaxLevel;

var config bool AllowUnload;

var localized string PropertyGroupName;

var localized string WeaponModifierPropertyText[2];

var localized string WeaponModifierPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function string GetPrefix() {
	return default.ModifierName $ ":";
}

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "AllowUnload", GetPrefix() @ default.WeaponModifierPropertyText[0], 1, 10, "Check");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "AllowUnload": return default.WeaponModifierPropertyDesc[0];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierName="Unknown"
    MaxLevel=1
    AllowUnload=True
    PropertyGroupName="WOP: Power-Ups"
    WeaponModifierPropertyText="Allow Unload"
    WeaponModifierPropertyDesc="Allow the modifier to be unloaded with UnloadWeapon."
}
