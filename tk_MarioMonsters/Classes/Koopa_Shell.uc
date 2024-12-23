class Koopa_Shell extends MM_Projectile placeable;

var() bool bIdle;
var() class<Emitter> HitEffectClass;
var() float LastSparkTime;
var() float SpinRate;
var() float DampenFactor, DampenFactorParallel;
var() bool bCanHitOwner;

/*replication
{
	reliable if(Role == Role_Authority)
		bIdle;
}*/

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();
    if ( Level.NetMode != NM_DedicatedServer && TrailClass != None )
    {
        Trail = Spawn(TrailClass, self);
        Trail.SetBase(self);
	}

	if (Role == ROLE_Authority)
	{
	    Velocity = (Vector(Rotation) * Speed) * -1;
	    RotationRate.Yaw = SpinRate;
	    //Velocity.Z += TossZ;
    }
}

simulated function Landed( vector HitNormal )
{
	if (Role == ROLE_Authority)
	{
		if(bIdle)
		{
			SetPhysics(PHYS_None);
		}
	}
}

/*simulated function Explode(vector HitLocation,vector HitNormal)
{
    PlaySound(ImpactSound, SLOT_Misc);
    SetCollisionSize(0.0, 0.0);
    Destroy();
}*/

simulated function Destroyed()
{
    Spawn(ExplosionClass,,, Location);
	Super.Destroyed();
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	//if (Role == ROLE_Authority)
	//{
		//log("process touch");
		/*if(bIdle && !Other.bWorldGeometry && (Pawn(Other) != None || Other.bProjTarget))
		{
			log("phase 1");
			bIdle = false;
			SetPhysics(PHYS_Falling);
			if(Pawn(Other) != None && Instigator == None)
			{
				log("process touch instigator");
				Instigator = Pawn(Other);
			}
			//if ( Role == ROLE_Authority)
			//{
			//if (Role == ROLE_Authority)
			//{


				RotationRate.Yaw = SpinRate;

				Velocity = (Normal(Other.Location-HitLocation) * Speed) * -1 ;
				Velocity.Z = 0;

				log("touched by "@Other);
				log("Velocity="@Velocity);
			//}
			//}
			if ( Level.NetMode != NM_DedicatedServer)
			{
				PlaySound(Sound'tk_MarioMonsters.Koopa.KoopalingShellSlide1', SLOT_Misc);
			}

			return;
		}*/

		if (!Other.bWorldGeometry && (Other != Instigator || bCanHitOwner) )
		{
			//Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
			//PlaySound(ImpactSound, SLOT_Misc);
			Explode(HitLocation, Normal(HitLocation-Other.Location));
		}
	//}
}

simulated function Timer()
{
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;
    local PlayerController PC;

   /* if ( (Pawn(Wall) != None) || (GameObjective(Wall) != None) )
    {
        Explode(Location, HitNormal);
        return;
    }*/
	//log("hitwall");
   /* if(bIdle)
	{
		log("wall phase 1");
		SetPhysics(PHYS_None);
		return;
	}*/

	bCanHitOwner = true;
    // Reflect off Wall w/damping
   //if (Role == ROLE_Authority)
    //{
    	VNorm = (Velocity dot HitNormal) * HitNormal;
    	Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
    	Speed = VSize(Velocity);
	//}

    if ( Speed < 20 )
    {
        //if ( Trail != None )
           // Trail.mRegen = false; // stop the emitter from regenerating
           SoundVolume=0;
    }
    else
    {
		SetPhysics(PHYS_Falling);
		SoundVolume=255;
        if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
        {
            PlaySound(ImpactSound, SLOT_Misc );
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

simulated function BlowUp(vector HitLocation)
{
    DelayedHurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
    //Destroy();
}

defaultproperties
{
     bIdle=True
     HitEffectClass=Class'tk_MarioMonsters.Koopa_Shell_HitEffect'
     spinRate=100000.000000
     DampenFactor=0.990000
     DampenFactorParallel=0.990000
     TrailClass=Class'tk_MarioMonsters.Koopa_Shell_Trail'
     ExplosionClass=Class'tk_MarioMonsters.Koopa_Shell_Explosion'
     Speed=1000.000000
     MaxSpeed=1200.000000
     Damage=20.000000
     DamageRadius=10.000000
     MyDamageType=Class'tk_MarioMonsters.DamType_Koopa_Shell'
     ImpactSound=Sound'tk_MarioMonsters.Koopa.KoopalingShellLand'
     LightEffect=LE_QuadraticNonIncidence
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_MarioMonsters.MarioMonsters.Koopa_Shell'
     CullDistance=4000.000000
     bNetTemporary=False
     Physics=PHYS_Falling
     AmbientSound=Sound'tk_MarioMonsters.Koopa.shell_spin'
     LifeSpan=10.000000
     Rotation=(Yaw=32768)
     DrawScale=1.250000
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Koopa_skin'
     FluidSurfaceShootStrengthMod=3.000000
     SoundRadius=150.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bProjTarget=True
     bBounce=True
     bFixedRotationDir=True
     RotationRate=(Yaw=50000)
     DesiredRotation=(Yaw=12000)
}
