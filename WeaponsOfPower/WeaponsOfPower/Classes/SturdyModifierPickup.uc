class SturdyModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'SturdyModifierArtifact'
    PickupMessage="You got a sturdy weapon power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.SturdyPickUp'
}
