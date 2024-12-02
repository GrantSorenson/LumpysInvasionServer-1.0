class SporeRifle extends tk_BioRifle
    config(TKWeaponsClient);

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.SporeFire'
     FireModeClass(1)=Class'tk_FHIWeapons.SporeAltFire'
     GroupOffset=62
     PickupClass=Class'tk_FHIWeapons.SporeRiflePickup'
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.SporeAttachment'
     ItemName="Spore-Rifle"
}
