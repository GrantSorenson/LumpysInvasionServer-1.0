class DroneProj extends Projectile;

var Emitter projEffect;

replication
{
	reliable if(Role==ROLE_Authority)
		projEffect;
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();

	Velocity = Speed * vector(Rotation);
	Acceleration = Velocity;
	if(Level.NetMode != NM_DedicatedServer)
	{
		projEffect = Spawn(class'DroneProjEffect',self,,Location,Rotation);
		if(projEffect != None)
			projEffect.SetBase(self);
	}
	
}

simulated function Destroyed()
{
	if(projEffect != None)
		projEffect.Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		}
		Explode(HitLocation, vect(0,0,1));
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');
	Destroy();
}



defaultproperties
{
    Speed=1200.00
    MaxSpeed=2400.00
    Damage=9.00
    MomentumTransfer=1600.00
    MyDamageType=Class'DamTypeDronePlasma'
    DrawType=0
    bNetTemporary=False
    AmbientSound=Sound'WeaponSounds.LinkGun.LinkGunProjectile'
    LifeSpan=3.00
    SoundVolume=255
    SoundRadius=50.00
    ForceType=2
    ForceRadius=30.00
    ForceScale=5.00
}
