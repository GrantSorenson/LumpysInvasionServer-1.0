class ArtifactSuperMagicWeaponMakerPickup extends RPGArtifactPickup;

defaultproperties
{
     InventoryType=Class'ArtifactSuperMagicWeaponMaker'
     PickupMessage="You got the Super Magic Weapon Maker!"
     PickupSound=Sound'PickupSounds.ShieldPack'
     PickupForce="ShieldPack"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XPickups_rc.UDamagePack'
     bAcceptsProjectors=False
     Physics=PHYS_Rotating
     DrawScale=0.175000
     Skins(0)=Shader'XGameShaders.BRShaders.BombIconBS'
     AmbientGlow=255
     RotationRate=(Yaw=54000)
}
