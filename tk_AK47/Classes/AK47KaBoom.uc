class AK47KaBoom extends RocketExplosion;


simulated function PostBeginPlay()
{
		Spawn(class'RocketSmokeRing');
		if ( Level.bDropDetail )
			LightRadius = 4;
}

defaultproperties
{
     mSizeRange(0)=25.000000
     mSizeRange(1)=50.000000
     bDynamicLight=False
}
