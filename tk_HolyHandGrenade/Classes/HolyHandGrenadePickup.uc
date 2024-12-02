class HolyHandGrenadePickup extends UTWeaponPickup;

function SetWeaponStay()
{
	bWeaponStay = false;
}

function float GetRespawnTime()
{
	return ReSpawnTime;
}

defaultproperties
{
	MaxDesireability=1.000000
	InventoryType=Class'tk_HolyHandGrenade.HolyHandGrenade'
	RespawnTime=90.000000
    PickupMessage="You got the Holy Hand Grenade of Antioch."
    PickupForce="RocketLauncherPickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'tk_HolyHandGrenade.HolyHandGrenadePickupMesh'
    DrawScale=0.400000
    AmbientGlow=48
}