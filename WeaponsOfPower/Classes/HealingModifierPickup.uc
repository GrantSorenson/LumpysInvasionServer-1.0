class HealingModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'HealingModifierArtifact'
    PickupMessage="You got a healing weapon power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.HealingPickUp'
}
