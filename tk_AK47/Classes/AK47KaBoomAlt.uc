class AK47KaBoomAlt extends RocketExplosion;


simulated function PostBeginPlay()
{
		Spawn(class'RocketSmokeRing');
		if ( Level.bDropDetail )
			LightRadius = 10;
}

defaultproperties
{
     mSizeRange(1)=150.000000
     bDynamicLight=False
}
