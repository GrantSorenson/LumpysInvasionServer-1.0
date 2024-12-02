class FlareAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=30
     MaxDesireability=0.300000
     InventoryType=Class'tk_FHIWeapons.FlareAmmo'
     PickupMessage="You got a box of Flare Missiles"
     PickupSound=Sound'PickupSounds.RocketAmmoPickup'
     PickupForce="RocketAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketAmmoPickup'
     DrawScale=0.700000
     Skins(0)=Texture'tk_FHIWeapons.FHITex.FlareLauncherAmmoTex'
     CollisionHeight=13.500000
}