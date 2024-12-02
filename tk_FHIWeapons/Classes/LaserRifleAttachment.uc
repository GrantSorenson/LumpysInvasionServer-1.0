class LaserRifleAttachment extends xWeaponAttachment;

var class<LaserRifleMuzFlash3rd> mMuzFlashClass;
var() LaserRifleCharge3rd charged;
var xEmitter mMuzFlash3rd;

simulated function Destroyed()
{
	if (mMuzFlash3rd != None)
		mMuzFlash3rd.Destroy();

	if (charged != None)
		charged.Destroy();

	Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
	local rotator r;
	local class<LaserRifleMuzFlash3rd> muzClass;

	if (Level.NetMode != NM_DedicatedServer)
	{
		if (FiringMode == 0)
			muzClass = mMuzFlashClass;

		if (mMuzFlash3rd == None)
		{
			mMuzFlash3rd = Spawn(mMuzFlashClass);
			AttachToBone(mMuzFlash3rd, 'tip');
		}

		if (mMuzFlash3rd != None)
		{
			mMuzFlash3rd.Trigger(self, None);
			r.Roll = (0);
			SetBoneRotation('Bone Flash', r, 0, 1.f);
		}

		if (charged == None)
		{
			charged = Spawn(class'LaserRifleCharge3rd');
			AttachToBone(charged, 'tip');
		}

		WeaponLight();
	}

	Super.ThirdPersonEffects();
}

defaultproperties
{
     mMuzFlashClass=Class'tk_FHIWeapons.LaserRifleMuzFlash3rd'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=85
     LightBrightness=175.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'Weapons.Sniper_3rd'
     Skins(0)=Texture'tk_FHIWeapons.FHITex.LaserRifleTex'
}