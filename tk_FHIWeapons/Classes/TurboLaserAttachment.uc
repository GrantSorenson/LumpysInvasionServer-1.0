class TurboLaserAttachment extends xWeaponAttachment;

var class<xEmitter> TLMuzFlashClass;
var xEmitter TLMuzFlash;

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	if ((Instigator != None) && (Instigator.PlayerReplicationInfo != None)&& (Instigator.PlayerReplicationInfo.Team != None))
	{
		if (Instigator.PlayerReplicationInfo.Team.TeamIndex == 0)
			Skins[1] = Material'UT2004Weapons.RedShockFinal';
		else if (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1)
			Skins[1] = Material'UT2004Weapons.BlueShockFinal';
	}
}

simulated function Destroyed()
{
	if (TLMuzFlash != None)
	    TLMuzFlash.Destroy();

	Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
	local rotator r;

	if (Level.NetMode != NM_DedicatedServer && FlashCount > 0)
	{
		if (FiringMode == 0)
		{
			WeaponLight();
		}
		else
		{
			if (TLMuzFlash == None)
			{
				TLMuzFlash = Spawn(TLMuzFlashClass);
				AttachToBone(TLMuzFlash, 'tip');
			}

			if (TLMuzFlash != None)
			{
				TLMuzFlash.mStartParticles++;
				r.Roll = Rand(65536);
				SetBoneRotation('Bone_Flash', r, 0, 1.f);
			}
		}
	}

	Super.ThirdPersonEffects();
}

defaultproperties
{
     TLMuzFlashClass=Class'tk_FHIWeapons.TurboProjMuzFlash3rd'
     bRapidFire=True
     bAltRapidFire=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=37
     LightSaturation=70
     LightBrightness=150.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.NewShockRifle_3rd'
     RelativeLocation=(X=-3.000000,Y=-5.000000,Z=-10.000000)
     RelativeRotation=(Pitch=32768)
     Skins(0)=Texture'UT2004Weapons.NewWeaps.ShockRifleTex0'
     Skins(1)=FinalBlend'tk_FHIWeapons.FHIMat.TurboLaserAmmoFB'
}