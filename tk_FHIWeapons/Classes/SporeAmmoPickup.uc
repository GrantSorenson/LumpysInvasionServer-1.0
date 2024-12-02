class SporeAmmoPickup extends UTAmmoPickup;

#exec OBJ LOAD FILE=PickupSounds.uax

defaultproperties
{
     AmmoAmount=50
     MaxDesireability=0.320000
     InventoryType=Class'tk_FHIWeapons.SporeAmmo'
     PickupMessage="You picked up some explosive spores"
     PickupSound=Sound'PickupSounds.FlakAmmoPickup'
     PickupForce="FlakAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.BioAmmoPickup'
     CollisionHeight=8.250000
}
