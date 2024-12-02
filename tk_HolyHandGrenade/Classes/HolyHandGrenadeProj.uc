class HolyHandGrenadeProj extends Projectile;

var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view
var bool bExploded;
var float ExplodeTimer;
var() float DampenFactor, DampenFactorParallel;
var bool bTimerSet;
var bool bHitWater, bInstantExplode, bIsUnholy;
var texture UnholyTexture;

replication
{
    reliable if (Role==ROLE_Authority)
        ExplodeTimer;
}

simulated function PostBeginPlay()
{
    if ( bDeleteMe || IsInState('Dying') )
    return;
    if ( Role == ROLE_Authority )
    {
        Velocity = Speed * Vector(Rotation);
        RandSpin(25000);
        if (Instigator.HeadVolume.bWaterVolume)
        {
            bHitWater = true;
            Velocity = 0.6*Velocity;
        }
    }
    if ( Instigator != None )
    	InstigatorController = Instigator.Controller;
    if(bIsUnholy)
        Skins[0] = UnholyTexture;
}

simulated function PostNetBeginPlay()
{
	if ( Physics == PHYS_None )
    {
        SetTimer(ExplodeTimer, false);
        bTimerSet = true;
    }
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
}

simulated function Timer()
{
    Explode(Location, vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	PlayExplosionSounds();
	BlowUp(HitLocation);
}

simulated function Landed( vector HitNormal )
{
    HitWall( HitNormal, None );
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;

    if(bInstantExplode)
    {
        BlowUp(Location);
        return;
    }
    // Reflect off Wall w/damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    Speed = VSize(Velocity);

    if ( Speed < 20 )
    {
        bBounce = False;
        SetPhysics(PHYS_None);
        SetTimer(ExplodeTimer, false);
    }
    else if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
	PlaySound(ImpactSound, SLOT_Misc,,,,,true);
}

function BlowUp(vector HitLocation)
{
    if(bIsUnholy)
        Spawn(Class'XEffects.NewIonEffect',,, HitLocation - 100 * Normal(Velocity), Rot(0,16384,0));
    else
        Spawn(class'RedeemerExplosion',,, HitLocation - 100 * Normal(Velocity), Rot(0,16384,0));
	MakeNoise(1.0);
	PlaySound(sound'WeaponSounds.redeemer_explosionsound',SLOT_Ambient);
	SetPhysics(PHYS_None);
	bHidden = true;
    GotoState('Dying');
}

function PlayExplosionSounds()
{
	local PlaySoundActor PSA;

	PSA = Spawn(class'PlaySoundActor',,, Location, Rotation);
	PSA.Play(sound'WeaponSounds.redeemer_explosionsound', 0.8);

	if(bIsUnholy){}
		//PlaySound(Sound'tk_HolyHandGrenade.UnholyBlowup',,,true);
	else{}
		//PlaySound(sound'tk_HolyHandGrenade.Hallelujah',,,true);
}

state Dying
{
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType) {}

    function BeginState()
    {
		bHidden = true;
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		if ( !bExploded )
		{
			Spawn(class'IonCore',,, Location, Rotation);
			ShakeView();
		}
		InitialState = 'Dying';
    }

    function ShakeView()
    {
        local Controller C;
        local PlayerController PC;
        local float Dist, Scale;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            PC = PlayerController(C);
            if ( PC != None && PC.ViewTarget != None )
            {
                Dist = VSize(Location - PC.ViewTarget.Location);
                if ( Dist < DamageRadius * 2.0)
                {
                    if (Dist < DamageRadius)
                        Scale = 1.0;
                    else
                        Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                    C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }
    }

Begin:


    HurtRadius(Damage, DamageRadius*0.125, MyDamageType, MomentumTransfer, Location);
    Sleep(0.5);
    HurtRadius(Damage, DamageRadius*0.300, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.475, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.650, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.825, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*1.000, MyDamageType, MomentumTransfer, Location);
    Destroy();
}

defaultproperties
{
     ShakeRotMag=(Z=250.000000)
     ShakeRotRate=(Z=2500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(Z=10.000000)
     ShakeOffsetRate=(Z=200.000000)
     ShakeOffsetTime=10.000000
     ExplodeTimer=1.500000
     DampenFactor=0.500000
     DampenFactorParallel=0.800000
     UnholyTexture=Texture'tk_HolyHandGrenade.UnholyGrenade'
     Speed=1000.000000
     MaxSpeed=1000.000000
     TossZ=0.000000
     Damage=250.000000
     DamageRadius=2000.000000
     MomentumTransfer=200000.000000
     MyDamageType=Class'tk_HolyHandGrenade.DamTypeHolyHandGrenade'
     ImpactSound=ProceduralSound'WeaponSounds.PGrenFloor1.P1GrenFloor1'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=6.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_HolyHandGrenade.HolyHandGrenadeProjMesh'
     bDynamicLight=True
     bNetTemporary=False
     Physics=PHYS_Falling
     LifeSpan=0.000000
     DrawScale=0.600000
     AmbientGlow=64
     bUnlit=False
     SoundVolume=255
     SoundRadius=100.000000
     TransientSoundVolume=1.000000
     CollisionRadius=24.000000
     CollisionHeight=12.000000
     bBounce=True
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_DragAlong
     ForceRadius=100.000000
     ForceScale=5.000000
}
