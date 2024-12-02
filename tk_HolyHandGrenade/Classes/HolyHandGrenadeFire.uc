class HolyHandGrenadeFire extends tk_ProjectileFire;

var() float         mSpeedMin;
var() float         mSpeedMax;
var() float         mHoldSpeedMin;
var() float         mHoldSpeedMax;
var() float         mHoldSpeedGainPerSec;
var() float         mHoldClampMax;
var float ClickTime;

var() float         mWaitTime;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local HolyHandGrenadeProj g;
    local vector X, Y, Z;
    local float pawnSpeed;

    g = Spawn(class'tk_HolyHandGrenade.HolyHandGrenadeProj', Instigator,, Start, Dir);
    if (g != None)
    {
        Weapon.GetViewAxes(X,Y,Z);
        pawnSpeed = X dot Instigator.Velocity;

		if ( Bot(Instigator.Controller) != None )
			g.Speed = mHoldSpeedMax;
		else
			g.Speed = mHoldSpeedMin + HoldTime*mHoldSpeedGainPerSec;
		g.Speed = FClamp(g.Speed, mHoldSpeedMin, mHoldSpeedMax);
        g.Speed = pawnSpeed + g.Speed;
        g.Velocity = g.Speed * Vector(Dir);

        g.Damage *= DamageAtten;
    }
    return g;
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


defaultproperties
{
     mSpeedMin=250.000000
     mSpeedMax=3000.000000
     mHoldSpeedMin=850.000000
     mHoldSpeedMax=1600.000000
     mHoldSpeedGainPerSec=750.000000
     ProjSpawnOffset=(X=25.000000,Y=10.000000,Z=-7.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     bFireOnRelease=True
     FireAnim="PutDown"
     FireForce="AssaultRifleAltFire"
     AmmoClass=Class'tk_HolyHandGrenade.HolyHandGrenadeAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'tk_HolyHandGrenade.HolyHandGrenadeProj'
     BotRefireRate=0.250000
}