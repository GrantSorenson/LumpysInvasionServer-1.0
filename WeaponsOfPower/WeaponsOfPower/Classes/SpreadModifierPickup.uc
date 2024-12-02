class SpreadModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'SpreadModifierArtifact'
    PickupMessage="You got a weapon spread power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.SpreadPickUp'
}
