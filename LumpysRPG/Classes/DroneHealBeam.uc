class DroneHealBeam extends xEmitter;

var Material BlueBeam, RedBeam, GreenBeam; //0,1,2

function SetBeamTrail(int beamColor)
{
    switch(beamColor)
    {
        case 0:
            Skins[0] = BlueBeam;
            break;
        case 1:
            Skins[0] = RedBeam;
            break;
        case 2:
            Skins[0] = GreenBeam;
            break;
        default:
            Skins[0] = GreenBeam;
            break;
    }
}

defaultproperties
{
    BlueBeam=FinalBlend'XEffectMat.Link.LinkBeamBlueFB'
    RedBeam=FinalBlend'XEffectMat.Link.LinkBeamRedFB'
    GreenBeam=FinalBlend'XEffectMat.Link.LinkBeamGreenFB'
    mParticleType=6
    mMaxParticles=3
    mRegenDist=12.00
    mSpinRange=45000.00
    mSizeRange=8.00
    mColorRange(0)=(R=240,G=240,B=240,A=255),
    mColorRange(1)=(R=240,G=240,B=240,A=255),
    mAttenuate=False
    mAttenKa=0.00
    mBendStrength=3.00
    bNetTemporary=False
    bReplicateInstigator=True
    RemoteRole=2
    AmbientSound=Sound'WeaponSounds.LinkGun.BLinkGunBeam2'
    Skins=
    Style=6
    bHardAttach=True
    SoundVolume=192
    SoundRadius=96.00
}

    // RedSkin=FinalBlend'XEffectMat.Link.LinkBeamRedFB'
    // BlueSkin=FinalBlend'XEffectMat.Link.LinkBeamBlueFB'
    // DefaultSkin=FinalBlend'XEffectMat.Link.LinkBeamGreenFB'