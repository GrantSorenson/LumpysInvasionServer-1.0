class AK47ProjAlt extends Projectile;

var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;
var	xEmitter SmokeTrail;
var vector initialDir;

var Effects Corona;

var bool bCurl;
var vector Dir;
var class<DamageType> DamageTypeHead;

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.Destroy();
	if ( Corona != None )
		Corona.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Local int RedChannel;
	Local int GreenChannel;
	Local int BlueChannel;

	RedChannel = Rand(256);
	GreenChannel = Rand(256);
	BlueChannel = Rand(256);

	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'tk_AK47.AK47PTrail',self);
                SmokeTrail.mColorRange[0].R = RedChannel;
                SmokeTrail.mColorRange[0].G = GreenChannel;
                SmokeTrail.mColorRange[0].B = BlueChannel;
                SmokeTrail.mColorRange[1].R = RedChannel;
                SmokeTrail.mColorRange[1].G = GreenChannel;
                SmokeTrail.mColorRange[1].B = BlueChannel;
		Corona = Spawn(class'tk_AK47.AK47Corona',self);
	}

	Dir = vector(Rotation);
	Velocity = speed * Dir;

	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	local Vector X;
	local float dist;

	X=Normal(Velocity+vect(0,0,0.5));

	if(Other == Instigator)	return;
	if(Other == Owner)	return;

	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
		Explode(HitLocation,Vect(0,0,1));

	if (!Other.bWorldGeometry)
	{
		if(	(Pawn(Other) != None) &&
			(Other.GetClosestBone(HitLocation,X,dist,'head',10) == 'head') )
		{
			Other.TakeDamage(Damage*2, Instigator, HitLocation, 1*X, DamageTypeHead);
		}
		else	Other.TakeDamage(Damage, Instigator, HitLocation, 1*X, MyDamageType);
	}

	Explode(HitLocation,Normal(HitLocation-Other.Location));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}


simulated function Explode(vector HitLocation, vector HitNormal)
{
      local RocketExplosion bingo;

	PlaySound(sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3',,2.5*TransientSoundVolume);

 	if (Role == ROLE_Authority)
	{
	    bingo = Spawn(class'tk_AK47.AK47KaBoomAlt',,,HitLocation + HitNormal*16,rotator(HitNormal));
	    bingo.RemoteRole=ROLE_SimulatedProxy;
	}

    if ( EffectIsRelevant(Location,false) )
    {
    }

	BlowUp(HitLocation);
	Destroyed();
	Destroy();
}

defaultproperties
{
     DamageTypeHead=Class'tk_AK47.AK47DamTypeHeadShot'
     Speed=14000.000000
     MaxSpeed=15000.000000
     Damage=200.000000
     DamageRadius=1.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_AK47.DamTypeAltAK47Dam'
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
