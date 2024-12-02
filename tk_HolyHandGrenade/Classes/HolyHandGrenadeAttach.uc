class HolyHandGrenadeAttach extends xWeaponAttachment;

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
    SetRelativeRotation(rot(32768,0,0));
    SetRelativeLocation(vect(-40,0,-8));
}

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_HolyHandGrenade.HolyHandGrenadeProjMesh'
}
