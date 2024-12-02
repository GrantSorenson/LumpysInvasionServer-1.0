class HowitzerBomb extends Projectile;

var xEmitter Trail;
var vector initialDir;

simulated function PostBeginPlay()
{
	local Rotator R;
	local PlayerController PC;
	
	if (!PhysicsVolume.bWaterVolume && (Level.NetMode != NM_DedicatedServer))
	{
		PC = Level.GetLocalPlayerController();
		if ((PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000)
			Trail = Spawn(class'FlakShellTrail', self);
	}

	Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;
	R = Rotation;
	R.Roll = Rand(65536);
	R.Yaw = Rand(65536);
	R.Pitch = Rand(65536);
	SetRotation(R);
	initialDir = Velocity;
}

simulated function destroyed()
{
	if (Trail != None) 
		Trail.mRegen = False;
	Super.Destroyed();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if (Other != Instigator)
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity));
		Explode(HitLocation, Normal(HitLocation - Other.Location));
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound(Sound'tk_FHIWeapons.FHISnd.Explode_Generic12',,2*TransientSoundVolume);
	if (EffectIsRelevant(Location, false))
	{
		PC = Level.GetLocalPlayerController();
		if ((PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000)
			Spawn(class'HowitzerBombExplosion',,,HitLocation + HitNormal*16);

		if ((ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer))
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects(Location, HitNormal);
	Explode(Location, HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     Speed=500.000000
     Damage=120.000000
     DamageRadius=275.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeHowitzerBomb'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.GrenadeMiniMesh'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     LifeSpan=6.000000
     DrawScale=1.150000
     AmbientGlow=100
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
     bFixedRotationDir=True
     RotationRate=(Pitch=80000,Yaw=80000,Roll=80000)
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}