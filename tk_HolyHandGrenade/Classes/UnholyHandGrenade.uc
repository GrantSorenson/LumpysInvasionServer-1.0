class UnholyHandGrenade extends HolyHandGrenade;

#EXEC OBJ LOAD FILE="Resources/rs_HolyHandGrenade.u" PACKAGE="tk_HolyHandGrenade"

defaultproperties
{
     FireModeClass(0)=Class'tk_HolyHandGrenade.UnholyHandGrenadeFire'
     FireModeClass(1)=Class'tk_HolyHandGrenade.UnholyHandGrenadeAltFire'
     SelectSound=Sound'tk_HolyHandGrenade.UnholyPickup'
     HudColor=(B=255,G=0,R=128)
     PickupClass=Class'tk_HolyHandGrenade.UnholyHandGrenadePickup'
     AttachmentClass=Class'tk_HolyHandGrenade.UnholyHandGrenadeAttach'
     ItemName="Unholy Hand Grenade"
     Skins(0)=Texture'tk_HolyHandGrenade.UnholyGrenade'
}
