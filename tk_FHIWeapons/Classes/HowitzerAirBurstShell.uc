class HowitzerAirBurstShell extends Projectile;

var Effects Corona;
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
			Trail = Spawn(class'HowitzerTrail', self);

		Corona = Spawn(class'RocketCorona', self);
	}

	Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ; 
	initialDir = Velocity;

	SetTimer(0.375, true);
}

function Timer()
{
	SpawnEffects(Location, vect(0,0,1));
	Explode(Location, vect(0,0,1));
}

simulated function destroyed()
{
	if (Trail != None) 
		Trail.mRegen = False;

	if (Corona != None)
		Corona.Destroy();

	Super.Destroyed();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if (Other != Instigator)
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity));
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'tk_FHIWeapons.FHISnd.Explode_Generic11',,1.5*TransientSoundVolume);
	if (EffectIsRelevant(Location, false))
	{
		PC = Level.GetLocalPlayerController();
		if ((PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000)
			spawn(class'NewExplosionC',,,HitLocation + HitNormal*16);

		Spawn(class'HowitzerBombFlashExplosion',,,HitLocation + HitNormal*16);
		Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
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

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
	local rotator rot;
	local int i;
	local HowitzerBomb NewChunk;

	start = Location + 10 * HitNormal;
	if (Role == ROLE_Authority)
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for(i = 0; i < 6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewChunk = Spawn(class 'HowitzerBomb',, '', Start, rot);
		}
	}
	Destroy();
}

defaultproperties
{
     Speed=13200.000000
     MaxSpeed=15200.000000
     TossZ=825.000000
     Damage=100.000000
     DamageRadius=500.000000
     MomentumTransfer=175000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeHowitzerAirBurst'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'PC_NewFX.PC_SniperBullet'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     AmbientSound=Sound'tk_FHIWeapons.FHISnd.Ambient_HowitzerProjB'
     LifeSpan=6.000000
     DrawScale=7.000000
     AmbientGlow=100
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}