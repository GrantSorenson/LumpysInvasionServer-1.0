class DamageModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'DamageModifierArtifact'
    PickupMessage="You got a weapon damage power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.DamagePickUp'
}
