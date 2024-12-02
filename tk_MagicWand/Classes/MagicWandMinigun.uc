class MagicWandMinigun extends tK_Minigun
     config(TKWeaponsClient);

defaultproperties
{
     FireModeClass(0)=Class'tk_MagicWand.MagicWandMinigunFire'
     FireModeClass(1)=Class'tk_MagicWand.MagicWandMinigunAltFire' 
     AIRating=1.000000
     bCanThrow=False
     PickupClass=Class'tk_MagicWand.MagicWandMinigunPickup'
     AttachmentClass=Class'tk_MagicWand.MagicWandMinigunAttachment'
     ItemName="Magic Wand Minigun"
     Skins(0)=Texture'tk_MagicWand.MagicWand.WandMinigun'
}
