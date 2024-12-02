class RailgunAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=40
     InventoryType=Class'tk_FHIWeapons.RailgunAmmo'
     PickupMessage="You picked up some particle ammo."
     PickupSound=Sound'tk_FHIWeapons.FHISnd.Phoenix_PickupAmmo'
     PickupForce="ShockAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkAmmoPickup'
     CollisionHeight=32.000000
}
