class LilLady extends tk_ShockRifle;

#EXEC OBJ LOAD FILE="Resources/tk_LilLady_rc.u" PACKAGE="tk_LilLady"

simulated function SuperMaxOutAmmo()
{}

function byte BestMode()
{
	return byte(Rand(2));
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}

defaultproperties
{
     FireModeClass(0)=Class'tk_LilLady.LilLadyProjFire'
     FireModeClass(1)=Class'tk_LilLady.LilLadyAltFire'
     SelectSound=Sound'PickupSounds.AssaultRiflePickup'
     PickupClass=Class'tk_LilLady.LilLadyPickup'
     AttachmentClass=Class'tk_LilLady.LilLadyAttachment'
     ItemName="LilLady"
     Skins(0)=Texture'tk_LilLady.LilLady.newlillady'
     Skins(1)=FinalBlend'UT2004Weapons.Shaders.RedShockFinal'
}
