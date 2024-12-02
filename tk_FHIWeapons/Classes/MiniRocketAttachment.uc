class MiniRocketAttachment extends xWeaponAttachment;

var class<xEmitter> MuzFlashClass;
var xEmitter MuzFlash;

var bool mbGotHit;
var float mCurrentRoll, mRollInc, mRollUpdateTime;

simulated function Destroyed()
{
	if (MuzFlash != None)
		MuzFlash.Destroy();

	Super.Destroyed();
}

simulated function UpdateRoll(float dt)
{
	local rotator r;

	UpdateRollTime(false);

	if (mRollInc <= 0.f)
		return;

	mCurrentRoll += dt*mRollInc;
	mCurrentRoll = mCurrentRoll % 65536.f;
	r.Roll = int(mCurrentRoll);

	SetBoneRotation('Bone_Barrel', r, 0, 1.f);
}

simulated function UpdateRollTime(bool bUpdate)
{
	local float diff;

	diff = Level.TimeSeconds - mRollUpdateTime;
	if (bUpdate)
		mRollUpdateTime = Level.TimeSeconds;

	if (diff > 0.2)
	{
		mbGotHit = false;
		mRollInc = 0.f;
	}
}

simulated event ThirdPersonEffects()
{
	local rotator r;

	if (Level.NetMode != NM_DedicatedServer && FlashCount > 0)
	{
		if (FiringMode == 0)
			mRollInc = 65536.f*3.f;
		else if (FiringMode == 1)
			mRollInc = 65536.f*3.f;

		UpdateRollTime(true);
		mbGotHit = true;
		if (MuzFlash == None)
		{
			MuzFlash = Spawn(MuzFlashClass);
			if (MuzFlash != None)
				AttachToBone(MuzFlash, 'tip');
		}

		if (MuzFlash != None)
		{
			MuzFlash.mStartParticles++;
			r.Roll = Rand(65536);
			SetBoneRotation('Bone_Flash', r, 0, 1.f);
		}
	}
	else
	{
		GotoState('');
	}

	Super.ThirdPersonEffects();
}

simulated function Tick(float deltaTime)
{
	UpdateRoll(deltaTime);
}

defaultproperties
{
     MuzFlashClass=Class'XEffects.RocketMuzFlash3rd'
     bRapidFire=True
     Mesh=SkeletalMesh'Weapons.Minigun_3rd'
     Skins(0)=Texture'tk_FHIWeapons.FHITex.MiniRocketTex'
}