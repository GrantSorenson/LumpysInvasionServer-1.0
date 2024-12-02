class PoisonModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'PoisonModifierArtifact'
    PickupMessage="You got a poison weapon power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.PoisonPickUp'
}
