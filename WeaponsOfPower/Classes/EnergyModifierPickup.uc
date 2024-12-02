class EnergyModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'EnergyModifierArtifact'
    PickupMessage="You got an weapon energy power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.EnergyPickUp'
}
