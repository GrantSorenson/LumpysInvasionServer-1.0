class SC_Projectile extends Projectile;

var()	float	FieldRadius;
var()	float	PainRadius;
var()	float	DistortionRadius;
var()	float	GravityRadius;
var()	float	KillRadius;
var()	float	GravityStrength;
var()	float	DamagePerSecond;

//var  Emitter	Trail;

var  rotator	EffectRotation;
var  Emitter	EffectA,EffectB;

var bool bExploded;

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	EffectRotation.Pitch = RandRange(20000,40000);

   	EffectA = Spawn(class'EffectA', self, , Location);

   	if ( EffectA != None )
   	{
      		EffectA.SetBase(Self);
   	}

   	EffectB = Spawn(class'EffectB', self, , Location);

   	if ( EffectB != None )
   	{
      		EffectB.SetBase(Self);
   	} 
}


simulated function Destroyed()
{
	if (EffectA != None)
	{
		EffectA.Kill();
	}

	if (EffectB != None)
	{
		EffectB.Kill();
	}
/*
	if (Trail != None)
	{
		Trail.Kill();
	}
*/
		Super.Destroyed();
}


simulated function PostBeginPlay()
{
//    local vector Dir;
    local Rotator R;

//    Dir = vector(Rotation);

    Super.PostBeginPlay();
/*
	if ( Level.NetMode != NM_DedicatedServer)
	{
		Trail = Spawn(class'SC_Trail',,,Location - 15 * Dir);
		Trail.Setbase(self);
	}
*/
	Velocity = Vector(Rotation);
    Acceleration = Velocity * 3000.0;
    Velocity *= Speed;

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);
    
    if ( Instigator != None )
		InstigatorController = Instigator.Controller;
}


simulated function bool Immune( Pawn P )
{
	if( P == Instigator )
		return true;
}


event Tick( float DeltaTime )
{
	local Pawn P;
	local Projectile A;
	local Vector Delta, AttractionForce;
	local float Distance;
//	local int GravityChannel;
	local int ApplyDamage;

	// Update particle attachments.
	EffectRotation = EffectRotation + (rot(-1800,48000,3150) * DeltaTime);
	if (EffectA != None)
		EffectA.SetLocation( Location - (vect(0,32,0) >> EffectRotation) );
	if (EffectB != None)
	{
	EffectB.SetLocation( Location + (vect(0,32,0) >> EffectRotation) );
	EffectB.SetRotation( rotator(Location - EffectB.Location) );
	}

	foreach VisibleActors( class'Pawn', P, FieldRadius, Location )
	foreach VisibleActors( class'Projectile', A, FieldRadius, Location )
	{
		if( P != Self && !Immune( P ) )
		{
		if( P != Self )
		{

			// suck everything toward Location
			Delta = Location - P.Location;
			Distance = FMax( VSize( Delta ), 1.0 );

					if (true)
					{
						if( Distance < GravityRadius )
						{
							AttractionForce = GravityStrength * DeltaTime * Normal( Delta ) / Distance;
							if (!P.IsPlayerPawn())
								AttractionForce *= 2.0;
							P.Velocity += AttractionForce;
							P.SetPhysics( PHYS_Falling );
						}
					}

					if (Distance < KillRadius)
					{
						// instakill
						ApplyDamage = 9999;
					}
					else
					{
						ApplyDamage = (DamagePerSecond * DeltaTime) / (Distance / PainRadius);
					}
					
					P.TakeDamage( ApplyDamage, Instigator, P.Location, Vect(0,0,0), MyDamageType );
				
		}
				if (P.Health <= 0)
				{
					P.bHidden = true;
				}
		}
	}
}

defaultproperties
{
     FieldRadius=576.000000
     PainRadius=192.000000
     DistortionRadius=576.000000
     GravityRadius=576.000000
     KillRadius=64.000000
     GravityStrength=500000.000000
     DamagePerSecond=300.000000
     Speed=350.000000
     MaxSpeed=350.000000
     Damage=50.000000
     DamageRadius=1000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeSingularityCannon'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=65
     LightSaturation=80
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     DrawType=DT_None
     bDynamicLight=True
     AmbientSound=Sound'tk_FHIWeapons.FHISnd.Ambient_BlackHole'
     LifeSpan=10.000000
     SoundVolume=255
     SoundRadius=150.000000
     bCollideActors=False
}
