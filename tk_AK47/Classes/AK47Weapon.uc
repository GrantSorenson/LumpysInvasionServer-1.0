class AK47Weapon extends tk_ShockRifle;

#EXEC OBJ LOAD FILE="Resources/rs_AK47.u" PACKAGE="tk_AK47"

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
        Log("Successfully initialized AK47Weapon", 'AK47');
}

function byte BestMode()
{
	return byte(0);
}

defaultproperties
{
     FireModeClass(0)=Class'tk_AK47.AK47Fire'
     FireModeClass(1)=Class'tk_AK47.AK47AltFire'
     SelectSound=Sound'PickupSounds.AssaultRiflePickup'
     Description="AK47 that shoots exploding bullets"
     SmallViewOffset=(X=3.000000,Y=7.000000,Z=-11.000000)
     PickupClass=Class'tk_AK47.AK47Pickup'
     PlayerViewOffset=(X=8.000000,Y=7.000000,Z=-10.000000)
     PlayerViewPivot=(Yaw=750)
     AttachmentClass=Class'tk_AK47.AK47Attachment'
     IconMaterial=Texture'tk_AK47.AK47HUD'
     IconCoords=(X1=23,Y1=19,X2=104,Y2=44)
     ItemName="AK47"
     Mesh=SkeletalMesh'tk_AK47.AK47_Binslayer_1st'
     DrawScale=0.075000
     Skins(0)=Texture'tk_AK47.Skins.AK47Tex'
     Skins(1)=TexEnvMap'Chrome_cp.Walls.TexEnvMap5'
}
