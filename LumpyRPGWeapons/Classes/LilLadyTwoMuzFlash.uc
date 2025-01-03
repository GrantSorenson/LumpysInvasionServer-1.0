class LilLadyTwoMuzFlash extends xEmitter;


var int mNumPerFlash;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    mStartParticles += mNumPerFlash;
}

defaultproperties
{
     mNumPerFlash=3
     mParticleType=PT_Mesh
     mStartParticles=0
     mMaxParticles=6
     mLifeRange(0)=0.200000
     mLifeRange(1)=0.200000
     mRegenRange(0)=0.000000
     mRegenRange(1)=0.000000
     mSpawnVecB=(Z=0.000000)
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mPosRelative=True
     mAirResistance=0.000000
     mSizeRange(0)=0.600000
     mSizeRange(1)=0.700000
     mColorRange(0)=(B=0,G=0,R=99)
     mColorRange(1)=(B=0,G=0,R=99)
     mAttenKa=0.000000
     mRandTextures=True
     mNumTileColumns=2
     mNumTileRows=2
     mMeshNodes(0)=StaticMesh'XEffects.MinigunMuzFlash1stMesh'
     DrawScale=0.700000
     Skins(0)=FinalBlend'XGameShaders.WeaponShaders.MinigunMuzFlash1stFinal'
     Style=STY_Additive
}
