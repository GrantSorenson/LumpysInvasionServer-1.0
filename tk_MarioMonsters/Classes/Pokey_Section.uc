class Pokey_Section extends MM_Projectile placeable;

var() class<Emitter> HitEffectClass;
var() float LastSparkTime;
var() float SpinRate;
var() float DampenFactor, DampenFactorParallel;
var() bool bCanHitOwner;
var() float InitialSpinRate;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();
    if ( Level.NetMode != NM_DedicatedServer && TrailClass != None )
    {
        Trail = Spawn(TrailClass, self);
        Trail.SetBase(self);
	}

    if ( Role == ROLE_Authority )
    {
        Velocity = Speed * Vector(Rotation);
        //RandSpin(InitialSpinRate);
        bCanHitOwner = false;
        if (Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.6*Velocity;
        }
    }
}

simulated function Landed( vector HitNormal )
{
    HitWall( HitNormal, None );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
    if (Other == Instigator) return;
    if (Other == Owner) return;

    if ( Other.bProjTarget )
    {
        if ( Role == ROLE_Authority )
        {
            Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		}
    }
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    PlaySound(ImpactSound, SLOT_Misc);
    SetCollisionSize(0.0, 0.0);
    Destroy();
}

simulated function Destroyed()
{
    Spawn(ExplosionClass,,, Location);
	Super.Destroyed();
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;
    local PlayerController PC;

    if ( (Pawn(Wall) != None) || (GameObjective(Wall) != None) )
    {
        Explode(Location, HitNormal);
        return;
    }

    // Reflect off Wall w/damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    DesiredRotation.Roll = 0;
    RotationRate.Roll = 0;
    Speed = VSize(Velocity);

    if ( Speed < 20 )
    {
        bBounce = False;
        PrePivot.Z = -1.5;
            SetPhysics(PHYS_None);
        DesiredRotation = Rotation;
        DesiredRotation.Roll = 0;
        DesiredRotation.Pitch = 0;
        SetRotation(DesiredRotation);
    }
    else
    {
        if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
            PlaySound(ImpactSound, SLOT_Misc );
        else
        {
            bFixedRotationDir = false;
            bRotateToDesired = true;
            DesiredRotation.Pitch = 0;
            RotationRate.Pitch = 50000;
        }
        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
            PC = Level.GetLocalPlayerController();
            if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000 )
                Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
            LastSparkTime = Level.TimeSeconds;
        }
    }
}

simulated function Timer()
{
}

defaultproperties
{
     HitEffectClass=Class'tk_MarioMonsters.Pokey_HitEffect'
     spinRate=100000.000000
     DampenFactor=0.850000
     DampenFactorParallel=0.950000
     InitialSpinRate=15000.000000
     ExplosionClass=Class'tk_MarioMonsters.Pokey_HitEffect'
     Speed=800.000000
     MaxSpeed=900.000000
     Damage=10.000000
     DamageRadius=20.000000
     MomentumTransfer=1000.000000
     MyDamageType=Class'tk_MarioMonsters.DamType_Pokey_Section'
     ImpactSound=Sound'tk_MarioMonsters.FootSteps.MMFootStepSand1'
     LightEffect=LE_QuadraticNonIncidence
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_MarioMonsters.MarioMonsters.Pokey_Section'
     CullDistance=2000.000000
     Physics=PHYS_Falling
     LifeSpan=4.000000
     DrawScale=1.750000
     DrawScale3D=(X=-1.000000)
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Pokey_skin'
     AmbientGlow=80
     FluidSurfaceShootStrengthMod=3.000000
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=30.000000
     CollisionHeight=30.000000
     bProjTarget=True
     bBounce=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
