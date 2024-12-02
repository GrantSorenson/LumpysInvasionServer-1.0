class RailgunPickup extends UTWeaponPickup;

defaultproperties
{
     StandUp=(Y=0.250000,Z=0.000000)
     MaxDesireability=0.630000
     InventoryType=Class'tk_FHIWeapons.Railgun'
     PickupMessage="You got the Particle Gun."
     PickupSound=Sound'tk_FHIWeapons.FHISnd.Phoenix_Pickup'
     PickupForce="ShockRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'NewWeaponPickups.LinkPickupSM'
     DrawScale=0.650000
     Skins(0)=Shader'tk_FHIWeapons.FHIShaders.RailgunShader'
}