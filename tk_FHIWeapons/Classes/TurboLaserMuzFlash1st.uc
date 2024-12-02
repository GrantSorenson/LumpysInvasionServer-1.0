class TurboLaserMuzFlash1st extends xEmitter;

var int mNumPerFlash;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    mStartParticles += mNumPerFlash;
}

defaultproperties
{
     mNumPerFlash=5
     mParticleType=PT_Mesh
     mStartParticles=0
     mMaxParticles=20
     mLifeRange(0)=0.100000
     mLifeRange(1)=0.150000
     mRegenRange(0)=0.000000
     mRegenRange(1)=0.000000
     mSpawnVecB=(Z=0.000000)
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mPosRelative=True
     mAirResistance=0.000000
     mSizeRange(0)=0.150000
     mSizeRange(1)=0.180000
     mGrowthRate=3.000000
     mRandTextures=True
     mTileAnimation=True
     mNumTileColumns=2
     mNumTileRows=2
     mMeshNodes(0)=StaticMesh'XEffects.MinigunMuzFlash1stMesh'
     DrawScale=0.700000
     Skins(0)=FinalBlend'tk_FHIWeapons.FHIMat.TurboLaserMuzFlash1st_FB'
     Style=STY_Additive
}
