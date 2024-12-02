class UpgradeKitPickup extends WeaponOfPowerArtifactPickup config(WeaponsOfPower);

defaultproperties
{
    DrawType=DT_StaticMesh
	  DrawScale=0.075
    InventoryType=Class'UpgradeKitArtifact'
    PickupMessage="You got a Gold Wrench!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.UpgradeKitPickup'
    bAcceptsProjectors=False
    AmbientGlow=255
}
