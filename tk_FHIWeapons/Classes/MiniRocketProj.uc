class MiniRocketProj extends Projectile;

var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;
var xEmitter SmokeTrail;
var Effects Corona;
var byte FlockIndex;
var MiniRocketProj Flock[6];

var() float	FlockRadius;
var() float	FlockStiffness;
var() float FlockMaxForce;
var() float	FlockCurlForce;
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

	if (Corona != None)
		Corona.Destroy();

	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'MiniRocketTrail', self);
		Corona = Spawn(class'MiniRocketCorona', self); 
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

simulated function PostNetBeginPlay()
{
	local MiniRocketProj R;
	local int i;
	local PlayerController PC;

	Super.PostNetBeginPlay();
	if (FlockIndex != 0)
	{
		SetTimer(0.1, true);
		if (Flock[6] == None)
		{
			foreach DynamicActors(class'MiniRocketProj', R)
			{
				if (R.FlockIndex == FlockIndex)
				{
					Flock[i] = R;
					if (R.Flock[0] == None)
						R.Flock[0] = self;
					else if (R.Flock[0] != self)
						R.Flock[1] = self;

					if (i == 6)
						break;
					i++;
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
	PlaySound(ImpactSounds[Rand(3)],,3.5*TransientSoundVolume);
	if (EffectIsRelevant(Location, false))
	{
		Spawn(class'MiniRocketExplosion',,,HitLocation + HitNormal*16,rotator(HitNormal));	
		if ((ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer))
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	}

	BlowUp(HitLocation);
	Destroy(); 
}

simulated function Timer()
{
	local vector ForceDir, CurlDir;
	local float ForceMag;
	local int i;
		
	Velocity =  Default.Speed * Normal(Dir * 0.5 * Default.Speed + Velocity);
	for(i = 0; i < 6; i++)
	{			
		if (Flock[i] == None)
			continue;
	
		ForceDir = Flock[i].Location - Location;
		ForceMag = FlockStiffness * ((2 * FlockRadius) - VSize(ForceDir));
		Acceleration = Normal(ForceDir) * Min(ForceMag, FlockMaxForce);
		
		// Vector 'curl'
		CurlDir = Flock[i].Velocity Cross ForceDir;
		if (bCurl == Flock[i].bCurl)
			Acceleration += Normal(CurlDir) * FlockCurlForce;
		else
			Acceleration -= Normal(CurlDir) * FlockCurlForce;
	}
}

defaultproperties
{
     FlockRadius=28.000000
     FlockStiffness=-20.000000
     FlockMaxForce=800.000000
     FlockCurlForce=600.000000
     ImpactSounds(0)=Sound'tk_FHIWeapons.FHISnd.Explode_Generic01'
     ImpactSounds(1)=Sound'tk_FHIWeapons.FHISnd.Explode_Generic06'
     ImpactSounds(2)=Sound'tk_FHIWeapons.FHISnd.Explode_Generic08'
     Speed=2350.000000
     MaxSpeed=2900.000000
     Damage=68.000000
     DamageRadius=175.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeMiniRocket'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.MiniRocketMesh'
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=22.000000
     DrawScale=0.850000
     AmbientGlow=96
     SoundVolume=200
     SoundRadius=175.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}