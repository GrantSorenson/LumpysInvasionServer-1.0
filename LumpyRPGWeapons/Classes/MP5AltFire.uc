class MP5Altfire extends ProjectileFire;

const               mNumGrenades = 8;
var float           mCurrentRoll;
var float           mBlend;
var float           mRollInc;
var float           mNextRoll;
var float           mDrumRotationsPerSec;
var float           mRollPerSec;
var MP5Gun    mGun;
var int             mCurrentSlot;
var int             mNextEmptySlot;

var() float         mScale;
var() float         mScaleMultiplier;

var() float         mSpeedMin;
var() float         mSpeedMax;
var() float         mHoldSpeedMin;
var() float         mHoldSpeedMax;
var() float         mHoldSpeedGainPerSec;
var() float         mHoldClampMax;
var float ClickTime;

var() float         mWaitTime;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    mRollInc = -1.f * 65536.f / mNumGrenades;
    mRollPerSec = 65536.f * mDrumRotationsPerSec;
    mGun = MP5Gun(Weapon);
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
    FireRate = mWaitTime + 1.f / (mDrumRotationsPerSec * mNumGrenades);
}

simulated function bool AllowFire()
{
    if (Super.AllowFire())
        return true;
    else
    {
        if ( (PlayerController(Instigator.Controller) != None) && (Level.TimeSeconds > ClickTime) )
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
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip2');
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local mp5GunGrenade g;
    local vector X, Y, Z;
    local float pawnSpeed;

	mgun.PlayAnim('AltFire', 0.8, 0.0, 1);

	if ( HoldTime < 0.5) {
   		Spawn(class'rocketProj', Owner,, Start, Dir);
	}

 	if ( HoldTime >= 0.5) {
    	g = Spawn(class'MP5GunGrenade', Owner,, Start, Dir);
    	if (g != None)
    	{
    	    Weapon.GetViewAxes(X,Y,Z);
     	   pawnSpeed = X dot Instigator.Velocity;

			if ( Bot(Instigator.Controller) != None )
				g.Speed = mHoldSpeedMax;
			else
				g.Speed = mHoldSpeedMin + HoldTime*mHoldSpeedGainPerSec;
			g.Speed = FClamp(g.Speed, mHoldSpeedMin, mHoldSpeedMax);
       		g.Speed = pawnSpeed + g.Speed + 500;
       		//g.Speed = FClamp(g.Speed, mSpeedMin, mSpeedMax);
        	g.Velocity = g.Speed * Vector(Dir);

        	g.Damage *= DamageAtten;
		}
    }

 	if ( HoldTime >= 1 && mGun.ConsumeAmmo(1, 1)) {
    	g = Spawn(class'MP5GunGrenade', Owner,, Start, Dir);
    	if (g != None)
    	{
    	    Weapon.GetViewAxes(X,Y,Z);
     	   pawnSpeed = X dot Instigator.Velocity;

			if ( Bot(Instigator.Controller) != None )
				g.Speed = mHoldSpeedMax;
			else
				g.Speed = mHoldSpeedMin + HoldTime*mHoldSpeedGainPerSec;
			g.Speed = FClamp(g.Speed, mHoldSpeedMin, mHoldSpeedMax);
       		g.Speed = pawnSpeed + g.Speed + 800;
       		//g.Speed = FClamp(g.Speed, mSpeedMin, mSpeedMax);
        	g.Velocity = g.Speed * Vector(Dir);

        	g.Damage *= DamageAtten;
		}
     }

 	if ( HoldTime >= 2 && mGun.ConsumeAmmo(1, 1)) {
    	g = Spawn(class'MP5GunGrenade', Owner,, Start, Dir);
    	if (g != None)
    	{
    	    Weapon.GetViewAxes(X,Y,Z);
     	   pawnSpeed = X dot Instigator.Velocity;

			if ( Bot(Instigator.Controller) != None )
				g.Speed = mHoldSpeedMax;
			else
				g.Speed = mHoldSpeedMin + HoldTime*mHoldSpeedGainPerSec;
			g.Speed = FClamp(g.Speed, mHoldSpeedMin, mHoldSpeedMax);
       		g.Speed = pawnSpeed + g.Speed + 300;
       		//g.Speed = FClamp(g.Speed, mSpeedMin, mSpeedMax);
        	g.Velocity = g.Speed * Vector(Dir);

        	g.Damage *= DamageAtten;
		}
    }
    return g;

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
    local float diff;
    local float inc;

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
    if (++count >= mNumGrenades)
        count = 0;
    return oldcount;
}

function PlayPreFire()   {}
function PlayStartHold() {}
function PlayFiring()    {}
function PlayFireEnd()   {}

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
        
        if (Level.NetMode != NM_Client)
            Weapon.PlaySound(FireSound,SLOT_Interact,TransientSoundVolume,,512.0,,false);
            
        ClientPlayForceFeedback(FireForce);  // jdf

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
        GotoState('LoadNext'); //goto idle if out of ammo?
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
		if ( Weapon.Mesh != Weapon.OldMesh )
			GotoState('Idle');
        else if (UpdateRoll(dt))
            GotoState('Idle');
    }
}

function StartBerserk()
{
    mHoldSpeedGainPerSec = default.mHoldSpeedGainPerSec * 0.75;
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function StopBerserk()
{
    mHoldSpeedGainPerSec = default.mHoldSpeedGainPerSec;
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function StartSuperBerserk()
{
    mHoldSpeedGainPerSec = default.mHoldSpeedGainPerSec * Level.GRI.WeaponBerserk;
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
    FireRate = mWaitTime + 1.f / (mDrumRotationsPerSec * mNumGrenades) / Level.GRI.WeaponBerserk;
}

defaultproperties
{
    mBlend=1.00
    mDrumRotationsPerSec=1.00
    mScale=1.00
    mScaleMultiplier=0.90
    mSpeedMin=250.00
    mSpeedMax=3000.00
    mHoldSpeedMin=850.00
    mHoldSpeedMax=1600.00
    mHoldSpeedGainPerSec=750.00
    mWaitTime=0.30
    ProjSpawnOffset=(X=25.00,Y=10.00,Z=-7.00),
    bSplashDamage=True
    bRecommendSplashDamage=True
    bTossed=True
    bFireOnRelease=True
    FireLoopAnim=None
    FireEndAnim=None
    FireSound=SoundGroup'WeaponSounds.AssaultRifle.AssaultRifleAltFire'
    ReloadSound=Sound'WeaponSounds.BaseGunTech.BReload9'
    FireForce="AssaultRifleAltFire"
    AmmoClass=Class'MP5GrenadeAmmo'
    AmmoPerFire=1
    ShakeRotTime=2.00
    ShakeOffsetMag=(X=-20.00,Y=0.00,Z=0.00),
    ShakeOffsetRate=(X=-1000.00,Y=0.00,Z=0.00),
    ShakeOffsetTime=2.00
    ProjectileClass=Class'MP5GunGrenade'
    BotRefireRate=0.25
    FlashEmitterClass=Class'XEffects.AssaultMuzFlash1st'
}
