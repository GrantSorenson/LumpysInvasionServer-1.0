class ImperialBlaster extends DroidWeapon
    config(TKWeaponsClient);

    defaultproperties
{
    FireModeClass(0)=Class'tk_StarWars.ImperialBlasterFire'
    FireModeClass(1)=Class'tk_StarWars.ImperialBlasterFire'
    EffectOffset=(X=200.000000,Y=32.000000,Z=-25.000000)
    DisplayFOV=60.000000
    InventoryGroup=4
    PlayerViewOffset=(X=-7.000000,Y=8.000000)
    PlayerViewPivot=(Yaw=16884,Roll=200)
    BobDamping=1.400000
    AttachmentClass=Class'tk_StarWars.ImperialBlasterAttachment'
    ItemName="Droid Blaster"
    Mesh=SkeletalMesh'tk_StarWars.Blasterfirst'
    HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
    Skins(0)=Texture'tk_StarWars.ImperialBlaster.blaster_r'
    Skins(1)=Shader'tk_StarWars.ImperialBlaster.scopeshader'
}