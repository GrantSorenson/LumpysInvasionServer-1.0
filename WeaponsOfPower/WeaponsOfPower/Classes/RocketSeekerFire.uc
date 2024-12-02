class RocketSeekerFire extends ProjectileFire;

var RocketSeekerFireMode FireModeOwner;

var int SeekerAmmoPerFire;

////////////////////////////////////////////////////////////////////////////////

function ModeHoldFire() {
	FireModeOwner.BeginTargetting();

	if (Instigator.IsLocallyControlled()) {
		PlayStartHold();
	} else {
		ServerPlayLoading();
	}
}

////////////////////////////////////////////////////////////////////////////////

function ServerPlayLoading() {
	RocketLauncher(Weapon).PlayOwnedSound(
		Sound'WeaponSounds.RocketLauncher.RocketLauncherLoad',
		SLOT_None,,,,,
		false
	);
}

////////////////////////////////////////////////////////////////////////////////

function PlayFireEnd() { }

////////////////////////////////////////////////////////////////////////////////

function PlayStartHold() {
	//RocketLauncher(Weapon).PlayLoad(false);
}

////////////////////////////////////////////////////////////////////////////////

function PlayFiring() {
	FireAnim = 'AltFire';
	//super.PlayFiring();
	//RocketLauncher(Weapon).PlayFiring(false);
	Weapon.OutOfAmmo();
}

////////////////////////////////////////////////////////////////////////////////

function ModeDoFire() {
	super.ModeDoFire();

	// The super only consumes one unit of ammo, we need to adjust for
	// all of the targets.
	if (Weapon.Role == ROLE_Authority) {
		if (FireModeOwner.Targets.Length > 0) {
			Weapon.ConsumeAmmo(ThisModeNum, SeekerAmmoPerFire * (FireModeOwner.Targets.Length) - 1);
		}
	}

	FireModeOwner.EndTargetting();

	NextFireTime = FMax(
		NextFireTime,
		Level.TimeSeconds + FireRate
	);
}

////////////////////////////////////////////////////////////////////////////////

function InitEffects() {
	Super.InitEffects();

	if (FlashEmitter != None) {
		Weapon.AttachToBone(FlashEmitter, 'tip');
	}
}

////////////////////////////////////////////////////////////////////////////////

function DoFireEffect() {
	local SeekingRocketProjectile SeekingRocket;
	local vector  StartProj, StartTrace, X, Y, Z;
	local vector  TempStart;
	local vector  StartOffset;
	local rotator Aim;
	//local rotator StartRotation;
	local vector  HitLocation, HitNormal;
	local Actor   Other;
	local int     i;
  //local float   fPercent;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();
	StartProj  = StartTrace + X * ProjSpawnOffset.X;

	if (Weapon.WeaponCentered() == false) {
		StartProj = StartProj + Weapon.Hand * Y * ProjSpawnOffset.Y + Z * ProjSpawnOffset.Z;
	}

	Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

	if (Other != None) {
	    StartProj = HitLocation;
	}

	Aim = AdjustAim(StartProj, AimError);

	StartOffset.Y = 40;

	if (FireModeOwner.Targets.Length > 0) {
		for (i = 0; i < FireModeOwner.Targets.Length; ++i) {
			// Gotta figure out the math to have these in a circle around the muzzle...
			//fPercent           = float(i) / float(Targets.length + 1) * 65535.0;
			//StartRotation.Roll = fPercent;
			TempStart          = StartProj;// + Y * (StartOffset >> StartRotation);

			SeekingRocket = SeekingRocketProjectile(SpawnProjectile(TempStart, Aim));

			if (SeekingRocket != None) {
				SeekingRocket.SetTarget(FireModeOwner.Targets[i]);
			}
		}
	} else {
		SpawnProjectile(StartProj, Aim);
	}
}

////////////////////////////////////////////////////////////////////////////////

function Projectile SpawnProjectile(
	Vector  Start,
	Rotator Dir
) {
	local Projectile Proj;
	local color      trailColor1;
	local color      trailColor2;

	if (FireModeOwner.Targets.Length > 0) {
		Proj = Spawn(class'SeekingRocketProjectile',,, Start, Dir);

		if (Pawn(FireModeOwner.Weapon.Owner) != None) {
			trailColor1 = class'HudCDeathmatchHelper'.static.GetHudTeamColor(Pawn(FireModeOwner.Weapon.Owner));
			trailColor2 = class'HudCDeathmatchHelper'.static.ShiftHue(trailColor1, 0.16161616);

			SeekingRocketProjectile(Proj).SetTrailColor(
				trailColor1,
				trailColor2
			);
		}
	} else {
		Proj = Spawn(class'RocketProj',,, Start, Dir);
	}

	return Proj;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    ProjSpawnOffset=(X=25.00,Y=6.00,Z=-6.00),
    bSplashDamage=True
    bSplashJump=True
    bFireOnRelease=True
    MaxHoldTime=6000.00
    FireAnim=AltFire
    TweenTime=0.00
    FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
    FireForce="RocketLauncherFire"
    FireRate=1.00
    AmmoClass=Class'XWeapons.RocketAmmo'
    AmmoPerFire=1
    load=1.00
    ShakeRotTime=2.00
    ShakeOffsetMag=(X=-20.00,Y=0.00,Z=0.00),
    ShakeOffsetRate=(X=-1000.00,Y=0.00,Z=0.00),
    ShakeOffsetTime=2.00
    ProjectileClass=Class'XWeapons.RocketProj'
    BotRefireRate=0.60
    WarnTargetPct=0.90
    FlashEmitterClass=Class'XEffects.RocketMuzFlash1st'
    SpreadStyle=2
}
