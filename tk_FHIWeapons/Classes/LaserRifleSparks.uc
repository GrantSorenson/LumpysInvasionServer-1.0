class LaserRifleSparks extends xEmitter;

simulated function PostBeginPlay()
{
	Spawn(class'LaserRifleFlashExplosion');
}

defaultproperties
{
     mParticleType=PT_Line
     mRegen=False
     mStartParticles=15
     mMaxParticles=15
     mLifeRange(0)=0.200000
     mLifeRange(1)=0.400000
     mRegenRange(0)=0.000000
     mRegenRange(1)=0.000000
     mDirDev=(X=0.500000,Y=0.500000,Z=0.500000)
     mPosDev=(X=0.700000,Y=0.700000,Z=0.700000)
     mSpawnVecB=(X=5.000000)
     mSpeedRange(0)=250.000000
     mSpeedRange(1)=350.000000
     mMassRange(0)=1.500000
     mMassRange(1)=2.500000
     mAirResistance=0.200000
     mSizeRange(0)=2.000000
     mSizeRange(1)=1.000000
     mGrowthRate=-3.000000
     mAttenKa=0.100000
     bHighDetail=True
     Skins(0)=Texture'XEffectMat.Link.link_spark_green'
     ScaleGlow=2.000000
     Style=STY_Additive
}