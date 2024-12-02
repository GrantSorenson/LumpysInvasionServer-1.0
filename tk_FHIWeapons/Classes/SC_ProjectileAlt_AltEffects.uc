//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SC_ProjectileAlt_AltEffects extends SC_ProjectileAlt;

simulated event PreBeginPlay()
{
	Super(Projectile).PreBeginPlay();

	//EffectRotation.Pitch = RandRange(20000,40000);

	if(!bDeleteMe)
	{
		EffectA = Spawn(class'SC_EmitterAlt',self);
		if(EffectA != None)
			EffectA.SetBase(self);
	}
}

Event Tick( float DeltaTime )
{
	local Projectile A;
	local Vector Delta, AttractionForce;
	local float Distance;

	// Update particle attachments.
	/*EffectRotation = EffectRotation + (rot(-1800,48000,3150) * DeltaTime);
	EffectA.SetLocation( Location - (vect(0,32,0) >> EffectRotation) );
	EffectB.SetLocation( Location + (vect(0,32,0) >> EffectRotation) );
	EffectB.SetRotation( rotator(Location - EffectB.Location) );*/

	foreach VisibleActors( class'Projectile', A, FieldRadius, Location )
	{
		if( A != Self )
		{

			// suck everything toward Location
			Delta = Location - A.Location;
			Distance = FMax( VSize( Delta ), 1.0 );

					if (true)
					{
						if( Distance < GravityRadius )
						{
							AttractionForce = GravityStrength * DeltaTime * Normal( Delta ) / Distance;
							AttractionForce *= 2.0;
							A.Velocity += AttractionForce;
							A.SetPhysics( PHYS_Falling );
						}
					}

		}
	}
}

defaultproperties
{
     Speed=1000.000000
     MaxSpeed=1000.000000
}
