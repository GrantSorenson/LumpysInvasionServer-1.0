class GrenadeAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=18
     MaxDesireability=0.620000
     InventoryType=Class'tk_FHIWeapons.GrenadeAmmo'
     PickupMessage="You picked up some grenades"
     PickupSound=Sound'tk_FHIWeapons.FHISnd.GrenadeLauncher_PickupAmmo'
     PickupForce="FlakAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'ONSWeapons-SM.GrenadeLauncherAmmo'
     DrawScale=0.250000
     CollisionRadius=20.000000
     CollisionHeight=9.000000
}