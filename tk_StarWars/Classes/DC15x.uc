class DC15x extends DroidWeapon
    config(TKWeaponsClient);

    defaultproperties
{
    FireModeClass(0)=Class'tk_StarWars.DC15xFire'
    FireModeClass(1)=Class'tk_StarWars.DC15xFire'
    EffectOffset=(X=200.000000,Y=32.000000,Z=-25.000000)
    DisplayFOV=60.000000
    InventoryGroup=9
    PlayerViewOffset=(X=-7.000000,Y=8.000000)
    PlayerViewPivot=(Yaw=16884,Roll=200)
    BobDamping=1.400000
    AttachmentClass=Class'tk_StarWars.DC15xAttachment'
    ItemName="DC-15x Sniper Rifle"
    Mesh=SkeletalMesh'tk_StarWars.DC-15x'
    // HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
    Skins(0)=Texture'tk_StarWars.DC-15x.DC-15xTex'
}