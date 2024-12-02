class SC_Attachment extends xWeaponAttachment;

//var SC_MuzFlash MuzFlash;

/*
simulated function Destroyed()
{
    if (MuzFlash != None)
        MuzFlash.Destroy();

    Super.Destroyed();
}
*/

simulated event ThirdPersonEffects()
{
//    local Rotator R;
/*
    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
	{
        if ( FiringMode == 0 )
        {
            if (MuzFlash == None)
            {
                MuzFlash = Spawn(class'SC_MuzFlash');
                AttachToBone(MuzFlash, 'tip');
            }
            if (MuzFlash != None)
            {
                MuzFlash.Trigger(self, None);
                R.Roll = Rand(65536);
                SetBoneRotation('bone_flash', R, 0, 1.0);
            }
        }
    }
*/
    Super.ThirdPersonEffects();
}

defaultproperties
{
     bHeavy=True
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.SC_3rd'
     DrawScale=0.420000
}
