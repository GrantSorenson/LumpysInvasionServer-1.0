class AwarenessModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
  DrawScale=0.075
    InventoryType=Class'AwarenessModifierArtifact'
    PickupMessage="You got an awareness power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.AwarenessPickUp'
}
