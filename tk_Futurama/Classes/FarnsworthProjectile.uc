class FarnsworthProjectile extends Projectile;

var Emitter FarnsworthProjectileEmitter;
var vector Dir;

simulated function Destroyed() 
{
	if (FarnsworthProjectileEmitter != None)
        FarnsworthProjectileEmitter.Destroy();
	
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		FarnsworthProjectileEmitter = Spawn(class'FarnsworthProjectileFX',self);
        FarnsworthProjectileEmitter.SetBase(self);
	}

	Dir = vector(Rotation);
	Velocity = speed * Dir;

    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

	Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) ) 
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
	PlaySound(sound'WeaponSounds.ShockRifle.ShockRifleExplosion',,2.5*TransientSoundVolume);
	spawn(class'FarnsworthProjectileExplosionFX',,,HitLocation + HitNormal*16 );
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
 	
	BlowUp(HitLocation);
	Destroy(); 
}

defaultproperties
{
     Speed=2000.000000
     MaxSpeed=2000.000000
     Damage=300.000000
     DamageRadius=140.000000
	 MomentumTransfer=50000.000000
	 ForceRadius=100.000000
     ForceScale=10.000000
     MyDamageType=Class'tk_Futurama.DamTypeFarnsworthProjectile'
	 AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
	 SoundVolume=255
     SoundRadius=100.000000
     DrawType=DT_Sprite
     bHidden=True
     LifeSpan=6.000000
     Texture=Texture'XEffectMat.Link.link_muz_red'
     DrawScale=0.300000
     Style=STY_Translucent
}
