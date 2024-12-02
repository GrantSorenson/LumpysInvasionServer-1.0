class LilLadyBlows extends RocketExplosion;

simulated function PostBeginPlay()
{
	Spawn(class'RocketSmokeRing');
	if (Level.bDropDetail)
		LightRadius = 7;	
}

defaultproperties
{
     mSizeRange(0)=50.000000
     mSizeRange(1)=100.000000
     bDynamicLight=False
     Skins(0)=Texture'AW-2004Explosions.Fire.Fireball1'
}
