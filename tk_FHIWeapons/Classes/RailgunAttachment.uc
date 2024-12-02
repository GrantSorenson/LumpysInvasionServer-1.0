class RailgunAttachment extends xWeaponAttachment;

var class<xEmitter> MuzFlashClass;
var xEmitter MuzFlash;

simulated function Destroyed()
{
	if (MuzFlash != None)
		MuzFlash.Destroy();

	Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
	local rotator r;

	if (Level.NetMode != NM_DedicatedServer && FlashCount > 0)
	{
		WeaponLight();
		if (MuzFlash == None)
		{
			MuzFlash = Spawn(MuzFlashClass);
			AttachToBone(MuzFlash, 'tip');
		}

		if (MuzFlash != None)
		{
			MuzFlash.mStartParticles++;
			r.Roll = Rand(65536);
			SetBoneRotation('Bone_Flash', r, 0, 1.f);
		}
	}

	Super.ThirdPersonEffects();
}

defaultproperties
{
     MuzFlashClass=Class'XEffects.ShockProjMuzFlash3rd'
     bRapidFire=True
     bAltRapidFire=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=170
     LightSaturation=235
     LightBrightness=150.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.NewLinkGun_3rd'
     RelativeLocation=(X=15.000000,Y=-5.000000,Z=-7.000000)
     RelativeRotation=(Pitch=32768)
     Skins(0)=Shader'tk_FHIWeapons.FHIShaders.RailgunShader'
}