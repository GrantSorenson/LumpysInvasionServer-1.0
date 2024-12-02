class ForceModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'ForceModifierArtifact'
    PickupMessage="You got a weapon force power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.ForcePickUp'
}
