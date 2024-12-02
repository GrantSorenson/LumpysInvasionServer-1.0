class LaserRifleBolt extends xEmitter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	MakeNoise(0.5);
	PlaySound(Sound'WeaponSounds.BaseFiringSounds.BPainterRifleAltFire', SLOT_Misc,,,,,false);
}

simulated function PostNetBeginPlay()
{
	local xWeaponAttachment Attachment;
	local vector X,Y,Z;
	
	if ((xPawn(Instigator) != None) && !Instigator.IsFirstPerson())
	{
		Attachment = xPawn(Instigator).WeaponAttachment;
		if ((Attachment != None) && (Level.TimeSeconds - Attachment.LastRenderTime < 0.1))
		{
			GetAxes(Attachment.Rotation,X,Y,Z);
			SetLocation(Attachment.Location -40*X -10*Z);
		}
	}
}

defaultproperties
{
     mParticleType=PT_Beam
     mMaxParticles=4
     mLifeRange(0)=0.750000
     mRegenDist=150.000000
     mSizeRange(0)=14.000000
     mSizeRange(1)=28.000000
     mAttenKa=0.100000
     bReplicateInstigator=True
     bReplicateMovement=False
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=3.000000
     LifeSpan=0.750000
     Texture=FinalBlend'tk_FHIWeapons.FHIMat.LaserRifleBeam_FB'
     Skins(0)=FinalBlend'tk_FHIWeapons.FHIMat.LaserRifleBeam_FB'
     Style=STY_Translucent
}