class HolyHandGrenade extends tk_Weapon
     config(TKWeaponsClient);

#EXEC OBJ LOAD FILE="Resources/rs_HolyHandGrenade.u" PACKAGE="tk_HolyHandGrenade"

simulated function OutOfAmmo()
{
    SetDrawScale(0);
    super.OutOfAmmo();
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    SetDrawScale(default.DrawScale);
    super.BringUp(PrevWeapon);
}

defaultproperties
{
     FireModeClass(0)=Class'tk_HolyHandGrenade.HolyHandGrenadeFire'
     FireModeClass(1)=Class'tk_HolyHandGrenade.HolyHandGrenadeFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'tk_HolyHandGrenade.Hallelujah'
     AIRating=1.500000
     CurrentRating=1.500000
     Priority=9
     SmallViewOffset=(X=11.000000,Y=29.000000,Z=-11.000000)
     InventoryGroup=0
     GroupOffset=1
     PickupClass=Class'tk_HolyHandGrenade.HolyHandGrenadePickup'
     PlayerViewOffset=(X=11.000000,Y=29.000000,Z=-11.000000)
     BobDamping=1.700000
     AttachmentClass=Class'tk_HolyHandGrenade.HolyHandGrenadeAttach'
     IconMaterial=Texture'tk_HolyHandGrenade.HolyHandGrenadeIcon'
     IconCoords=(X1=50,Y1=13,X2=206,Y2=110)
     ItemName="Holy Hand Grenade"
     Mesh=SkeletalMesh'tk_HolyHandGrenade.HolyHandGrenadeAnimMesh'
     DrawScale=0.400000
}
