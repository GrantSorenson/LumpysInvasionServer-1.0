class PistolProj extends Projectile;

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

    Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) ) 
		Explode(HitLocation,Vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
    if ( EffectIsRelevant(Location,false) )
    {
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    	Spawn(class'XEffects.ExploWallHit',,,HitLocation + HitNormal*20,rotator(HitNormal));
    }
	
	BlowUp(HitLocation);
	Destroy(); 
}

defaultproperties
{
     DamageAtten=1.000000
     Speed=100000.000000
     MaxSpeed=100000.000000
     Damage=95.000000
     DamageRadius=155.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypePistolAlt'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     LifeSpan=5.000000
     DrawScale=1.500000
     AmbientGlow=254
     Style=STY_Alpha
}
