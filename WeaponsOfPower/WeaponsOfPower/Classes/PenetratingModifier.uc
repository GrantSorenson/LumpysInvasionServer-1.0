class PenetratingModifier extends NonUpgradableWeaponModifier;

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
	local int            i;
	local bool           bCanApply;
	local WeaponFireMode FireMode;

	if (super.CanApply(Owner, Weapon) == false) {
		return false;
	}

	if (Weapon.PrimaryFireModes != None) {
		FireMode = Weapon.PrimaryFireModes;

		while (FireMode != None) {
			if (InstantFire(FireMode.FireMode) != None) {
				bCanApply = true;
				break;
			}

			FireMode = FireMode.NextFireMode;
		}
	}

	if (
		(bCanApply == false) &&
		(Weapon.AlternateFireModes != None)
	) {
		FireMode = Weapon.AlternateFireModes;

		while (FireMode != None) {
			if (InstantFire(FireMode.FireMode) != None) {
				bCanApply = true;
				break;
			}

			FireMode = FireMode.NextFireMode;
		}
	}

	if (
		(bCanApply == false) &&
		(Weapon.PrimaryFireModes   == None) &&
		(Weapon.AlternateFireModes == None)
	) {
		for (i = 0; i < 2; ++i) {
			if (InstantFire(Weapon.GetFireMode(i)) != None) {
				bCanApply = true;
				break;
			}
		}
	}

	if (bCanApply == false) {
		Weapon.NotifyOwner(class'PenetratingModifier', 0);
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
	local int           i;
	local vector        X, Y, Z, StartTrace;
	local WeaponOfPower Weapon;

	Weapon = GetWeapon();

	if (HitLocation == vect(0,0,0)) {
		return;
	}

	for (i = 0; i < 2; ++i) {
		if (
			(InstantFire(Weapon.GetFireMode(i)) != None) &&
			(InstantFire(Weapon.GetFireMode(i)).DamageType == DamageType)
		) {
			//HACK - compensate for shock rifle not firing on crosshair
			if (
				(ShockBeamFire(Weapon.GetFireMode(i)) != None) &&
				(PlayerController(Instigator.Controller) != None)
			) {
				StartTrace = Instigator.Location + Instigator.EyePosition();
				Weapon.GetViewAxes(X,Y,Z);
				StartTrace = StartTrace + X*class'ShockProjFire'.Default.ProjSpawnOffset.X;

				if (Weapon.WeaponCentered() == false) {
					StartTrace =
						StartTrace +
						Weapon.Hand *
						Y * class'ShockProjFire'.Default.ProjSpawnOffset.Y +
						Z * class'ShockProjFire'.Default.ProjSpawnOffset.Z
					;
				}

				InstantFire(Weapon.GetFireMode(i)).DoTrace(
					HitLocation + Normal(HitLocation - StartTrace) * Victim.CollisionRadius * 2,
					rotator(HitLocation - StartTrace)
				);
			} else {
				InstantFire(Weapon.GetFireMode(i)).DoTrace(
					HitLocation + Normal(HitLocation - (Instigator.Location + Instigator.EyePosition())) * Victim.CollisionRadius * 2,
					rotator(HitLocation - (Instigator.Location + Instigator.EyePosition()))
				);
			}

			break;
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
			return "Penetrating cannot be applied to the current weapon!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ModifierEffect=Shader'XGameShaders.PlayerShaders.PlayerTrans'
    ModifierColor=(R=255,G=64,B=64,A=255),
    configuration=Class'PenetratingModifierConfiguration'
    Artifact=Class'PenetratingModifierArtifact'
}
