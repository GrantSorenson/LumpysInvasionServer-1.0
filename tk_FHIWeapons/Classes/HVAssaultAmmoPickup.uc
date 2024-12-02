class HVAssaultAmmoPickup extends UTAmmoPickup;

defaultproperties
{
     AmmoAmount=6
     InventoryType=Class'tk_FHIWeapons.HVBombAmmo'
     PickupMessage="You got a box of AG Bombs and HV bullets."
     PickupSound=Sound'PickupSounds.AssaultAmmoPickup'
     PickupForce="AssaultAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.AssaultAmmoPickup'
     TransientSoundVolume=0.400000
     CollisionHeight=12.500000
}