class TurboBeamEffect extends xEmitter;

var Vector HitNormal;
var class<TurboBeamCoil> CoilClass;
var class<TurboLaserMuzFlash> MuzFlashClass;
var class<TurboLaserMuzFlash3rd> MuzFlash3Class;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        HitNormal;
}

function AimAt(Vector hl, Vector hn)
{
    HitNormal = hn;
    mSpawnVecA = hl;
    if (Level.NetMode != NM_DedicatedServer)
        SpawnEffects();
}

simulated function PostNetBeginPlay()
{
    if (Role < ROLE_Authority)
        SpawnEffects();
}

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
	Spawn(class'TurboImpactFlare',,, EffectLoc, HitRot);
	Spawn(class'TurboImpactRing',,, EffectLoc, HitRot);
	Spawn(class'TurboImpactScorch',,, EffectLoc, Rotator(-HitNormal));
	Spawn(class'TurboExplosionCore_a',,, EffectLoc+HitNormal*8, HitRot);
}

simulated function SpawnEffects()
{
    local TurboBeamCoil Coil;
    local xWeaponAttachment Attachment;

    if (Instigator != None)
    {
        if ( Instigator.IsFirstPerson() )
        {
			if ( (Instigator.Weapon != None) && (Instigator.Weapon.Instigator == Instigator) )
				SetLocation(Instigator.Weapon.GetEffectStart());
			else
				SetLocation(Instigator.Location);
            Spawn(MuzFlashClass,,, Location);
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
                SetLocation(Attachment.GetTipLocation());
            else
                SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(mSpawnVecA - Instigator.Location) * 25.0); 
            Spawn(MuzFlash3Class);
        }
    }

    if ( EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && (HitNormal != Vect(0,0,0)) )
		SpawnImpactEffects(Rotator(HitNormal),mSpawnVecA + HitNormal*2);

    if ( !Level.bDropDetail && Level.DetailMode != DM_Low )
    {
	    Coil = Spawn(class'TurboBeamCoil',,, Location, Rotation);
	    if (Coil != None)
		    Coil.mSpawnVecA = mSpawnVecA;
    }
}

defaultproperties
{
     MuzFlashClass=Class'tk_FHIWeapons.TurboLaserMuzFlash'
     MuzFlash3Class=Class'tk_FHIWeapons.TurboLaserMuzFlash3rd'
     mParticleType=PT_Beam
     mMaxParticles=3
     mLifeRange(0)=0.750000
     mRegenDist=150.000000
     mSizeRange(0)=24.000000
     mSizeRange(1)=48.000000
     mAttenKa=0.100000
     bReplicateInstigator=True
     bReplicateMovement=False
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=3.000000
     LifeSpan=0.750000
     Texture=Texture'tk_FHIWeapons.FHITex.LaserBeamTex_B'
     Skins(0)=Texture'tk_FHIWeapons.FHITex.LaserBeamTex_B'
     Style=STY_Additive
}
