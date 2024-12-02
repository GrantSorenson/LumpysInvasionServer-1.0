class HVAssaultAttachment extends xWeaponAttachment;

var class<Emitter> mTracerClass;
var() editinline Emitter mTracer;

var float mTracerInterval, mLastTracerTime;
var() float mTracerIntervalPrimary;
var() float mTracerPullback;
var() float mTracerMinDistance;
var() float mTracerSpeed;

var byte OldSpawnHitCount;
var class<xEmitter> mMuzFlashClass;
var xEmitter mMuzFlash3rd;
var xEmitter mMuzFlash3rdAlt;
var bool bDualGun;
var HVAssaultAttachment TwinGun;
var float AimAlpha;
var vector mOldHitLocation;

replication
{
	reliable if (Role == ROLE_Authority)
		bDualGun, TwinGun;
}

simulated function Hide(bool NewbHidden)
{
	bHidden = NewbHidden;
	if (TwinGun != None)
		TwinGun.bHidden = bHidden;
}

simulated function Destroyed()
{
	if (bDualGun)
	{
		if (Instigator != None)
		{
			Instigator.SetBoneDirection(AttachmentBone, Rotation,, 0, 0);
			Instigator.SetBoneDirection('lfarm', Rotation,, 0, 0);
		}
	}

	if (mTracer != None)
		mTracer.Destroy();

	if (mMuzFlash3rd != None)
		mMuzFlash3rd.Destroy();

	if (mMuzFlash3rdAlt != None)
		mMuzFlash3rdAlt.Destroy();

	Super.Destroyed();
}

simulated function vector GetTracerStart()
{
	local Pawn p;

	p = Pawn(Owner);
	if ((p != None) && p.IsFirstPerson() && p.Weapon != None)
		return p.Weapon.GetEffectStart();

	if (mMuzFlash3rd != None)
		return mMuzFlash3rd.Location;
	else
		return Location;
}

simulated function UpdateTracer()
{
	local vector SpawnLoc, SpawnDir, SpawnVel;
	local float hitDist;

	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (mTracer == None)
		mTracer = Spawn(mTracerClass);

	if (mTracer != None && Level.TimeSeconds > mLastTracerTime + mTracerInterval)
	{
		SpawnLoc = GetTracerStart();
		mTracer.SetLocation(SpawnLoc);
		hitDist = VSize(mHitLocation - SpawnLoc) - mTracerPullback;

		// if we have a hit but the hit location has not changed
		if (mHitLocation == mOldHitLocation)
			SpawnDir = vector(Instigator.GetViewRotation());
		else
			SpawnDir = Normal(mHitLocation - SpawnLoc);

		if (hitDist > mTracerMinDistance)
		{
			SpawnVel = SpawnDir * mTracerSpeed;
			
			mTracer.Emitters[0].StartVelocityRange.X.Min = SpawnVel.X;
			mTracer.Emitters[0].StartVelocityRange.X.Max = SpawnVel.X;
			mTracer.Emitters[0].StartVelocityRange.Y.Min = SpawnVel.Y;
			mTracer.Emitters[0].StartVelocityRange.Y.Max = SpawnVel.Y;
			mTracer.Emitters[0].StartVelocityRange.Z.Min = SpawnVel.Z;
			mTracer.Emitters[0].StartVelocityRange.Z.Max = SpawnVel.Z;

			mTracer.Emitters[0].LifetimeRange.Min = hitDist / mTracerSpeed;
			mTracer.Emitters[0].LifetimeRange.Max = mTracer.Emitters[0].LifetimeRange.Min;

			mTracer.SpawnParticle(1);
		}

		mLastTracerTime = Level.TimeSeconds;
	}

	mOldHitLocation = mHitLocation;
}

simulated function SetOverlayMaterial( Material mat, float time, bool bOverride )
{
	Super.SetOverlayMaterial(mat, time, bOverride);
	if (!bDualGun && (TwinGun != None))
		TwinGun.SetOverlayMaterial(mat, time, bOverride);
}

simulated function Tick(float deltatime)
{
	local rotator newRot;

	if (!bDualGun || (Level.NetMode == NM_DedicatedServer))
	{
		Disable('Tick');
		return;
	}
	
	AimAlpha = AimAlpha * ( 1 - 2*DeltaTime);	
	// point in firing direction
	if (Instigator != None)
	{
		newRot = Instigator.Rotation;
		if (AimAlpha < 0.5)
			newRot.Yaw += 4500 * (1 - 2*AimAlpha);
		Instigator.SetBoneDirection('lfarm', newRot,, 1.0, 1);
	    
		newRot.Roll += 32768;
		Instigator.SetBoneDirection(AttachmentBone, newRot,, 1.0, 1);
	}
}

function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
	SpawnHitCount++;
	mHitLocation = HitLocation;
	mHitActor = HitActor;
	mHitNormal = HitNormal;
}

simulated function MakeMuzzleFlash()
{
	local rotator r;

	AimAlpha = 1;
	if (TwinGun != None)
		TwinGun.AimAlpha = 1;

	if (mMuzFlash3rd == None)
	{
		mMuzFlash3rd = Spawn(mMuzFlashClass);
		AttachToBone(mMuzFlash3rd, 'tip');
	}
	mMuzFlash3rd.mStartParticles++;

	r.Roll = (0);
	SetBoneRotation('Bone_Flash', r, 0, 1.f);
}

simulated event ThirdPersonEffects()
{
	local rotator r;
	local PlayerController PC;

	if (Level.NetMode != NM_DedicatedServer)
	{
		AimAlpha = 1;
		if (TwinGun != None)
			TwinGun.AimAlpha = 1;

		if (FiringMode == 0)
		{
			WeaponLight();
			if (OldSpawnHitCount != SpawnHitCount)
			{
				OldSpawnHitCount = SpawnHitCount;
				GetHitInfo();
				PC = Level.GetLocalPlayerController();
				if (((Instigator != None) && (Instigator.Controller == PC)) || (VSize(PC.ViewTarget.Location - mHitLocation) < 4000))
					Spawn(class'HitEffect'.static.GetHitEffect(mHitActor, mHitLocation, mHitNormal),,, mHitLocation, Rotator(mHitNormal));
			}

			MakeMuzzleFlash();
			if (!bDualGun && (TwinGun != None))
				TwinGun.MakeMuzzleFlash();

			mTracerInterval = mTracerIntervalPrimary;
			if (Level.bDropDetail || Level.DetailMode == DM_Low)
				mTracerInterval *= 2.0;

        		UpdateTracer();
		}
		else if (FiringMode == 1 && FlashCount > 0)
		{
			WeaponLight();
			if (mMuzFlash3rdAlt == None)
			{
				mMuzFlash3rdAlt = Spawn(mMuzFlashClass);
				AttachToBone(mMuzFlash3rdAlt, 'tip2');
			}
			mMuzFlash3rdAlt.mStartParticles++;

			r.Roll = (0);
			SetBoneRotation('Bone_Flash02', r, 0, 1.f);
		}
	}

	Super.ThirdPersonEffects();
}

defaultproperties
{
     mTracerClass=Class'tk_FHIWeapons.HVAssaultTracer'
     mTracerIntervalPrimary=0.070000
     mTracerPullback=50.000000
     mTracerSpeed=17000.000000
     mMuzFlashClass=Class'tk_FHIWeapons.HVAssaultMuzFlash'
     bRapidFire=True
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.NewAssaultRifle_3rd'
     RelativeLocation=(X=-20.000000,Y=-5.000000)
     RelativeRotation=(Pitch=32768)
     DrawScale=0.300000
}