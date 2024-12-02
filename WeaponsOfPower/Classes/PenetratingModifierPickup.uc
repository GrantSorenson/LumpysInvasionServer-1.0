class PenetratingModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'PenetratingModifierArtifact'
    PickupMessage="You got a weapon Penetrating power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.PenetratingPickUp'
}
