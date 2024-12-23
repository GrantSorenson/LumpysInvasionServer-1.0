class DroidWeapon extends tk_Weapon
    config(TKWeaponsClient);

defaultproperties
{
    FireModeClass(0)=Class'tk_StarWars.DroidWeaponFire'
    FireModeClass(1)=Class'tk_StarWars.DroidWeaponFire'
    SelectAnim="Pickup"
    PutDownAnim="PutDown"
    SelectSound=Sound'WeaponSounds.FlakCannon.SwitchToFlakCannon'
    SelectForce="SwitchToFlakCannon"
    AIRating=0.750000
    CurrentRating=0.750000
    EffectOffset=(X=200.000000,Y=32.000000,Z=-25.000000)
    DisplayFOV=60.000000
    Priority=13
    InventoryGroup=7
    PlayerViewOffset=(X=-7.000000,Y=8.000000)
    PlayerViewPivot=(Yaw=16884,Roll=200)
    BobDamping=1.400000
    AttachmentClass=Class'tk_StarWars.DroidWeaponAttachment'
    ItemName="Droid Blaster"
    LightType=LT_Steady
    LightEffect=LE_NonIncidence
    LightHue=30
    LightSaturation=150
    LightBrightness=255.000000
    LightRadius=4.000000
    Mesh=SkeletalMesh'Weapons.LinkGun_1st'
    HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
}