class SpeedModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'SpeedModifierArtifact'
    PickupMessage="You got a speed power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.SpeedPickUp'
}
