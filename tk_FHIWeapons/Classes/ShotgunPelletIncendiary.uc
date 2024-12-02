class ShotgunPelletIncendiary extends Projectile;

var float DamageAtten;
var vector Dir;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        DamageAtten;
}

simulated function PostBeginPlay()
{
    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    SetRotation(RotRand());

	SetTimer(0.1,true);

    Super.PostBeginPlay();
}

function Timer()
{
	Explode(Location, vect(0,0,1));
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	PlaySound (Sound'tk_FHIWeapons.FHISnd.Explode_Generic13',,1.0*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		spawn(class'tk_FHIWeapons.ShotgunExplodeIncendiary',,,HitLocation + HitNormal*16 );
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

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local ShotgunParticleIncendiary NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<2; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-26000;
			rot.pitch += FRand()*32000-24000;
			rot.roll += FRand()*32000-26000;
			NewChunk = Spawn( class 'ShotgunParticleIncendiary',, '', Start, rot);
		}
	}

    if ( EffectIsRelevant(Location,false) )
    {
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }
    Destroy();
}

defaultproperties
{
     DamageAtten=1.000000
     Speed=10000.000000
     MaxSpeed=10000.000000
     Damage=15.000000
     DamageRadius=35.000000
     MomentumTransfer=5500.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeShotgunIncendiary'
     ExplosionDecal=Class'tk_FHIWeapons.ShotgunImpactScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     LifeSpan=1.000000
     DrawScale=2.500000
     AmbientGlow=254
     Style=STY_Alpha
     TransientSoundVolume=0.500000
     TransientSoundRadius=50.000000
}
