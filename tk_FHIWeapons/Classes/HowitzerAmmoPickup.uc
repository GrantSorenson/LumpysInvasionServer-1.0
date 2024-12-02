class HowitzerAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=15
     MaxDesireability=0.620000
     InventoryType=Class'tk_FHIWeapons.HowitzerAmmo'
     PickupMessage="You picked up 15 Howitzer Shells."
     PickupSound=Sound'PickupSounds.FlakAmmoPickup'
     PickupForce="FlakAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.HowitzerAmmoMesh'
     DrawScale=0.800000
     PrePivot=(Z=6.500000)
     CollisionHeight=8.250000
}