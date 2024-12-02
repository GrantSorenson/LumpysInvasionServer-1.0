class RailBomb extends Projectile;

var xEmitter Trail;
var Effects Corona;
var vector initialDir;

simulated function Destroyed() 
{
	if ( Trail != None )
		Trail.mRegen = False;
	if ( Corona != None )
		Corona.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	local Rotator R;

	if ( Level.NetMode != NM_DedicatedServer)
	{
		Trail = Spawn(class'RailBombTrailEffect',self);
		Corona = Spawn(class'RailBombCorona',self); 
	}

	Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ; 
	initialDir = Velocity;

    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;

    if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if ( (Instigator != None) && (PC == Instigator.Controller) )
			return;
		if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	PlaySound (Sound'tk_FHIWeapons.FHISnd.Phoenix_AltFire',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		spawn(class'RailBombAltExplosionNEW',,,HitLocation + HitNormal*16 );
//		spawn(class'RailgunExpFlare',,,HitLocation + HitNormal*16 );
//		spawn(class'RailgunFlashExplosion',,,HitLocation + HitNormal*16 );
//		spawn(class'RailgunParticleRing',,,HitLocation + HitNormal*16, rotator(HitNormal) );
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
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
    local RailgunParticle NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<10; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-26000;
			rot.pitch += FRand()*32000-24000;
			rot.roll += FRand()*32000-26000;
			NewChunk = Spawn( class 'RailgunParticle',, '', Start, rot);
		}
	}
    Destroy();
}

defaultproperties
{
     Speed=1950.000000
     TossZ=10.000000
     Damage=85.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeRailBomb'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=210
     LightSaturation=35
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.RailAltMesh'
     bDynamicLight=True
     AmbientSound=Sound'tk_FHIWeapons.FHISnd.LaserAmbient4'
     LifeSpan=9.000000
     DrawScale=4.000000
     AmbientGlow=100
     SoundVolume=255
     SoundRadius=170.000000
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
