class UnloadPickup extends WeaponOfPowerArtifactPickup config(WeaponsOfPower);

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'UnloadArtifact'
    PickupMessage="You got the Weapon Unload Artifact!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.UnloadPickup'
    bAcceptsProjectors=False
    AmbientGlow=255
}
