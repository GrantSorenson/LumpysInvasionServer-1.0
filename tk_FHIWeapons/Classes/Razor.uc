class Razor extends Projectile;

var	xEmitter	Trail;
var	xEmitter	TrailB;
var	byte		Bounces;
var	float		DamageAtten;
var	bool		bCanHitOwner;
var	float		LastSparkTime;
var	class<xEmitter>	HitEffectClass;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function Destroyed()
{
    if (Trail !=None) Trail.mRegen=False;
    if (TrailB != None) TrailB.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(class'RazorTrail',self);
            Trail.Lifespan = Lifespan;
            TrailB = Spawn(class'RazorTrailB',self);
        }
            
    }

    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();
    if (r > 0.5)
        Bounces = 5;
    else if (r > 0.25)
        Bounces = 3;
    else
        Bounces = 2;

    Super.PostBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (Razor(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )

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
    HitWall( HitNormal, None );
    SetPhysics(PHYS_None);
    LifeSpan = 1.0;
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
    {
        if ( Level.NetMode != NM_Client )
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 5) )
			PlaySound(ImpactSound, SLOT_Misc );
        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
			Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
            LastSparkTime = Level.TimeSeconds;
        }
    }

        Destroy();
        return;
    }

    SetPhysics(PHYS_Falling);
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

    if (TrailB != None) 
    {
        TrailB.mRegen=False;
        TrailB.SetPhysics(PHYS_None);
    }
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
    if (Volume.bWaterVolume)
    {
        if ( Trail != None )
            Trail.mRegen=False;
        if ( TrailB != None )
            TrailB.mRegen=False;
        Velocity *= 0.65;
    }
}

defaultproperties
{
     Bounces=5
     DamageAtten=5.000000
     HitEffectClass=Class'XEffects.WallSparks'
     Speed=2750.000000
     MaxSpeed=2900.000000
     Damage=35.000000
     MomentumTransfer=7500.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeRazor'
     ImpactSound=Sound'tk_FHIWeapons.FHISnd.Impact_Razor'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.RazorDisc'
     AmbientSound=Sound'tk_FHIWeapons.FHISnd.Ambient_RazorHum'
     LifeSpan=10.000000
     DrawScale=0.750000
     AmbientGlow=254
     Style=STY_Alpha
     SoundVolume=100
     SoundRadius=150.000000
     bBounce=True
}
