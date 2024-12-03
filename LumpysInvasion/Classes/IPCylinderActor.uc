class IPCylinderActor extends Actor placeable;

function Tick(float DeltaTime)
{
	if(Owner != None)
	{
		SetRotation(Owner.Rotation);
	}
}

defaultproperties
{
    DrawType=8
    StaticMesh=StaticMesh'2K4ChargerMeshes.WeaponChargerMesh-DS'
    RemoteRole=0
    Skins=
    AmbientGlow=60
    bUnlit=True
    bHardAttach=True
}
