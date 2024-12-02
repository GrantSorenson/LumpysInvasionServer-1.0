class SingularityCannon extends tk_Weapon
	config(TKWeaponsClient);

function byte BestMode()
{
	return 0;
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.SC_Fire'
     FireModeClass(1)=Class'tk_FHIWeapons.SC_FireAlt'
     PutDownAnim="PutDown"
     SelectSound=Sound'tk_FHIWeapons.FHISnd.Sing_Select'
     SelectForce="SwitchToAssaultRifle"
     AIRating=1.000000
     CurrentRating=1.000000
     Description="Unknown..."
     DisplayFOV=70.000000
     Priority=12
     SmallViewOffset=(X=22.000000,Y=6.000000,Z=-29.000000)
     InventoryGroup=0
     GroupOffset=22
     PickupClass=Class'tk_FHIWeapons.SC_Pickup'
     PlayerViewOffset=(X=13.000000,Z=-19.000000)
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.SC_Attachment'
     IconMaterial=Texture'tk_FHIWeapons.FHIHud.HUDIcons'
     IconCoords=(X1=183,Y1=405,X2=270,Y2=451)
     ItemName="Singularity Cannon"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=65
     LightSaturation=80
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.SC_1st'
     DrawScale=0.800000
     UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'
     SoundRadius=100.000000
}
