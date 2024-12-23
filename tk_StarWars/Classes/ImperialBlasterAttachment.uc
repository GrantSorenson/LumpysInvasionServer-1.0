class ImperialBlasterAttachment extends DroidWeaponAttachment
    config(TKWeaponsCliekt);

defaultproperties
{
     MuzFlashClass=Class'tk_StarWars.DroidWeaponMuzFlash'
     bRapidFire=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=200
     LightSaturation=70
     LightBrightness=255.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'tk_StarWars.Blaster3rd'
     RelativeLocation=(X=-0.000000,Y=-7.000000,Z=-4.000000)
     RelativeRotation=(Pitch=-1300,Yaw=-1300)
     DrawScale=0.35
     Skins(0)=Texture'tk_StarWars.ImperialBlaster.blaster_w'
}