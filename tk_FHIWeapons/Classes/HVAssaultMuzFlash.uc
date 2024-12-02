class HVAssaultMuzFlash extends xEmitter;

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
     mMaxParticles=10
     mLifeRange(0)=0.100000
     mLifeRange(1)=0.150000
     mRegenRange(0)=0.000000
     mRegenRange(1)=0.000000
     mSpawnVecB=(Z=0.000000)
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mPosRelative=True
     mAirResistance=0.000000
     mSizeRange(0)=0.050000
     mSizeRange(1)=0.080000
     mGrowthRate=1.500000
     mMeshNodes(0)=StaticMesh'tk_FHIWeapons.FHIMesh.HVMuzFlashMesh'
     DrawScale=1.700000
     DrawScale3D=(X=1.500000)
     Skins(0)=FinalBlend'tk_FHIWeapons.FHIMat.HVAssaultMuzFlash_FB'
     Style=STY_Additive
}