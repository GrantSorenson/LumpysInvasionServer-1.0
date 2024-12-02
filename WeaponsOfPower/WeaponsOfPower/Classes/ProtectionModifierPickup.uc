class ProtectionModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'ProtectionModifierArtifact'
    PickupMessage="You got a weapon protection power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.ProtectionPickUp'
}
