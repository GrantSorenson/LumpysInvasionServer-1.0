class PiercingModifier extends NonUpgradableWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

var class<DamageType> ModifiedDamageType;

////////////////////////////////////////////////////////////////////////////////

function AdjustTargetDamage(
	int               OriginalDamage,
	out int           Damage,
	Actor             Victim,
	Vector            HitLocation,
	vector            OriginalMomentum,
	out Vector        Momentum,
	class<DamageType> DamageType
) {
	if (
		(Pawn(Victim) != None) &&
		(Pawn(Victim).ShieldStrength > 0) &&
		(DamageType.default.bArmorStops == true)
	) {
		DamageType.default.bArmorStops = false;
		ModifiedDamageType = DamageType;
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function WeaponTick(
	float deltaTime
) {
	if (ModifiedDamageType != None) {
		ModifiedDamageType.default.bArmorStops = true;
		ModifiedDamageType = None;
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'XGameShaders.PlayerShaders.PlayerTrans'
    ModifierColor=(R=255,G=196,B=128,A=0),
    configuration=Class'PiercingModifierConfiguration'
    Artifact=Class'PiercingModifierArtifact'
}
