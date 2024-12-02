class ForceModifier extends LinearUpgradeWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

var int LastFlashCount;

////////////////////////////////////////////////////////////////////////////////

///	<summary>
///		Checks to see if this modifier can be applied for the specified player
///		and the specified weapon.
///	</summary>
///	<param name="Owner">
///		The player that owns the weapon.
///	</param>
///	<param name="Weapon">
///		The weapon to apply the modifier to.
///	</param>
///	<returns>
///		Returns true if this weapon modifier can be applied to the specified
///		player and weapon.
///	</returns>
static function bool CanApply(
	Actor         Owner,
	WeaponOfPower Weapon
) {
	local int i;

	if (super.CanApply(Owner, Weapon) == false) {
		return false;
	}

	for (i = 0; i < 2; ++i) {
		if (class<ProjectileFire>(Weapon.ModifiedWeapon.FireModeClass[i]) != None) {
			return true;
		}
	}

	Weapon.NotifyOwner(class'ForceModifier', 0);
	return false;
}

////////////////////////////////////////////////////////////////////////////////

simulated event WeaponTick(
	float deltaTime
) {
	local Projectile             P;
	local ProjectileSpeedChanger C;
	local WeaponOfPower          Weapon;

	Weapon = GetWeapon();

	if (
		(Role == ROLE_Authority) &&
		(Instigator != None) &&
		(
			(WeaponAttachment(Weapon.ThirdPersonActor) == None) ||
			(LastFlashCount != WeaponAttachment(Weapon.ThirdPersonActor).FlashCount)
		)
	)	{
		foreach Instigator.CollidingActors(class'Projectile', P, 200) {
			if (
				(P.Instigator == Instigator) &&
				(P.Speed      == P.default.Speed)   &&
				(P.MaxSpeed   == P.default.MaxSpeed)
			) {
				P.Speed    *= 1.0 + 0.2 * CurrentLevel;
				P.MaxSpeed *= 1.0 + 0.2 * CurrentLevel;
				P.Velocity *= 1.0 + 0.2 * CurrentLevel;

				if (Level.NetMode != NM_Standalone) {
					C = spawn(class'ProjectileSpeedChanger',,,P.Location, P.Rotation);

					if (C != None) {
						C.Modifier = CurrentLevel;
						C.ModifiedProjectile = P;
						C.SetBase(P);

						if (P.AmbientSound != None) {
							C.AmbientSound = P.AmbientSound;
							C.SoundRadius  = P.SoundRadius;
						} else {
							C.bAlwaysRelevant = true;
						}
					}
				}
			}
		}

		if (WeaponAttachment(Weapon.ThirdPersonActor) != None) {
			LastFlashCount = WeaponAttachment(Weapon.ThirdPersonActor).FlashCount;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "Force cannot be applied to the current weapon!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'XGameShaders.PlayerShaders.PlayerTransRed'
    ModifierColor=(R=0,G=0,B=255,A=0),
    configuration=Class'ForceModifierConfiguration'
    Artifact=Class'ForceModifierArtifact'
}
