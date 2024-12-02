class ResupplyModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'ResupplyModifierArtifact'
    PickupMessage="You got an weapon resupply power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.ResupplyPickUp'
}
