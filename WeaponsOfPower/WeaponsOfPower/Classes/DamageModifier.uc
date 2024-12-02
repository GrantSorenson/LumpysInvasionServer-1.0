class DamageModifier extends LinearUpgradeWeaponModifier config(WeaponsOfPower);

#EXEC OBJ LOAD FILE=WeaponsOfPowerTextures.utx

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
	// We can do 0 damage unlike normal RPG weapons.
	Damage    = Max(0, Damage * (1.0 + 0.1 * CurrentLevel));
	Momentum *= 1.0 + 0.1 * CurrentLevel;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.DamageWeaponShader'
    ModifierColor=(R=255,G=0,B=255,A=0),
    configuration=Class'DamageModifierConfiguration'
    Artifact=Class'DamageModifierArtifact'
}
