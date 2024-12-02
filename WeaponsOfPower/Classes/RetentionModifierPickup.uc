class RetentionModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'RetentionModifierArtifact'
    PickupMessage="You got a retention weapon power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.RetentionPickUp'
}
