class HealingModifier extends LinearUpgradeWeaponModifier config(WeaponsOfPower);

#EXEC OBJ LOAD FILE=WeaponsOfPowerTextures.utx

var Shader HealingOverlay;

var Shader ShieldingOverlay;

////////////////////////////////////////////////////////////////////////////////

static function bool AllowEnhancedHealing() {
	if (default.Configuration == class'HealingModifierConfiguration') {
		return class<HealingModifierConfiguration>(default.Configuration).default.AllowEnhancedHealing;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Checks to see if this modifier can be applied in order to upgrade the
///		weapon for the current player.
///	</summary>
///	<param name="Owner">
///		The player that owns the weapon.
///	</param>
///	<param name="Weapon">
///		The weapon to upgrade the modifier of.
///	</param>
function bool CanUpgrade() {
	// Only allowed to surpass level 5 if enhanced healing is enabled.
	if (
		(CurrentLevel >= 5) &&
		(AllowEnhancedHealing() == false)
	) {
		return false;
	}

	// Checks the cost requirements.
	if (super.CanUpgrade() == false) {
		return false;
	}

	return true;
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
	local Pawn pawnVictim;
	local int  MaxHealth;

	if (OriginalDamage > 0) {
		pawnVictim = Pawn(Victim);

		if (
			(pawnVictim != None) &&
			(
				(pawnVictim == Instigator) ||
				(
					(pawnVictim.Controller.IsA('FriendlyMonsterController')) &&
					(FriendlyMonsterController(pawnVictim.Controller).Master == Instigator.Controller)
				) ||
				(
					(pawnVictim.GetTeam() == Instigator.GetTeam()) &&
					(Instigator.GetTeam() != None)
				)
			)
		) {
			MaxHealth = pawnVictim.HealthMax + Max(50, 10 * CurrentLevel);

			if (
				(XPawn(pawnVictim) != None) &&
				(pawnVictim.Health >= MaxHealth) &&
				(CurrentLevel == 10) &&
				(pawnVictim.ShieldStrength < XPawn(pawnVictim).ShieldStrengthMax / 3)
			) {
				pawnVictim.AddShieldStrength(
					Min(
						Max(
							1,
							OriginalDamage * (0.05 * Min(CurrentLevel, 5))
						),
						XPawn(pawnVictim).ShieldStrengthMax / 3 - pawnVictim.ShieldStrength
					)
				);

				pawnVictim.SetOverlayMaterial(ShieldingOverlay, 1.0, false);
			} else {
				pawnVictim.GiveHealth(
					Max(
						1,
						OriginalDamage * (0.05 * Min(CurrentLevel, 5))
					),
					MaxHealth
				);

				pawnVictim.SetOverlayMaterial(HealingOverlay, 1.0, false);
			}

			Damage = 0;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    HealingOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
    ShieldingOverlay=Shader'XGameShaders.PlayerShaders.PlayerShieldSh'
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.HealingWeaponShader'
    ModifierColor=(R=255,G=0,B=0,A=0),
    configuration=Class'HealingModifierConfiguration'
    Artifact=Class'HealingModifierArtifact'
}
