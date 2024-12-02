class HVBombFire extends tk_ProjectileFire;

const mNumGrenades = 8;

var float mCurrentRoll, mNextRoll;
var float mBlend, mRollInc;
var float mDrumRotationsPerSec, mRollPerSec;
var HVAssaultRifle mGun;
var int mCurrentSlot, mNextEmptySlot;

var() float mScale, mScaleMultiplier;
var() float mSpeedMin, mSpeedMax;
var() float mHoldSpeedMin, mHoldSpeedMax;
var() float mHoldSpeedGainPerSec, mHoldClampMax;

var float ClickTime;
var() float mWaitTime;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	mRollInc = (-1.f * 65536.f / mNumGrenades);
	mRollPerSec = (65536.f * mDrumRotationsPerSec);
	mGun = HVAssaultRifle(Owner);
	mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
	FireRate = (mWaitTime + 1.f / (mDrumRotationsPerSec * mNumGrenades));
	SetTimer(2, true);
}

function DrawMuzzleFlash(Canvas Canvas)
{
}

simulated function bool AllowFire()
{
	if (Super.AllowFire())
	{
		return true;
	}
	else
	{
		if ((PlayerController(Instigator.Controller) != None) && (Level.TimeSeconds > ClickTime))
		{
			Instigator.PlaySound(Sound'NewWeaponSounds.newclickgrenade');
			ClickTime = Level.TimeSeconds + 0.25;
		}
		return false;
	}
}

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'tip2');
}

function DoFireEffect()
{
	local Vector StartProj, StartTrace, X,Y,Z;
	local Rotator Aim;
	local Vector HitLocation, HitNormal;
	local Actor Other;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();// + X*Instigator.CollisionRadius;
	StartProj = StartTrace + X*ProjSpawnOffset.X;
	if (HVAssaultRifle(Weapon).bDualMode)
	{
		HVAssaultRifle(Weapon).bFireLeft = !HVAssaultRifle(Weapon).bFireLeft;
		if (HVAssaultRifle(Weapon).bFireLeft)
			Y *= -1;
	}

	if (!Weapon.WeaponCentered())
		StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

	Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
	if (Other != None)
		StartProj = HitLocation;

	Aim = AdjustAim(StartProj, AimError);
	SpawnProjectile(StartProj, Aim);
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile p;

	p = Super.SpawnProjectile(Start, Dir);

	return p;
}

simulated function ReturnToIdle()
{
	UpdateRoll(FireRate);
	GotoState('Idle');
}

// Client-side only: update the first person drum rotation
simulated function bool UpdateRoll(float dt)
{
	local rotator r;
	local bool bDone;
	local float diff, inc;

	diff = mCurrentRoll - mNextRoll;
	inc = dt*mRollPerSec;
	if (inc >= diff)
	{
		inc = diff;
		bDone = true;
	}

	mCurrentRoll -= inc;
	mCurrentRoll = mCurrentRoll % 65536.f;
	r.Roll = int(mCurrentRoll);

	mGun.SetBoneRotation('Bone_Drum', r, 0, mBlend);

	return bDone;
}

simulated function int WrapPostIncr(out int count)
{
	local int oldcount;

	oldcount = count;
	if (count++ >= mNumGrenades)
		count = 0;

	return oldcount;
}

function PlayPreFire()
{}

function PlayStartHold()
{}

function PlayFiring()
{}

function PlayFireEnd()
{}

auto state Idle
{
	function StopFiring()
	{
		local rotator r;

		if (Instigator.Weapon != Weapon)
			return;

		r.Roll = Rand(65536);
		Weapon.SetBoneRotation('Bone_Flash02', r, 0, 1.f);

		mNextRoll = mCurrentRoll + mRollInc;
		mGun.PlayAnim(FireAnim, FireAnimRate, 0.0);

		if ((Level.NetMode != NM_Client) && (Instigator.DrivenVehicle == None))
			Weapon.PlaySound(FireSound,SLOT_Interact,TransientSoundVolume,,512.0,,false);

		ClientPlayForceFeedback(FireForce);
		GotoState('Wait');

		Super.StopFiring();
	}
}

state Wait
{
	function BeginState()
	{
		SetTimer(mWaitTime, false);
	}

	function Timer()
	{
		GotoState('LoadNext');
	}
}

state LoadNext
{
	function BeginState()
	{
		if (Level.NetMode != NM_Client)
			Weapon.PlaySound(ReloadSound,SLOT_None,,,512.0,,false);
		ClientPlayForceFeedback(ReloadForce);
	}

	function ModeTick(float dt)
	{
		if (Weapon.Mesh != Weapon.OldMesh)
			GotoState('Idle');
		else if (UpdateRoll(dt))
			GotoState('Idle');
	}
}

function StartBerserk()
{
	FireRate = default.FireRate * 1.33;
}

function StopBerserk()
{
	FireRate = default.FireRate;
}

function StartSuperBerserk()
{
	FireRate = default.FireRate * 1.5/Level.GRI.WeaponBerserk;
	FireAnimRate = default.FireAnimRate * 0.667 * Level.GRI.WeaponBerserk;
	if (HVAssaultRifle(Weapon) != None && HVAssaultRifle(Weapon).bDualMode)
		FireRate *= 0.55;
}

function Timer()
{
	super.Timer();

	FireRate = default.FireRate;
	AmmoPerFire = 1;
}

defaultproperties
{
     mBlend=1.000000
     mDrumRotationsPerSec=0.400000
     mScale=1.000000
     mScaleMultiplier=0.900000
     mSpeedMin=950.000000
     mSpeedMax=6000.000000
     mHoldSpeedMin=1850.000000
     mHoldSpeedMax=6600.000000
     mHoldSpeedGainPerSec=1750.000000
     mWaitTime=0.500000
     ProjSpawnOffset=(X=25.000000,Y=10.000000,Z=-7.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     TransientSoundVolume=1.000000
     FireLoopAnim=
     FireEndAnim=
     FireAnimRate=0.500000
     FireSound=Sound'NewWeaponSounds.NewGrenadeShoot'
     ReloadSound=Sound'WeaponSounds.BaseGunTech.BReload9'
     FireForce="AssaultRifleAltFire"
     ReloadForce="BReload9"
     FireRate=1.000000
     AmmoClass=Class'tk_FHIWeapons.HVBombAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.HVBombProjectile'
     BotRefireRate=0.550000
     FlashEmitterClass=Class'tk_FHIWeapons.HVAssaultMuzFlash'
}