class WidowmakerTracer extends xEmitter;

simulated function PostNetBeginPlay()
{
	local xWeaponAttachment Attachment;
	local vector X,Y,Z;
	
    if ( (xPawn(Instigator) != None) && !Instigator.IsFirstPerson() )
    {
        Attachment = xPawn(Instigator).WeaponAttachment;
        if ( (Attachment != None) && (Level.TimeSeconds - Attachment.LastRenderTime < 0.1) )
        {
			GetAxes(Attachment.Rotation,X,Y,Z);
            SetLocation(Attachment.Location -40*X -10*Z);
        }
    }
}

defaultproperties
{
     mParticleType=PT_Beam
     mMaxParticles=3
     mLifeRange(0)=0.750000
     mRegenDist=20000.000000
     mSizeRange(0)=7.000000
     mSizeRange(1)=7.000000
     mAttenKa=0.100000
     bReplicateInstigator=True
     bReplicateMovement=False
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=3.000000
     LifeSpan=0.300000
     Texture=Shader'tk_FHIWeapons.FHIShaders.TracerA_Shader'
     Skins(0)=Shader'tk_FHIWeapons.FHIShaders.TracerA_Shader'
     Style=STY_Additive
}
