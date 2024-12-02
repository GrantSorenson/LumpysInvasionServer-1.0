class LilLadyProj extends Projectile;

var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;
var xEmitter SmokeTrail;
var vector initialDir;

var Effects Corona;
var bool bCurl;
var vector Dir;

simulated function Destroyed() 
{
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	if (Corona != None)
		Corona.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'tk_LilLady.LilLadyTrail',self);
		Corona = Spawn(class'tk_LilLady.LilLadyCorona',self);
	}

	Dir = vector(Rotation);
	Velocity = speed * Dir;

	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
	if (Level.bDropDetail)
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ((Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget)) 
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
	local RocketExplosion bingo;

	PlaySound(sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3',,2.5*TransientSoundVolume);

 	if (Role == ROLE_Authority)
	{
		bingo = Spawn(class'tk_LilLady.LilLadyBlows',,,HitLocation + HitNormal*16,rotator(HitNormal));
		bingo.RemoteRole=ROLE_SimulatedProxy;
	}

	if (EffectIsRelevant(Location,false))
	{}

	BlowUp(HitLocation);
	Destroyed();
	Destroy(); 
}

simulated function Timer()
{
	Velocity =  Default.Speed * Normal(Dir * 0.5 * Default.Speed + Velocity);
}

defaultproperties
{
     Speed=14000.000000
     MaxSpeed=15000.000000
     Damage=90.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_LilLady.DamTypeLilLady'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=35.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=6.000000
     AmbientGlow=96
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=200.000000
     ForceScale=35.000000
}
