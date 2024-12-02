class MiniRocketAltFire extends tk_ProjectileFire;

var() float TightSpread, LooseSpread;
var byte FlockIndex;
var int MaxLoad;

event ModeHoldFire()
{
	if (Instigator.IsLocallyControlled())
		PlayStartHold();
	else
		ServerPlayLoading();
}

simulated function ServerPlayLoading()
{
	MiniRocketLauncher(Weapon).PlayOwnedSound(Sound'tk_FHIWeapons.FHISnd.GrenadeLauncher_PickupAmmo', SLOT_None,,,,,false);
}

function PlayFireEnd()
{}

function PlayStartHold()
{
	MiniRocketLauncher(Weapon).PlayLoad(false);
}

function PlayFiring()
{
	if (Load > 1.0)
		FireAnim = 'Fire';
	else
		FireAnim = 'Fire';

	Super.PlayFiring();
	MiniRocketLauncher(Weapon).PlayFiring((Load == MaxLoad));
	Weapon.OutOfAmmo();
}

event ModeDoFire()
{
	if (MiniRocketLauncher(Weapon).bTightSpread || ((Bot(Instigator.Controller) != None) && (FRand() < 0.65)))
	{
		Spread = TightSpread;
		SpreadStyle = SS_Ring;
	}
	else
	{
		SpreadStyle = SS_Line;
		Spread = LooseSpread;
	}
	MiniRocketLauncher(Weapon).bTightSpread = false;

	Super.ModeDoFire();
	NextFireTime = FMax(NextFireTime, Level.TimeSeconds + FireRate);
}

function DoFireEffect()
{
	local Vector StartProj, StartTrace, X,Y,Z;
	local Rotator Aim;
	local Vector HitLocation, HitNormal,FireLocation;
	local Actor Other;
	local int p,q, SpawnCount, i;
	local MiniRocketProj FiredRockets[7];
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
		StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y;

	// check if projectile would spawn through a wall and adjust start location accordingly
	Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
	if (Other != None)
		StartProj = HitLocation;
	
	Aim = AdjustAim(StartProj, AimError);
	SpawnCount = Max(1, int(Load));
	for(p = 0; p < SpawnCount; p++)
	{
		Firelocation = StartProj - 2*((Sin(p*2*PI/3)*8 - 7)*Y - (Cos(p*2*PI/3)*8 - 7)*Z) - X * 8 * FRand();
		FiredRockets[p] = MiniRocketProj(SpawnProjectile(FireLocation, Aim));
	}
	
	if (SpawnCount < 2)
		return;

	FlockIndex++;
	if (FlockIndex == 0)
		FlockIndex = 1;

	// To get crazy flying, we tell each projectile in the flock about the others.
	for(p = 0; p < SpawnCount; p++)
	{
		if (FiredRockets[p] != None)
		{
			FiredRockets[p].bCurl = bCurl;
			FiredRockets[p].FlockIndex = FlockIndex;
			i = 0;
			for(q = 0; q < SpawnCount; q++)
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
			MiniRocketLauncher(Weapon).PlayLoad(false);
		else
			ServerPlayLoading();
				
		Load = Load + 1.0;
	}
	else if (Load == 2.0 && HoldTime >= FireRate*2.0)
	{
		if (Instigator.IsLocallyControlled())
			MiniRocketLauncher(Weapon).PlayLoad(false);
		else
			ServerPlayLoading();

		Load = Load + 1.0;
	}
	else if (Load == 3.0 && HoldTime >= FireRate*3.0)
	{
		if (Instigator.IsLocallyControlled())
			MiniRocketLauncher(Weapon).PlayLoad(false);
		else
			ServerPlayLoading();

		Load = Load + 1.0;
	}
	else if (Load == 4.0 && HoldTime >= FireRate*4.0)
	{
		if (Instigator.IsLocallyControlled())
			MiniRocketLauncher(Weapon).PlayLoad(false);
		else
			ServerPlayLoading();

		Load = Load + 1.0;
	}
	else if (Load == 5.0 && HoldTime >= FireRate*5.0)
	{
		if (Instigator.IsLocallyControlled())
			MiniRocketLauncher(Weapon).PlayLoad(false);
		else
			ServerPlayLoading();

		Load = Load + 1.0;
	}
}

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'flash');
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile p;
	
	p = MiniRocketLauncher(Weapon).SpawnProjectile(Start, Dir);
	if (P != None)
		p.Damage *= DamageAtten;

	return p;
}

defaultproperties
{
     TightSpread=300.000000
     LooseSpread=1200.000000
     MaxLoad=6
     ProjSpawnOffset=(X=100.000000,Y=18.000000,Z=-16.000000)
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     bFireOnRelease=True
     MaxHoldTime=4.000000
     TransientSoundVolume=1.000000
     FireAnim="FireEnd"
     FireAnimRate=2.000000
     TweenTime=0.000000
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=0.250000
     AmmoClass=Class'tk_FHIWeapons.MiniRocketAmmo'
     AmmoPerFire=1
     ProjectileClass=Class'tk_FHIWeapons.MiniRocketProj'
     BotRefireRate=0.775000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'XEffects.RocketMuzFlash1st'
     SpreadStyle=SS_Line
}