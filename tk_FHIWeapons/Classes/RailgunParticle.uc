class RailgunParticle extends Projectile;

var xEmitter Trail;
var byte Bounces;
var float DamageAtten;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function Destroyed()
{
    if (Trail !=None) Trail.mRegen=False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(class'RailgunAltTrail',self);
            Trail.Lifespan = Lifespan;
        }
            
    }

    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();
    if (r > 0.75)
        Bounces = 5;
    else if (r > 0.25)
        Bounces = 3;
    else
        Bounces = 1;

    SetRotation(RotRand());

    Super.PostBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (RailgunParticle(Other) == None) && ((Physics == PHYS_Projectile) || (Other != Instigator)) )
    {
        speed = VSize(Velocity);
        if ( speed > 200 )
        {
            if ( Role == ROLE_Authority )
                Other.TakeDamage( Max(5, Damage - DamageAtten*FMax(0,(default.LifeSpan - LifeSpan - 1))), Instigator, HitLocation,
                    (MomentumTransfer * Velocity/speed), MyDamageType );
        }
        Destroy();
    }
}

simulated function Landed( Vector HitNormal )
{
    SetPhysics(PHYS_None);
    LifeSpan = 1.0;
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
    {
        if ( Level.NetMode != NM_Client )
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
        Destroy();
        return;
    }

    SetPhysics(PHYS_Projectile);
	if (Bounces > 0)
    {
        Velocity = 0.65 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
        Bounces = Bounces - 1;
        return;
    }
	bBounce = false;
    if (Trail != None) 
    {
        Trail.mRegen=False;
        Trail.SetPhysics(PHYS_None);
    }
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
    if (Volume.bWaterVolume)
    {
        if ( Trail != None )
            Trail.mRegen=False;
        Velocity *= 0.65;
    }
}

defaultproperties
{
     Bounces=5
     DamageAtten=1.000000
     Speed=3500.000000
     MaxSpeed=3700.000000
     Damage=65.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeRailBomb'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     LifeSpan=4.700000
     DrawScale=8.000000
     Skins(0)=Shader'AW-2004Particles.Weapons.RippleFallback'
     AmbientGlow=254
     Style=STY_Alpha
     bBounce=True
}
