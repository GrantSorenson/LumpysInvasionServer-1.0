class PreloadedWeaponOfPower extends WeaponOfPower;

struct WeaponPowerUpSlot {
	var class<WeaponModifier> Class;
	var int                   Level;
	var bool                  Locked;
};

var config Array<WeaponPowerUpSlot> PowerUps;

////////////////////////////////////////////////////////////////////////////////

function Generate(
	RPGWeapon ForcedWeapon
) {
	if (ForcedWeapon != None) {
		super.Generate(ForcedWeapon);
		return;
	}

	BaseSlotCount = class'WeaponOfPowerConfiguration'.default.BaseSlotCount;

	Modifier = 9999999;
	LoadWeapon();
	Modifier = UsedSlots - BaseSlotCount;
}

////////////////////////////////////////////////////////////////////////////////

function LoadWeapon() {
	local WeaponModifier NewModifier;
	local int            i;

	for (i = 0; i < PowerUps.Length; ++i) {
		NewModifier = AddModifier(PowerUps[i].Class);
		NewModifier.Apply();
		NewModifier.SetLevel(PowerUps[i].Level);
		NewModifier.SetLocked(PowerUps[i].Locked);
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
}
