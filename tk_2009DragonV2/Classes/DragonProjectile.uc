class DragonProjectile extends Projectile placeable;

var Emitter Trail;
var() class<Emitter> TrailClass;
var() class<Emitter> ExplodeClass;
var bool bFireBreath;
var vector HitStart;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if (!bFireBreath)
		{
			Trail = Spawn(TrailClass,self);
			Trail.SetBase(Self);
		}
	}

	HitStart = Location;
	SetVelocity();
}

simulated function SetVelocity()
{
	Velocity = Vector(Rotation);
	Velocity *= Speed;
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
    if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
    {
        Explode(HitLocation, vect(0,0,1));
    }
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    if(Role == ROLE_Authority)
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }

	if(!bFireBreath)
	{
		Spawn(ExplodeClass,,,);
	}
	PlaySound(ImpactSound,,255);
	SpawnFX(HitLocation, HitStart);
    SetCollisionSize(0.0, 0.0);
    Destroy();
}

simulated function SpawnFX(vector HitLocation, vector HitStart);

simulated function Destroyed()
{
	if (Trail != None)
	{
		Trail.Kill();
	}
	Super.Destroyed();
}

defaultproperties
{
     TrailClass=Class'tk_2009Dragonv2.DragonProjTrail'
     ExplodeClass=Class'tk_2009Dragonv2.DragonProjExplode'
     Speed=1000.000000
     MaxSpeed=1300.000000
     Damage=20.000000
     DamageRadius=50.000000
     MomentumTransfer=25000.000000
     MyDamageType=Class'tk_2009Dragonv2.DamTypeDragon'
     ImpactSound=Sound'tk_2009Dragonv2.FireDragonProjBlast'
     DrawType=DT_Sprite
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=10.000000
     Texture=Shader'tk_2009Dragonv2.SFX.Invis'
}
