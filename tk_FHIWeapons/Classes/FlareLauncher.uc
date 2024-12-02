class FlareLauncher extends tk_Weapon
	config(TKWeaponsClient);

const NUM_BARRELS = 3;
const BARREL_ROTATION_RATE = 2.95;

var float BarrelRotation, FinalRotation;
var bool bRotateBarrel, bTightSpread;

Replication
{
	reliable if (Role < ROLE_Authority)
		ServerSetTightSpread, ServerClearTightSpread;
}

simulated function PlayIdle()
{
	LoopAnim(IdleAnim, IdleAnimRate, 0.25);
}

simulated function PlayFiring(bool plunge)
{
	if (plunge)
		GotoState('AnimateLoad', 'Begin');
}

simulated function PlayLoad(bool full)
{
	if (!full)
		GotoState('AnimateLoad', 'Begin');
}

simulated function AnimEnd(int Channel)
{
	if ((Channel == 0) && (ClientState == WS_ReadyToFire))
	{
		PlayIdle();
		if ((Role < ROLE_Authority) && !HasAmmo())
			DoAutoSwitch();
	}
}

simulated function RotateBarrel()
{
	FinalRotation += 65535.0 / NUM_BARRELS;
	if (FinalRotation >= 65535.0)
	{
		FinalRotation -= 65535.0;
		BarrelRotation -= 65535.0;
	}
	bRotateBarrel = true;
}

simulated function UpdateBarrel(float dt)
{
	local Rotator R;

	BarrelRotation += dt * 65535.0 * BARREL_ROTATION_RATE / NUM_BARRELS;
	if (BarrelRotation > FinalRotation)
	{
		BarrelRotation = FinalRotation;
		bRotateBarrel = false;
	}

	R.Roll = BarrelRotation;
	SetBoneRotation('Bone_Barrel', R, 0, 1);
}

simulated function Plunge()
{
	PlayAnim('load', 0.8, 0.0, 1);
	PlayAnim('load', 0.8, 0.0, 2);
}

simulated event ClientStartFire(int Mode)
{
	local int OtherMode;

	if (FlareMultiFire(FireMode[Mode]) != None)
	{
		SetTightSpread(false);
	}
	else
	{
		if (Mode == 0)
			OtherMode = 1;
		else
			OtherMode = 0;

		if (FireMode[OtherMode].bIsFiring || (FireMode[OtherMode].NextFireTime > Level.TimeSeconds))
		{
			if (FireMode[OtherMode].Load > 0)
				SetTightSpread(true);

			if (bDebugging)
				log("No RL reg fire because other firing "$FireMode[OtherMode].bIsFiring$" next fire "$(FireMode[OtherMode].NextFireTime - Level.TimeSeconds));

			return;
		}
	}
	Super.ClientStartFire(Mode);
}

simulated function bool StartFire(int Mode)
{
	local int OtherMode;

	if (Mode == 0)
		OtherMode = 1;
	else
		OtherMode = 0;

	if (FireMode[OtherMode].bIsFiring || (FireMode[OtherMode].NextFireTime > Level.TimeSeconds))
		return false;

	return Super.StartFire(Mode);
}

simulated function SetTightSpread(bool bNew, optional bool bForce)
{
	if ((bTightSpread != bNew) || bForce)
	{
		bTightSpread = bNew;
		if (bTightSpread)
			ServerSetTightSpread();
		else
			ServerClearTightSpread();
	}
}

function ServerClearTightSpread()
{
	bTightSpread = false;
}

function ServerSetTightSpread()
{
	bTightSpread = true;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	SetTightSpread(false, true);
	if (Instigator.IsLocallyControlled())
	{
		AnimBlendParams(1, 1.0, 0.0, 0.0, 'bone_shell');
		AnimBlendParams(2, 1.0, 0.0, 0.0, 'bone_feed');
		SetBoneRotation('Bone_Barrel', Rot(0,0,0), 0, 1);
	}
	Super.BringUp(PrevWeapon);
}

simulated state AnimateLoad
{
	simulated function Tick(float dt)
	{
		if (bRotateBarrel)
			UpdateBarrel(dt);
	}

Begin:
	Sleep(0.15);
	RotateBarrel();
	Sleep(0.07);
	PlayOwnedSound(Sound'tk_FHIWeapons.FHISnd.RL_PickupAmmo', SLOT_None,,,,,false);
	ClientPlayForceFeedback("RocketLauncherLoad");
	Sleep(0.28);
	Plunge();
	PlayOwnedSound(Sound'WeaponSounds.RocketLauncher.RocketLauncherPlunger', SLOT_None,,,,,false);
	ClientPlayForceFeedback("RocketLauncherPlunger");
	Sleep(0.29);
	GotoState('');
}

function float SuggestAttackStyle()
{
	local float EnemyDist;

	EnemyDist = VSize(Instigator.Controller.Enemy.Location - Owner.Location);
	if (EnemyDist < 750)
	{
		if (EnemyDist < 500)
			return -1.5;
		else
			return -0.7;
	}
	else if (EnemyDist > 1600)
	{
		return 0.5;
	}
	else
	{
		return -0.1;
	}
}

function float GetAIRating()
{
	local Bot B;
	local float EnemyDist, Rating, ZDiff;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ((B == None) || (B.Enemy == None))
		return AIRating;

	if ((Instigator.Base != None) && (Instigator.Base.Velocity != vect(0,0,0)) && !B.CheckFutureSight(0.1))
		return 0.1;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	Rating = AIRating;

	if (EnemyDist < 360)
	{
		if (Instigator.Weapon == self)
		{
			if ((EnemyDist > 250) || ((Instigator.Health < 50) && (Instigator.Health < B.Enemy.Health - 30)))
				return Rating;
		}
		return 0.05 + EnemyDist * 0.001;
	}

	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if (ZDiff > 120)
		Rating += 0.25;
	else if (ZDiff < -160)
		Rating -= 0.35;
	else if (ZDiff < -80)
		Rating -= 0.05;

	if ((B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon && (EnemyDist < 2500))
		Rating += 0.25;

	return Rating;
}

function byte BestMode()
{
	local bot B;

	B = Bot(Instigator.Controller);
	if ((B == None) || (B.Enemy == None))
		return 0;

	if ((FRand() < 0.3) && !B.IsStrafing() && (Instigator.Physics != PHYS_Falling))
		return 1;

	return 0;
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.FlareFire'
     FireModeClass(1)=Class'tk_FHIWeapons.FlareMultiFire'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     IdleAnimRate=0.500000
     SelectSound=Sound'WeaponSounds.RocketLauncher.SwitchToRocketLauncher'
     SelectForce="SwitchToRocketLauncher"
     AIRating=0.780000
     CurrentRating=0.780000
     Description="The IPFL-MkIII is the latest variant of the Flare Launcher. Firing Ionized Plasma Flare Missiles, the Flare Launcher is one of the deadliest weapons currently in production for the Tournament. With an extreme fire rate on primary, and the ability to load up three missiles on secondary, the Flare Launcher makes very short work of all but the most heavily armoured of opponents. The basic look and feel of the weapon has changed little since it's incorporation into the Tournament, however, the latest batch of upgrades to the missiles themselves have certainly improved the dramatic good looks of the weapon."
     EffectOffset=(X=50.000000,Y=1.000000,Z=10.000000)
     DisplayFOV=60.000000
     Priority=26
     HudColor=(G=0)
     SmallViewOffset=(X=12.000000,Y=14.000000,Z=-6.000000)
     CenteredOffsetY=-5.000000
     CenteredYaw=-500
     CustomCrosshair=15
     CustomCrossHairColor=(B=0,G=0)
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Triad2"
     InventoryGroup=8
     GroupOffset=10
     PickupClass=Class'tk_FHIWeapons.FlareLauncherPickup'
     PlayerViewOffset=(Y=8.000000)
     PlayerViewPivot=(Yaw=500,Roll=1000)
     BobDamping=2.990000
     AttachmentClass=Class'tk_FHIWeapons.FlareAttachment'
     IconMaterial=Texture'tk_FHIWeapons.FHIHud.HUDIcons'
     IconCoords=(X1=44,Y1=306,X2=134,Y2=343)
     ItemName="Flare Launcher"
     Mesh=SkeletalMesh'Weapons.RocketLauncher_1st'
     Skins(0)=Texture'tk_FHIWeapons.FHITex.FlareLauncherTex'
     HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
}