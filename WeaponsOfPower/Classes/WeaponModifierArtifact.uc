class WeaponModifierArtifact extends WeaponOfPowerArtifact config(WeaponsOfPower);

////////////////////////////////////////////////////////////////////////////////

function bool Apply() {
	local WeaponOfPower weapon;

	if (Instigator == None) {
		return false;
	}

	weapon = WeaponOfPower(Instigator.PendingWeapon);

	if (weapon == None) {
		weapon = WeaponOfPower(Instigator.Weapon);
	}

	if (weapon == None) {
		Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',0,,,class);

		return false;
	}

	if (ModifierClass == None) {
		// Error...
		return false;
	}

	return weapon.ApplyModifier(ModifierClass);
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "Weapon Power-Ups can only be applied to Weapons of Power!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

static function AddPrecacheStaticMeshes(
	LevelInfo level
) {
	level.AddPrecacheStaticMesh(default.PickupClass.default.StaticMesh);
}

////////////////////////////////////////////////////////////////////////////////

static function AddPrecacheMaterials(
	LevelInfo level
) {
	level.AddPrecacheMaterial(default.IconMaterial);
	level.AddPrecacheMaterial(default.ModifierClass.default.ModifierEffect);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
}
