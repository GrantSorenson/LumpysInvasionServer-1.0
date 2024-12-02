class RailgunProjectile extends Projectile; 

var RailgunProjSparksNEW FlareTrail;
//var RailgunProjSparksB FlareTrailB;
var Vector tempStartLoc;

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( (Owner != None) && Owner.IsA( 'Pawn' ) )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
		   FlareTrail = Spawn(class'RailgunProjSparksNEW', self);
//		   FlareTrailB = Spawn(class'RailgunProjSparksB', self);
	}

	Velocity = Speed * Vector(Rotation);

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
		if ( (PC == None) || (Instigator == None) || (PC != Instigator.Controller) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated function Destroyed()
{
    if (FlareTrail != None)
    {
        FlareTrail.Destroy();
    }
/*
    if (FlareTrailB != None)
    {
        FlareTrailB.Destroy();
    }
*/
	Super.Destroyed();
}

function Timer()
{
    SetCollisionSize(20, 20);
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
//        DestroyTrails();
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
		Explode(HitLocation, Normal(HitLocation-Other.Location));
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
	    Spawn(class'RailExplosionNEW',,, Location);//,rotator(Velocity));		
//    	Spawn(class'RailgunSparks',,,HitLocation + HitNormal*20,rotator(HitNormal));
    SetCollisionSize(0.0, 0.0);
	Destroy();
}

defaultproperties
{
     Speed=2450.000000
     MaxSpeed=2450.000000
     bSwitchToZeroCollision=True
     Damage=40.000000
     DamageRadius=50.000000
     MomentumTransfer=5000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeRailDart'
     ImpactSound=SoundGroup'WeaponSounds.Translocator.TranslocatorFire'
     ExplosionDecal=Class'tk_FHIWeapons.RailDecal'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=210
     LightSaturation=35
     LightBrightness=255.000000
     LightRadius=3.500000
     DrawType=DT_Sprite
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     AmbientSound=Sound'tk_FHIWeapons.FHISnd.LaserAmbient5'
     LifeSpan=10.000000
     Texture=Texture'tk_FHIWeapons.FHITex.Flare_B'
     DrawScale=0.050000
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}