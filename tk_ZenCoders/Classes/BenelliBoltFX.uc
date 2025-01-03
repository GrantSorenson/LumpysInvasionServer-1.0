class BenelliBoltFX extends xEmitter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	MakeNoise(0.5);
	PlaySound(Sound'WeaponSounds.BExplosion1',SLOT_Misc,,,,,false);
}

simulated function PostNetBeginPlay()
{
	local xWeaponAttachment Attachment;
	local vector X, Y, Z;

	if ((xPawn(Instigator) != None) && !Instigator.IsFirstPerson())
	{
		Attachment = xPawn(Instigator).WeaponAttachment;
		if ((Attachment != None) && (Level.TimeSeconds - Attachment.LastRenderTime < 0.1))
		{
			GetAxes(Attachment.Rotation, X, Y, Z);
			SetLocation(Attachment.Location -40*X -10*Z);
		}
	}
}

defaultproperties
{
     mParticleType=PT_Branch
     mRegen=False
     mStartParticles=30
     mMaxParticles=30
     mLifeRange(0)=0.200000
     mLifeRange(1)=0.200000
     mSpawnVecB=(X=40.000000,Y=40.000000,Z=10.000000)
     mAirResistance=0.000000
     mSizeRange(0)=30.000000
     mSizeRange(1)=30.000000
     blockOnNet=True
     bReplicateInstigator=True
     bReplicateMovement=False
     bSkipActorPropertyReplication=True
     RemoteRole=ROLE_DumbProxy
     NetPriority=3.000000
     Skins(0)=Texture'tk_ZenCoders.Zen.BenelliBoltTex'
     Style=STY_Additive
}