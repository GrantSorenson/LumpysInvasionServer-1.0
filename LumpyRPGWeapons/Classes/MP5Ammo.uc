class MP5Ammo extends Ammunition config(ZEnMP5);

var config int clientMAxAmmo;

replication
{
reliable if (role == role_Authority)
	clientMAxAmmo;
}

simulated function PostNetBeginPlay()
{
		MaxAmmo = clientMAxAmmo;

	super.PostNetBeginPlay();
}

defaultproperties
{
    clientMAxAmmo=90
    MaxAmmo=90
    InitialAmount=30
    PickupAmmo=30
    PickupClass=Class'MP5AmmoPickup'
    IconMaterial=Texture'HUDContent.Generic.HUD'  
    ItemName="MP5 or Minigun Ammo"
}
