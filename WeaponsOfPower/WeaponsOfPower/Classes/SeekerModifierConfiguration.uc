class SeekerModifierConfiguration extends NonUpgradableWeaponModifierConfiguration config(WeaponsOfPower);

///	<summary>
///		The ammount of ammo consumed when spread is enabled.
///	</summary>
var config int SeekerAmmoCost;

var config int MaxSeekerTargets;

var localized string SeekerPropertyText[2];

var localized string SeekerPropertyDesc[2];

////////////////////////////////////////////////////////////////////////////////

static function FillPlayInfo(
	PlayInfo PlayInfo
) {
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.PropertyGroupName, "SeekerAmmoCost",   GetPrefix() @ default.SeekerPropertyText[0], 1, 10, "Text", "3;1:999");
	PlayInfo.AddSetting(default.PropertyGroupName, "MaxSeekerTargets", GetPrefix() @ default.SeekerPropertyText[1], 1, 10, "Text", "3;1:999");
}

////////////////////////////////////////////////////////////////////////////////

static event string GetDescriptionText(
	string PropName
) {
	switch (PropName) {
		case "SeekerAmmoCost":   return default.SeekerPropertyDesc[0];
		case "MaxSeekerTargets": return default.SeekerPropertyDesc[1];
	}

	return Super.GetDescriptionText(PropName);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    SeekerAmmoCost=5
    MaxSeekerTargets=10
    SeekerPropertyText(0)="Ammo Used For Seeker"
    SeekerPropertyText(1)="Maximum Seeker Targets"
    SeekerPropertyDesc(0)="Ammo used while Seekering."
    SeekerPropertyDesc(1)="The maximum number of targets that can be locked onto."
    RequiredSlots=5
    ModifierName="Rocket Seeker"
}
