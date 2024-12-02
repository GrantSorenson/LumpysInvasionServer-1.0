class MP5GrenadeAmmo extends GrenadeAmmo config(ZEnMP5);

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
    clientMAxAmmo=10
    MaxAmmo=10
    PickupAmmo=4
    PickupClass=Class'MP5AmmoPickup'
    ItemName="MP5 Grenade Ammo"
}
