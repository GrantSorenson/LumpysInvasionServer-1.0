class RetaliationModifier extends LinearUpgradeWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

function AdjustPlayerDamage(
	int               OriginalDamage,
	out int           Damage,
	Pawn              InstigatedBy,
	vector            HitLocation,
	vector            OriginalMomentum,
	out Vector        Momentum,
	class<DamageType> DamageType
) {
	local int iDamage;

	if (Damage <= 0) {
		return;
	}

	if (
		DamageType   == class'DamTypeRetaliation' ||
		InstigatedBy == None ||
		InstigatedBy == Instigator ||
		Instigator   == None
	) {
		return;
	}

	iDamage = int(float(Damage) * (0.05 * CurrentLevel));

	if (iDamage <= 0) {
		iDamage = 1;
	}

	InstigatedBy.TakeDamage(
		iDamage,
		Instigator,
		InstigatedBy.Location,
		vect(0,0,0),
		class'DamTypeRetaliation'
	);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.RetaliationWeaponShader'
    ModifierColor=(R=57,G=72,B=188,A=0),
    configuration=Class'RetaliationModifierConfiguration'
    Artifact=Class'RetaliationModifierArtifact'
}
