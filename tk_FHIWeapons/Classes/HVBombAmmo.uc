class HVBombAmmo extends Ammunition;

event Tick(float Deltatime)
{
	Super.Tick(Deltatime);

	MaxAmmo = 12;
}

defaultproperties
{
     MaxAmmo=12
     InitialAmount=6
     PickupClass=Class'tk_FHIWeapons.HVAssaultAmmoPickup'
     ItemName="AG Bombs"
     bNetNotify=True
}