class EnergyModifier extends LinearUpgradeWeaponModifier;

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
	local float AdrenalineBonus;

	if (Pawn(Victim) == None) {
		return;
	}

	if (Instigator == None) {
		return;
	}

	// Sorry, no energy for self damage. ;)
	if (Instigator == Pawn(Victim)) {
		return;
	}

	// You ain't getting exp for hurting your own team either ;) Be happy I
	// don't subtract adrenaline.
	if (
		(Pawn(Victim).GetTeam() == Instigator.GetTeam()) &&
		(Instigator.GetTeam()   != None)
	) {
		return;
	}

	if (OriginalDamage > Pawn(Victim).Health) {
		AdrenalineBonus = Pawn(Victim).Health;
	} else {
		AdrenalineBonus = OriginalDamage;
	}

	AdrenalineBonus *= 0.02 * CurrentLevel;

	if (
		(UnrealPlayer(Instigator.Controller) != None) &&
		(Instigator.Controller.Adrenaline < Instigator.Controller.AdrenalineMax) &&
		(Instigator.Controller.Adrenaline + AdrenalineBonus >= Instigator.Controller.AdrenalineMax) &&
		(Instigator.InCurrentCombo() == false)
	) {
		UnrealPlayer(Instigator.Controller).ClientDelayedAnnouncementNamed('Adrenalin', 15);
	}

	Instigator.Controller.Adrenaline = FMin(
		Instigator.Controller.Adrenaline + AdrenalineBonus,
		Instigator.Controller.AdrenalineMax
	);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'XGameShaders.PlayerShaders.LightningHit'
    configuration=Class'EnergyModifierConfiguration'
    Artifact=Class'EnergyModifierArtifact'
}
