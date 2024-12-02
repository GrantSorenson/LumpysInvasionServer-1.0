class HowitzerShell extends Projectile;

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
}

simulated event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	SetRotation(rotator(Velocity));
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
		Explode(HitLocation, Normal(HitLocation - Other.Location));
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound(Sound'tk_FHIWeapons.FHISnd.Explode_Generic10',,1.5*TransientSoundVolume);
	if (EffectIsRelevant(Location, false))
	{
		PC = Level.GetLocalPlayerController();
		if ((PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000)
			Spawn(class'HowitzerExplosionA',,,HitLocation + HitNormal*16);

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
     Speed=15000.000000
     MaxSpeed=17500.000000
     TossZ=625.000000
     Damage=160.000000
     DamageRadius=550.000000
     MomentumTransfer=175000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeHowitzerShell'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'PC_NewFX.PC_SniperBullet'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     AmbientSound=Sound'tk_FHIWeapons.FHISnd.Ambient_HowitzerProjA'
     LifeSpan=16.000000
     DrawScale=7.000000
     AmbientGlow=100
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}