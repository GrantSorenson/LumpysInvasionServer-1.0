class GrenadePrimaryFire extends tk_ProjectileFire;

var()	float mHoldSpeedMin, mHoldSpeedMax;
var()	float mHoldSpeedGainPerSec, mHoldClampMax;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local GrenadeConc g;
	local vector X, Y, Z;
	local float pawnSpeed;

	g = Spawn(class'GrenadeConc', Instigator,, Start, Dir);
	if (g != None)
	{
		Weapon.GetViewAxes(X,Y,Z);
		pawnSpeed = X dot Instigator.Velocity;
		if (Bot(Instigator.Controller) != None)
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

defaultproperties
{
     mHoldSpeedMin=1250.000000
     mHoldSpeedMax=3500.000000
     mHoldSpeedGainPerSec=2750.000000
     ProjSpawnOffset=(X=25.000000,Y=10.000000,Z=-7.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bTossed=True
     bFireOnRelease=True
     TransientSoundVolume=1.000000
     FireLoopAnim=
     FireEndAnim=
     FireSound=Sound'tk_FHIWeapons.FHISnd.GrenadeLauncher_Fire'
     ReloadSound=Sound'WeaponSounds.BaseGunTech.BReload9'
     FireForce="AssaultRifleAltFire"
     AmmoClass=Class'tk_FHIWeapons.GrenadeAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'tk_FHIWeapons.GrenadeConc'
     BotRefireRate=0.800000
}