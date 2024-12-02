class ShieldedRedeemerModifier extends FireModeWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

static function int GetAdrenalineCost() {
	if (default.Configuration == class'ShieldedRedeemerModifierConfiguration') {
		return class<ShieldedRedeemerModifierConfiguration>(default.Configuration).default.ShieldedRedeemerAdrenalineCost;
	}

	return 100;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    FireModeEntries=[0]=(WeaponType (Object) = Class'XWeapons.Redeemer',FireMode (Object) = Class'ShieldedRedeemerRedeemerFireMode',modeNum (Int) = 1,)
    ModifierColor=(R=128,G=255,B=128,A=0),
    configuration=Class'ShieldedRedeemerModifierConfiguration'
    Artifact=Class'ShieldedRedeemerModifierArtifact'
}
