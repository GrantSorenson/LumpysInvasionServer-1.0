class RazorBombHeld extends RazorBombFire;

var()	float         mHoldSpeedMin;
var()	float         mHoldSpeedMax;
var()	float         mHoldSpeedGainPerSec;
var()	float         mHoldClampMax;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local RazorBombProj g;
    local vector X, Y, Z;
    local float pawnSpeed;

    g = Spawn(class'RazorBombProj', instigator,, Start, Dir);
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
        //g.Speed = FClamp(g.Speed, mSpeedMin, mSpeedMax);
        g.Velocity = g.Speed * Vector(Dir);

        g.Damage *= DamageAtten;
    }
    return g;
}

function PlayPreFire()
{}

function PlayStartHold()
{}

function PlayFiring()
{}

function PlayFireEnd()
{}

defaultproperties
{
     mHoldSpeedMin=750.000000
     mHoldSpeedMax=1000.000000
     mHoldSpeedGainPerSec=720.000000
     bFireOnRelease=True
}