class RailgunExplosion extends xEmitter;

simulated event PostBeginPlay()
{
    Super.PostBeginPlay();

    Spawn(class'RailgunExplosionCore');
    SetTimer(0.5, false);
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

simulated function Timer()
{
    LightType = LT_None;
}

defaultproperties
{
     mSpawningType=ST_Explode
     mStartParticles=15
     mMaxParticles=15
     mLifeRange(0)=2.000000
     mLifeRange(1)=2.000000
     mRegenRange(0)=5.500000
     mRegenRange(1)=5.500000
     mSpeedRange(0)=20.000000
     mSpeedRange(1)=30.000000
     mRandOrient=True
     mSizeRange(0)=26.000000
     mSizeRange(1)=26.000000
     mGrowthRate=-5.000000
     mColorRange(0)=(B=221,G=1,R=167)
     mColorRange(1)=(B=233,G=13,R=179)
     mAttenKa=0.300000
     mAttenFunc=ATF_ExpInOut
     LightType=LT_Steady
     LightHue=210
     LightSaturation=35
     LightBrightness=255.000000
     LightRadius=3.000000
     bAttenByLife=True
     bDynamicLight=True
     bSuperHighDetail=True
     LifeSpan=2.500000
     Skins(0)=Texture'AW-2004Particles.Energy.BurnFlare'
     Style=STY_Translucent
}
