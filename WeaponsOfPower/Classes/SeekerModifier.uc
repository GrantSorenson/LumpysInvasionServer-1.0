class SeekerModifier extends FireModeWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

static function int GetMaxTargets() {
	if (default.Configuration == class'SeekerModifierConfiguration') {
		return class<SeekerModifierConfiguration>(default.Configuration).default.MaxSeekerTargets;
	}

	return 5;
}

////////////////////////////////////////////////////////////////////////////////

static function int GetAmmoCost() {
	if (default.Configuration == class'SeekerModifierConfiguration') {
		return class<SeekerModifierConfiguration>(default.Configuration).default.SeekerAmmoCost;
	}

	return 5;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Apply() {
	super.Apply();

	RocketSeekerFireMode(FireMode).SetMaxTargets(GetMaxTargets());
	RocketSeekerFireMode(FireMode).SetAmmoCost(GetAmmoCost());
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    FireModeEntries=[0]=(WeaponType (Object) = Class'XWeapons.RocketLauncher',FireMode (Object) = Class'RocketSeekerFireMode',modeNum (Int) = 0,)
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.SeekerWeaponShader'
    ModifierColor=(R=128,G=220,B=255,A=0),
    configuration=Class'SeekerModifierConfiguration'
    Artifact=Class'SeekerModifierArtifact'
}
