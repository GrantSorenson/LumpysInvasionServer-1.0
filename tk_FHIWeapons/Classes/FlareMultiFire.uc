class FlareMultiFire extends tk_ProjectileFire;

var() float TightSpread, LooseSpread;
var byte FlockIndex;

event ModeHoldFire()
{
	if (Instigator.IsLocallyControlled())
		PlayStartHold();
	else
		ServerPlayLoading();
}

simulated function ServerPlayLoading()
{
	if (FlareLauncher(Weapon) != None)
		FlareLauncher(Weapon).PlayOwnedSound(Sound'tk_FHIWeapons.FHISnd.RL_PickupAmmo', SLOT_None,,,,,false);
}

function PlayFireEnd()
{}

function PlayLoad(bool full)
{
	FlareLauncher(Weapon).PlayLoad(full);
}

function PlayStartHold()
{
	FlareLauncher(Weapon).PlayLoad(false);
}

function PlayFiring()
{
	if (Load > 1.0)
		FireAnim = 'AltFire';
	else
		FireAnim = 'Fire';

	Super.PlayFiring();
	FlareLauncher(Weapon).PlayFiring((Load == 6.0));
	Weapon.OutOfAmmo();
}

event ModeDoFire()
{
	if (FlareLauncher(Weapon).bTightSpread || ((Bot(Instigator.Controller) != None) && (FRand() < 0.65)))
	{
		Spread = TightSpread;
		SpreadStyle = SS_Ring;
	}
	else
	{
		SpreadStyle = SS_Line;
		Spread = LooseSpread;
	}

	FlareLauncher(Weapon).bTightSpread = false;
	Super.ModeDoFire();

	NextFireTime = FMax(NextFireTime, Level.TimeSeconds + FireRate);
}

function DoFireEffect()
{
	local Vector StartProj, StartTrace, X,Y,Z;
	local Rotator Aim;
	local Vector HitLocation, HitNormal,FireLocation;
	local Actor Other;
	local int p, q, SpawnCount, i;
	local FlareProj FiredRockets[4];
	local bool bCurl;

	if ((SpreadStyle == SS_Line) || (Load < 2))
	{
		Super.DoFireEffect();
		return;
	}

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();
	StartProj = StartTrace + X*ProjSpawnOffset.X + Z*ProjSpawnOffset.Z;
	if (!Weapon.WeaponCentered())
		StartProj = StartProj + Y*ProjSpawnOffset.Y;

	Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
	if (Other != None)
		StartProj = HitLocation;

	Aim = AdjustAim(StartProj, AimError);
	SpawnCount = Max(1, int(Load));

	for(p = 0; p < SpawnCount; p++)
	{
		Firelocation = StartProj - 2*((Sin(p*2*PI/3)*8 - 7)*Y - (Cos(p*2*PI/3)*8 - 7)*Z) - X * 8 * FRand();
		FiredRockets[p] = FlareProj(SpawnProjectile(FireLocation, Aim));
	}

	if (SpawnCount < 2)
		return;

	FlockIndex++;
	if (FlockIndex == 0)
		FlockIndex = 1;

	for(p = 0; p < SpawnCount; p++)
	{
		if (FiredRockets[p] != None)
		{
			FiredRockets[p].bCurl = bCurl;
			FiredRockets[p].FlockIndex = FlockIndex;
			i = 0;
			for (q = 0; q < SpawnCount; q++)
			{
				if ((p != q) && (FiredRockets[q] != None))
				{
					FiredRockets[p].Flock[i] = FiredRockets[q];
					i++;
				}
			}

			bCurl = !bCurl;
			if (Level.NetMode != NM_DedicatedServer)
				FiredRockets[p].SetTimer(0.1, true);
		}
	}
}

function ModeTick(float dt)
{
	if (HoldTime > 0.0 && Load >= Weapon.AmmoAmount(ThisModeNum) && !bNowWaiting)
		bIsFiring = false;

	Super.ModeTick(dt);

	if (Load == 1.0 && HoldTime >= FireRate)
	{
		if (Instigator.IsLocallyControlled())
			FlareLauncher(Weapon).PlayLoad(false);
		Load = Load + 1.0;
	}
	else if (Load == 2.0 && HoldTime >= FireRate*2.0)
	{
		Load = Load + 1.0;
	}
}

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     TightSpread=300.000000
     LooseSpread=1000.000000
     ProjSpawnOffset=(X=25.000000,Y=6.000000,Z=-6.000000)
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     bFireOnRelease=True
     MaxHoldTime=5.000000
     TransientSoundVolume=1.000000
     FireAnim="AltFire"
     TweenTime=0.000000
     FireSound=Sound'tk_FHIWeapons.FHISnd.FlareLauncher_AltFire'
     FireForce="RocketLauncherFire"
     FireRate=0.350000
     AmmoClass=Class'tk_FHIWeapons.FlareAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.FlareProj'
     BotRefireRate=0.600000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'XEffects.RocketMuzFlash1st'
     SpreadStyle=SS_Line
}