class SC_Pickup extends UTWeaponPickup;

function PrebeginPlay()
{
	Super.PreBeginPlay();
	if ( Level.Game.IsA('xMutantGame') )
		Destroy();
}

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
     StandUp=(Y=0.250000,Z=0.000000)
     bWeaponStay=False
     MaxDesireability=1.000000
     InventoryType=Class'tk_FHIWeapons.SingularityCannon'
     RespawnTime=60.000000
     PickupMessage="You got the Singularity Cannon."
     PickupSound=Sound'tk_FHIWeapons.FHISnd.Sing_Pickup'
     PickupForce="FlakCannonPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_FHIWeapons.FHIMesh.SCannonMesh'
     DrawScale=0.800000
}
