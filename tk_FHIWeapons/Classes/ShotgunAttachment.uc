class ShotgunAttachment extends xWeaponAttachment;

var class<ShotgunMuzFlash3rd>  mMuzClass;
var xEmitter                mMuz3rd;

var class<xEmitter>     mShellCaseEmitterClass;
var xEmitter            mShellCaseEmitter;
var() vector            mShellEmitterOffset;

simulated function Destroyed()
{
    if (mMuz3rd != None)
        mMuz3rd.Destroy();

    if (mShellCaseEmitter != None)
        mShellCaseEmitter.Destroy();

	Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    local rotator r;

    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
	{
		WeaponLight();

        if (mMuz3rd == None)
        {
            mMuz3rd = Spawn(mMuzClass);
            AttachToBone(mMuz3rd, 'tip');
        }

        if (mMuz3rd != None)
        {
            r.Roll = Rand(65536);
            SetBoneRotation('Bone_Flash', r, 0, 1.f);
            mMuz3rd.mStartParticles++;
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

    Super.ThirdPersonEffects();
}

defaultproperties
{
     mMuzClass=Class'tk_FHIWeapons.ShotgunMuzFlash3rd'
     mShellCaseEmitterClass=Class'tk_FHIWeapons.ShotgunShellSpewer'
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.CombatShotgun_3rd'
     DrawScale=0.470000
}
