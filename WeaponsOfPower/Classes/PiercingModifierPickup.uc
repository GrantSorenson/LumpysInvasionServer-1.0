class PiercingModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'PiercingModifierArtifact'
    PickupMessage="You got a piercing weapon power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.PiercingPickUp'
}
