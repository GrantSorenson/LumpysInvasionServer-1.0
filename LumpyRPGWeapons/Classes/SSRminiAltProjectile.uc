//========================================================================
// SSRminiAltProjectile
//========================================================================

class SSRminiAltProjectile extends Projectile;

var byte ReflectMaxNum, ReflectNum;
var float DampeningFactor, NewDamage;
var Emitter ShockBallEffect;
var() class<Emitter> ShockBallClass;
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
        ShockBallEffect = Spawn(class'SSRminiProjBall', self);
        ShockBallEffect.SetBase(self);
	}

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);
    tempStartLoc = Location;
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
    if (ShockBallEffect != None)
    {
		if ( bNoFX )
			ShockBallEffect.Destroy();
		else
			ShockBallEffect.Kill();
	}

	Super.Destroyed();
}

simulated function DestroyTrails()
{
    if (ShockBallEffect != None)
        ShockBallEffect.Destroy();
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
		if ( SSRminiAltProjectile(Other) != None )
			SSRminiAltProjectile(Other).Explode(HitLocation,Normal(Other.Location - HitLocation));
    }
}
simulated function HitWall( vector HitNormal, actor Wall )
{
             ReflectMaxNum=15;

    if ( !Wall.bStatic && !Wall.bWorldGeometry && ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
	    	SetNewDamage();
            if ( Instigator == None || Instigator.Controller == None )
            {
		  		Wall.SetDelayedDamageInstigatorController( InstigatorController );
			}
            Wall.TakeDamage( NewDamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        DestroyProjectile();
        return;
    }

    DoImpactEffects(HitNormal);
    if (ReflectNum < ReflectMaxNum)
    {
        BounceProjectile(HitNormal);
        return;
    }
    DestroyProjectile();
}

Simulated Function BounceProjectile(vector HitNormal)
{
    Const V_Absorbed = 0.80;
    local float V_Returned;

    V_Returned = 1 - V_Absorbed;

    Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));
    Acceleration = Normal(Velocity) * 1500.0;
    ReflectNum++;
}

Simulated Function DoImpactEffects(vector HitNormal)
{
    SetNewDamage();
    if ( Role == ROLE_Authority )
    {
		HurtRadius(NewDamage, DamageRadius, MyDamageType, MomentumTransfer, Location );
	}
    PlaySound(ImpactSound, SLOT_Misc);
}


simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }

   	PlaySound(ImpactSound, SLOT_Misc);

    SetCollisionSize(0.0, 0.0);
    SetNewDamage();
	DoImpactEffects(HitNormal);
    DestroyProjectile();
	Destroy();
}

simulated function SetNewDamage()
{
    NewDamage = Damage * ( (1-DampeningFactor) ** float(ReflectNum) );

}

Simulated Function DestroyProjectile()
{
    SetCollisionSize(0.0, 0.0);
    Destroy();
}

defaultproperties
{
     Speed=1150.000000
     MaxSpeed=1150.000000
     bSwitchToZeroCollision=False
     Damage=45.000000
     DamageRadius=150.000000
     MomentumTransfer=70000.000000
     ShockBallClass=class'SSRMiniProjBall'
     MyDamageType=Class'XWeapons.DamTypeShockBall'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'XEffects.ShockImpactScorch'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=195
     LightSaturation=85
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bNetTemporary=False
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=15.000000
     //Texture=Texture'SSRminiBallProj2.SSRminiBall2.SSRminiLiquidCore1'
     Texture=Texture'XEffectMat.Shock.shock_core_low'
     DrawScale=0.700000
     //Skins(0)=Texture'SSRminiBallProj2.SSRminiBall2.SSRminiLiquidCore1'
     Skins(0)=Texture'XEffectMat.Shock.shock_core_low'
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=8.000000
     SoundVolume=50
     SoundRadius=100.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
