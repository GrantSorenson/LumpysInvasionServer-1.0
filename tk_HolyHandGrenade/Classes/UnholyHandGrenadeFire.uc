class UnholyHandGrenadeFire extends HolyHandGrenadeFire;

var bool bInstantExplode;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local UnholyHandGrenadeProj g;
    local vector X, Y, Z;
    local float pawnSpeed;

    g = Spawn(class'UnholyHandGrenadeProj', Instigator,, Start, Dir);
    if (g != None)
    {
        if(bInstantExplode)
            g.bInstantExplode = true;
        g.bIsUnholy = true;
        g.LightHue = 160;
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

defaultproperties
{
     ProjectileClass=Class'tk_HolyHandGrenade.UnholyHandGrenadeProj'
}
