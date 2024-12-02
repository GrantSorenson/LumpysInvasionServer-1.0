class RevivePickup extends WeaponOfPowerArtifactPickup config(WeaponsOfPower);

defaultproperties
{
  DrawType=DT_StaticMesh
	DrawScale=0.075
    InventoryType=Class'ReviveArtifact'
    PickupMessage="You got the revive artifact!"
    StaticMesh=StaticMesh'WeaponsOfPowerMeshes.Pickups.RevivePickup'
    bAcceptsProjectors=False
    AmbientGlow=255
}
