class GhostPickup extends WeaponOfPowerArtifactPickup config(WeaponsOfPower);

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'GhostArtifact'
    PickupMessage="You got the Ghost Artifact!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.GhostPickup'
    bAcceptsProjectors=False
    AmbientGlow=255
}
