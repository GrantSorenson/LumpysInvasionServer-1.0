class TurboLaserPickup extends UTWeaponPickup;

defaultproperties
{
     StandUp=(Y=0.250000,Z=0.000000)
     MaxDesireability=0.630000
     InventoryType=Class'tk_FHIWeapons.TurboLaser'
     PickupMessage="You got the Turbo Laser"
     PickupSound=Sound'PickupSounds.ShockRiflePickup'
     PickupForce="ShockRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'NewWeaponPickups.ShockPickupSM'
     DrawScale=0.500000
     Skins(0)=Texture'UT2004Weapons.NewWeaps.ShockRifleTex0'
     Skins(1)=FinalBlend'tk_FHIWeapons.FHIMat.TurboLaserAmmoFB'
}
