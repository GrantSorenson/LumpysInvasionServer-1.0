class LuckyModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'LuckyModifierArtifact'
    PickupMessage="You got a lucky weapon power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.LuckyPickUp'
}
