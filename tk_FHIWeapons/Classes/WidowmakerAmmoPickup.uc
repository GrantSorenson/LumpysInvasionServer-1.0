class WidowmakerAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=15
     InventoryType=Class'tk_FHIWeapons.WidowmakerAmmo'
     PickupMessage="You picked up sniper ammo."
     PickupSound=Sound'tk_FHIWeapons.FHISnd.SniperRifle_PickupAmmo'
     PickupForce="SniperAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.WidowAmmoMesh'
     PrePivot=(Z=16.000000)
     CollisionHeight=16.000000
}
