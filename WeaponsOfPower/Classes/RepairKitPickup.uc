class RepairKitPickup extends WeaponOfPowerArtifactPickup config(WeaponsOfPower);

defaultproperties
{
    InventoryType=Class'RepairKitArtifact'
    PickupMessage="You got the weapon repair kit!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.RepairKitPickup'
    bAcceptsProjectors=False
    AmbientGlow=255
}
