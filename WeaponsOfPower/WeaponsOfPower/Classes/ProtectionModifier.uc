class ProtectionModifier extends LinearUpgradeWeaponModifier;

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
	Damage -= Damage * (0.1 * CurrentLevel);
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "Protection power up level has been maxed out!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'XGameShaders.PlayerShaders.PlayerShieldSh'
    ModifierColor=(R=0,G=255,B=255,A=0),
    configuration=Class'ProtectionModifierConfiguration'
    Artifact=Class'ProtectionModifierArtifact'
}
