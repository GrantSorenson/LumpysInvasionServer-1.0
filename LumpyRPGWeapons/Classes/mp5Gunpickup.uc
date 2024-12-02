//=============================================================================
// MP5Pickup.
//=============================================================================

#exec OBJ LOAD FILE=ZWeaponsTextures2.uTx

class MP5GunPickup extends AssaultRiflePickup
	placeable;

defaultproperties
{
    MaxDesireability=0.80
    InventoryType=Class'mp5Gun'
    PickupMessage="You got the MP5"
    StaticMesh=StaticMesh'ZWeaponsStatic2004.mp5pickup'
    DrawScale=2.70
}
