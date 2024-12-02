class HowitzerAttachment extends xWeaponAttachment;

var class<HowitzerMuzFlash3rd> mMuzFlashClass;
var xEmitter mMuzFlash3rd;

simulated function Destroyed()
{
	if (mMuzFlash3rd != None)
		mMuzFlash3rd.Destroy();
	Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
	local rotator r;

	if (Level.NetMode != NM_DedicatedServer && FlashCount > 0)
	{
		WeaponLight();
		if (mMuzFlash3rd == None)
		{
			mMuzFlash3rd = Spawn(mMuzFlashClass);
			AttachToBone(mMuzFlash3rd, 'tip');
		}

		if (mMuzFlash3rd != None)
		{
			r.Roll = Rand(65536);
			SetBoneRotation('Bone_Flash', r, 0, 1.f);
			mMuzFlash3rd.mStartParticles++;
		}
	}

	Super.ThirdPersonEffects();
}

defaultproperties
{
     mMuzFlashClass=Class'tk_FHIWeapons.HowitzerMuzFlash3rd'
     bHeavy=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=4.000000
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.Howitzer_3rd'
     DrawScale=0.690000
}