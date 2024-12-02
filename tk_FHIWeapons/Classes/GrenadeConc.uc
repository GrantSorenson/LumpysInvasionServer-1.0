class GrenadeConc extends Projectile;

var() vector ShakeRotMag;	// how far to rot view
var() vector ShakeRotRate;	// how fast to rot view
var() float  ShakeRotTime;	// how much time to rot the instigator's view
var() vector ShakeOffsetMag;	// max view offset vertically
var() vector ShakeOffsetRate;	// how fast to offset view vertically
var() float  ShakeOffsetTime;	// how much time to offset view

var float ExplodeTimer, LastSparkTime;
var bool bTimerSet, bExploded, bCanHitOwner, bHitWater;

var Effects Corona;
var xEmitter Trail;
var class<xEmitter> HitEffectClass;
var() float DampenFactor, DampenFactorParallel;

replication
{
	reliable if (Role == ROLE_Authority)
		ExplodeTimer;
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.mRegen = false;

	if (Corona != None)
		Corona.Destroy();

	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (Level.NetMode != NM_DedicatedServer) 
	{
		Trail = Spawn(class'GrenadeTrailConc', self,, Location, Rotation);
		Corona = Spawn(class'GrenadeConcCorona', self); 
	}

	if (Role == ROLE_Authority)
	{
		Velocity = Speed * Vector(Rotation);
		RandSpin(25000);
	}

	if (Instigator != None)
		InstigatorController = Instigator.Controller;
}

simulated function PostNetBeginPlay()
{
	if (Physics == PHYS_None)
	{
		SetTimer(ExplodeTimer, false); 
		bTimerSet = true;
	}
}

event bool EncroachingOn( actor Other )
{
	if (Other.bWorldGeometry)
		return true;

	return false;
}

simulated function Timer()
{
	Explode(Location, vect(0,0,1));
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if (Other != instigator) 
		Explode(HitLocation, vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
		BlowUp(HitLocation);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	local Vector VNorm;

	if (!bTimerSet)
	{
		SetTimer(ExplodeTimer, false);
		bTimerSet = true;
	}

	// Reflect off Wall w/damping
	VNorm = (Velocity dot HitNormal) * HitNormal;
	Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

	RandSpin(100000);
	Speed = VSize(Velocity);

	if (Speed < 20) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
		if (Trail != None)
			Trail.mRegen = false;
	}
	else
	{
		if ((Level.NetMode != NM_DedicatedServer) && (Speed > 250))
			PlaySound(ImpactSound, SLOT_Misc);

		if (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location, false))
		{
			Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
			LastSparkTime = Level.TimeSeconds;
		}
	}
}

simulated function BlowUp(vector HitLocation)
{
	Spawn(class'GrenadeConcExplosionNEW',,, HitLocation - 100 * Normal(Velocity), Rot(0,16384,0));
	MakeNoise(1.0);
	SetPhysics(PHYS_None);
	bHidden = true;
	GotoState('Dying');
}

state Dying
{
	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
	{}

	function BeginState()
	{
		bHidden = true;
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		if (!bExploded)
		{
			ShakeView();
		}
		InitialState = 'Dying';
		if (Trail != None)
			Trail.Destroy();
	}

	function ShakeView()
	{
		local Controller C;
		local PlayerController PC;
		local float Dist, Scale;

		for(C = Level.ControllerList; C != None; C = C.NextController)
		{
			PC = PlayerController(C);
			if (PC != None && PC.ViewTarget != None)
			{
				Dist = VSize(Location - PC.ViewTarget.Location);
				if (Dist < DamageRadius * 2.0)
				{
					if (Dist < DamageRadius)
						Scale = 1.0;
					else
						Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
					C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
				}
			}
		}
	}

Begin:
	PlaySound(sound'tk_FHIWeapons.FHISnd.Explode_GrenadeConc');
	HurtRadius(Damage, DamageRadius*0.675, MyDamageType, MomentumTransfer, Location);
	Sleep(0.2);
	HurtRadius(Damage, DamageRadius*0.850, MyDamageType, MomentumTransfer, Location);
	Sleep(0.2);
	Destroy();
}

defaultproperties
{
     ShakeRotMag=(Z=90.000000)
     ShakeRotRate=(Z=750.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(Z=5.000000)
     ShakeOffsetRate=(Z=175.000000)
     ShakeOffsetTime=6.000000
     ExplodeTimer=0.750000
     DampenFactor=0.500000
     DampenFactorParallel=0.800000
     HitEffectClass=Class'XEffects.WallSparks'
     Speed=2000.000000
     TossZ=0.000000
     Damage=95.000000
     DamageRadius=575.000000
     MomentumTransfer=175000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeGrenadeConc'
     ImpactSound=ProceduralSound'WeaponSounds.PGrenFloor1.P1GrenFloor1'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.GrenadeMiniMesh'
     bNetTemporary=False
     Physics=PHYS_Falling
     DrawScale=0.750000
     TransientSoundVolume=0.750000
     TransientSoundRadius=1000.000000
     CollisionRadius=12.000000
     CollisionHeight=12.000000
     bBounce=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}