class HVBombProjectile extends Projectile;

var float ExplodeTimer, LastSparkTime;
var bool bTimerSet, bCanHitOwner, bHitWater;

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
		Trail.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer)
		Trail = Spawn(class'HVBombTrail', self);

	if (Role == ROLE_Authority)
	{
		Velocity = Speed * Vector(Rotation);
		RandSpin(25000);
		bCanHitOwner = false;
		if (Instigator.HeadVolume.bWaterVolume)
		{
			bHitWater = true;
			Velocity = 0.6*Velocity;
		}
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

simulated function Timer()
{
	Explode(Location, vect(0,0,1));
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if (Pawn(Other) != None && (Other != Instigator || bCanHitOwner))
		Explode(HitLocation, Normal(HitLocation-Other.Location));
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
	}
	else
	{
		if ((Level.NetMode != NM_DedicatedServer) && (Speed > 250))
			PlaySound(ImpactSound, SLOT_Misc);

		if (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false))
		{
			Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
			LastSparkTime = Level.TimeSeconds;
		}
	}
}

simulated function BlowUp(vector HitLocation)
{
	DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	if (Role == ROLE_Authority)
		MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	BlowUp(HitLocation);
	PlaySound(sound'tk_FHIWeapons.FHISnd.Explode_Generic05',,2.5*TransientSoundVolume);
	if (EffectIsRelevant(Location,false))
	{
		Spawn(class'HVBombExplosion',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(class'HVBombFlashExplosion',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
	Destroy();
}

defaultproperties
{
     ExplodeTimer=1.500000
     DampenFactor=0.500000
     DampenFactorParallel=0.800000
     HitEffectClass=Class'XEffects.WallSparks'
     Speed=1050.000000
     MaxSpeed=2750.000000
     TossZ=0.000000
     Damage=35.000000
     DamageRadius=700.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeAGBomb'
     ImpactSound=SoundGroup'tk_FHIWeapons.FHISnd.HVBombBounceSound'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'VMWeaponsSM.PlayerWeaponsGroup.VMGrenade'
     Physics=PHYS_Flying
     LifeSpan=40.000000
     DrawScale=0.100000
     AmbientGlow=100
     CollisionRadius=24.000000
     CollisionHeight=24.000000
     bBounce=True
     bFixedRotationDir=True
}