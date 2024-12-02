//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SC_ProjectileAltEffects extends SC_Projectile;

simulated event PreBeginPlay()
{
	Super(Projectile).PreBeginPlay();

	//EffectRotation.Pitch = RandRange(20000,40000);

   	EffectA = Spawn(class'SC_EmitterAlt', self, , Location);
   	if ( EffectA != None )
      	EffectA.SetBase(Self);
}

simulated function PostBeginPlay()
{
//    local vector Dir;
    local Rotator R;

//    Dir = vector(Rotation);

    Super(Projectile).PostBeginPlay();
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

event Tick( float DeltaTime )
{
	local Pawn P;
	//local Projectile A;
	local Vector Delta, AttractionForce;
	local float Distance;
//	local int GravityChannel;
	local int ApplyDamage;

	// Update particle attachments.
	/*EffectRotation = EffectRotation + (rot(-1800,48000,3150) * DeltaTime);
	if (EffectA != None)
		EffectA.SetLocation( Location - (vect(0,32,0) >> EffectRotation) );
	if (EffectB != None)
	{
	EffectB.SetLocation( Location + (vect(0,32,0) >> EffectRotation) );
	EffectB.SetRotation( rotator(Location - EffectB.Location) );
	}*/

	foreach VisibleActors( class'Pawn', P, FieldRadius, Location )
	{
		if( P != Self && !Immune( P ) )
		{
			// suck everything toward Location
			Delta = Location - P.Location;
			Distance = FMax( VSize( Delta ), 1.0 );
	
			if( Distance < GravityRadius )
			{
				AttractionForce = GravityStrength * DeltaTime * Normal( Delta ) / Distance;
				if (!P.IsPlayerPawn())
					AttractionForce *= 2.0;
				P.Velocity += AttractionForce;
				P.SetPhysics( PHYS_Falling );
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
			if (P.Health <= 0)
			{
				P.bHidden = true;
			}
		}
	}
}

defaultproperties
{
     Speed=1000.000000
     MaxSpeed=1000.000000
}
