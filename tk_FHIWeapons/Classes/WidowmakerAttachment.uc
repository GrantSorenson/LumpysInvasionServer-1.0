class WidowmakerAttachment extends xWeaponAttachment;

var class<WidowmakerMuzFlash>     mMuzFlashClass;
var xEmitter			 mMuzFlash3rd;

var class<xEmitter>     mShellCaseEmitterClass;
var xEmitter            mShellCaseEmitter;
var() vector            mShellEmitterOffset;

function Destroyed()
{
    if (mMuzFlash3rd != None)
        mMuzFlash3rd.Destroy();

    if (mShellCaseEmitter != None)
        mShellCaseEmitter.Destroy();

	Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    local rotator r;
    local class<WidowmakerMuzFlash> muzClass;

    if ( (Level.NetMode == NM_DedicatedServer) || (Instigator == None) 
		|| ((Level.TimeSeconds - LastRenderTime > 0.2) && (PlayerController(Instigator.Controller) == None)) )
        return;
	WeaponLight();

    if ( FlashCount > 0 )
	{
        if (FiringMode == 0)
        {
            muzClass = mMuzFlashClass;
        }

        if (mMuzFlash3rd == None)
        {
            mMuzFlash3rd = Spawn(mMuzFlashClass);
            AttachToBone(mMuzFlash3rd, 'tip');
        }
        if (mMuzFlash3rd != None)
        {
            mMuzFlash3rd.Trigger(self, None);
            SetBoneRotation('Bone Flash', r, 0, 1.f);
        }

        if ( (mShellCaseEmitter == None) && (Level.DetailMode != DM_Low) )
        {
            mShellCaseEmitter = Spawn(mShellCaseEmitterClass);
            if ( mShellCaseEmitter != None )
				AttachToBone(mShellCaseEmitter, 'shell');
        }
        if (mShellCaseEmitter != None)
            mShellCaseEmitter.mStartParticles++;

    }
    else
    {
        GotoState('');
    }

    Super.ThirdPersonEffects();
}

defaultproperties
{
     mMuzFlashClass=Class'tk_FHIWeapons.WidowmakerMuzFlash'
     mShellCaseEmitterClass=Class'tk_FHIWeapons.WidowmakerShellSpewer'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=165
     LightSaturation=170
     LightBrightness=75.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.Widowmaker_3rd'
     DrawScale=0.550000
}
