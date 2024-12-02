class MiniRocketAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=30
     MaxDesireability=0.300000
     InventoryType=Class'tk_FHIWeapons.MiniRocketAmmo'
     PickupMessage="You picked up 30 mini-rockets."
     PickupSound=Sound'tk_FHIWeapons.FHISnd.RL_PickupAmmo'
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.MinigunAmmoPickup'
     DrawScale=0.800000
     Skins(0)=Texture'tk_FHIWeapons.FHITex.MiniRocketAmmoTex'
     CollisionHeight=12.750000
}