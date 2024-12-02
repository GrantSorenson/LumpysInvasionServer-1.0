class FlareProj extends Projectile;

var bool bRing, bHitWater, bWaterStart;
var int NumExtraRockets;
var xEmitter SmokeTrail;

var byte FlockIndex;
var FlareProj Flock[2];

var() float	FlockRadius, FlockStiffness;
var() float FlockMaxForce, FlockCurlForce;
var bool bCurl;
var vector Dir;

var sound ImpactSounds[3];

replication
{
	reliable if (bNetInitial && (Role == ROLE_Authority))
		FlockIndex, bCurl;
}

simulated function Destroyed() 
{
	if (SmokeTrail != None)
		SmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Dir = vector(Rotation);
	if (Level.NetMode != NM_DedicatedServer)
		SmokeTrail = Spawn(class'FlareTrail', self);

	Velocity = speed * Dir;
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity = 0.6*Velocity;
	}

	if (Level.bDropDetail)
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	local FlareProj R;
	local int i;
	local PlayerController PC;
	
	Super.PostNetBeginPlay();

	if (FlockIndex != 0)
	{
		SetTimer(0.1, true);
		if (Flock[1] == None)
		{
			foreach DynamicActors(class'FlareProj', R)
			{
				if (R.FlockIndex == FlockIndex)
				{
					Flock[i] = R;
					if (R.Flock[0] == None)
						R.Flock[0] = self;
					else if (R.Flock[0] != self)
						R.Flock[1] = self;

					i++;
					if (i == 2)
						break;
				}
			}
		}
	}

	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (Level.bDropDetail || (Level.DetailMode == DM_Low))
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if ((Instigator != None) && (PC == Instigator.Controller))
			return;

		if ((PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000))
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated function Landed( vector HitNormal )
{
	Explode(Location, HitNormal);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ((Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget)) 
		Explode(HitLocation, vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
	PlaySound(ImpactSounds[Rand(3)],,3.5*TransientSoundVolume);
	if (EffectIsRelevant(Location, false))
	{
		Spawn(class'FlareExplosionEmitter',,,HitLocation + HitNormal*16,rotator(HitNormal));
		if ((ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer))
			Spawn(ExplosionDecal,self,,Location,rotator(-HitNormal));
	}
	
	BlowUp(HitLocation);
	Destroy(); 
}

simulated function Timer()
{
	local vector ForceDir, CurlDir;
	local float ForceMag;
	local int i;

	Velocity = default.Speed * Normal(Dir * 0.5 * default.Speed + Velocity);
	for(i = 0; i < 2; i++)
	{			
		if (Flock[i] == None)
			continue;

		ForceDir = Flock[i].Location - Location;
		ForceMag = FlockStiffness * ((2 * FlockRadius) - VSize(ForceDir));
		Acceleration = Normal(ForceDir) * Min(ForceMag, FlockMaxForce);

		CurlDir = Flock[i].Velocity Cross ForceDir;
		if (bCurl == Flock[i].bCurl)
			Acceleration += Normal(CurlDir) * FlockCurlForce;
		else
			Acceleration -= Normal(CurlDir) * FlockCurlForce;
	}
}

defaultproperties
{
     FlockRadius=12.000000
     FlockStiffness=-40.000000
     FlockMaxForce=900.000000
     FlockCurlForce=850.000000
     ImpactSounds(0)=Sound'tk_FHIWeapons.FHISnd.Explode_Generic03'
     ImpactSounds(1)=Sound'tk_FHIWeapons.FHISnd.Explode_Generic05'
     ImpactSounds(2)=Sound'tk_FHIWeapons.FHISnd.Explode_Generic09'
     Speed=2000.000000
     MaxSpeed=2500.000000
     Damage=100.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeFlareMissile'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=175
     LightSaturation=145
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.FlareMesh'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=16.000000
     DrawScale3D=(Y=0.650000,Z=0.650000)
     AmbientGlow=96
     SoundVolume=255
     SoundRadius=220.000000
     bFixedRotationDir=True
     RotationRate=(Roll=150000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}