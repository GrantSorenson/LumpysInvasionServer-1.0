class WeaponSummonModifierPickup extends WeaponModifierPickup;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'WeaponSummonModifierArtifact'
    PickupMessage="You got a weapon summon weapon power up!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.WeaponSummonPickUp'
}
