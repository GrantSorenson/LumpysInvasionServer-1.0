class UpgradeKitOnePickup extends WeaponOfPowerArtifactPickup config(WeaponsOfPower);

defaultproperties
{
    DrawType=DT_StaticMesh
	  DrawScale=0.5
    InventoryType=Class'UpgradeKitOneArtifact'
    PickupMessage="You got a Purple Wrench!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.UpgradeKitOnePickup'
    bAcceptsProjectors=False
    AmbientGlow=255
}
