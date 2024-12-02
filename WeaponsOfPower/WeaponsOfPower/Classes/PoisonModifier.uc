class PoisonModifier extends LinearUpgradeWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

static function int StopDamageLevel() {
	if (default.Configuration == class'PoisonModifierConfiguration') {
		return class<PoisonModifierConfiguration>(default.Configuration).default.StopSelfDamageLevel;
	}

	return 0;
}

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
	local PoisonInv poisonInventory;
	local Pawn      pawnVictim;

	if (DamageType == class'DamTypePoison' || Damage <= 0) {
		return;
	}

	pawnVictim = Pawn(Victim);

	// If configured, set the level at which poison will no longer affect the
	// instigator.
	if (
		(pawnVictim        == Instigator) &&
		(StopDamageLevel() >  0) &&
		(CurrentLevel      >= StopDamageLevel())
	) {
		return;
	}

	if (pawnVictim != None) {
		poisonInventory = PoisonInv(pawnVictim.FindInventoryType(class'PoisonInv'));

		if (poisonInventory != None) {
			poisonInventory.LifeSpan += Rand(Damage / 10) + 1;
		} else {
			poisonInventory = spawn(class'PoisonInv', pawnVictim,,, rot(0,0,0));
			poisonInventory.Modifier = CurrentLevel;
			poisonInventory.GiveTo(pawnVictim);
			poisonInventory.LifeSpan = Rand(Damage / 10) + 1;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'XGameShaders.PlayerShaders.LinkHit'
    ModifierColor=(R=0,G=255,B=0,A=0),
    configuration=Class'PoisonModifierConfiguration'
    Artifact=Class'PoisonModifierArtifact'
}
