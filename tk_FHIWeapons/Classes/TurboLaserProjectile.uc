class TurboLaserProjectile extends Projectile;

var() Sound ComboSound;
var() float ComboDamage;
var() float ComboRadius;
var() float ComboMomentumTransfer;
var xEmitter FlareTrail;
var xEmitter SparkleTrail;
var() int ComboAmmoCost;

var class<DamageType> ComboDamageType;

var Pawn ComboTarget;		// for AI use

var Vector tempStartLoc;

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( Pawn(Owner) != None )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
		   FlareTrail = Spawn(class'TurboProjElec', self);
		SparkleTrail = Spawn(class'TurboProjSparkles', self);
	}

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);
    tempStartLoc = Location;

	if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	
	Super.PostNetBeginPlay();
	
	if ( Level.NetMode == NM_DedicatedServer )
		return;
		
	PC = Level.GetLocalPlayerController();
	if ( (Instigator != None) && (PC == Instigator.Controller) )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

function Timer()
{
    SetCollisionSize(20, 20);
}

simulated function Destroyed()
{
    if (FlareTrail != None)
    {
        FlareTrail.mRegen = false;
    }
    if (SparkleTrail != None)
    {
        SparkleTrail.mStartParticles = 12;
        SparkleTrail.mLifeRange[0] *= 2.0;
        SparkleTrail.mLifeRange[1] *= 2.0;
        SparkleTrail.mRegen = false;
    }
	Super.Destroyed();
}

simulated function DestroyTrails()
{
    if (FlareTrail != None)
        FlareTrail.Destroy();
    if (SparkleTrail != None)
        SparkleTrail.Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

	if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        DestroyTrails();
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
		Explode(HitLocation, Normal(HitLocation-Other.Location));
		if ( TurboLaserProjectile(Other) != None )
			TurboLaserProjectile(Other).Explode(HitLocation,Normal(Other.Location - HitLocation));
    }
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }

   	PlaySound(ImpactSound, SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
	    Spawn(class'TurboAltExplosion',,, Location);//,rotator(Velocity));		

    SetCollisionSize(0.0, 0.0);
	Destroy();
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    if (DamageType == ComboDamageType)
    {
        Instigator = EventInstigator;
        SuperExplosion();
        if( EventInstigator.Weapon != None )
        {
			EventInstigator.Weapon.ConsumeAmmo(0, ComboAmmoCost, true);
            Instigator = EventInstigator;
        }
    }
}

function SuperExplosion()
{
	local actor HitActor;
	local vector HitLocation, HitNormal;
	
	HurtRadius(ComboDamage, ComboRadius, class'DamTypeTLCombo', ComboMomentumTransfer, Location );

	Spawn(class'TLCombo');
	if ( (Level.NetMode != NM_DedicatedServer) && EffectIsRelevant(Location,false) )
	{
		HitActor = Trace(HitLocation, HitNormal,Location - Vect(0,0,120), Location,false);
		if ( HitActor != None )
			Spawn(class'ComboDecal',self,,HitLocation, rotator(vect(0,0,-1)));
	}
	PlaySound(ComboSound, SLOT_None,1.0,,800);
    DestroyTrails();
    Destroy();
}

function Monitor(Pawn P)
{
	ComboTarget = P;

	if ( ComboTarget != None )
		GotoState('WaitForCombo');
}

State WaitForCombo
{
	function Tick(float DeltaTime)
	{
		if ( (ComboTarget == None) || ComboTarget.bDeleteMe
			|| (Instigator == None) || (TurboLaser(Instigator.Weapon) == None) )
		{
			GotoState('');
			return;
		}

		if ( (VSize(ComboTarget.Location - Location) <= 0.5 * ComboRadius + ComboTarget.CollisionRadius) 
			|| ((Velocity Dot (ComboTarget.Location - Location)) <= 0) )
		{
			TurboLaser(Instigator.Weapon).DoCombo();
			GotoState('');
			return;
		}
	}
}

defaultproperties
{
     ComboSound=Sound'tk_FHIWeapons.FHISnd.TurboLaser_Combo'
     ComboDamage=300.000000
     ComboRadius=410.000000
     ComboMomentumTransfer=150000.000000
     ComboAmmoCost=2
     ComboDamageType=Class'tk_FHIWeapons.DamTypeTurboBeam'
     Speed=1450.000000
     MaxSpeed=1450.000000
     bSwitchToZeroCollision=True
     Damage=57.000000
     DamageRadius=95.000000
     MomentumTransfer=5000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeTurboPlasma'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.ShockAltDecal'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=32
     LightSaturation=75
     LightBrightness=255.000000
     LightRadius=3.500000
     DrawType=DT_Sprite
     bDynamicLight=True
     bNetTemporary=False
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=10.000000
     Texture=Texture'tk_FHIWeapons.FHITex.Flare_H'
     DrawScale=0.450000
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=15.000000
     CollisionHeight=15.000000
     bProjTarget=True
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
