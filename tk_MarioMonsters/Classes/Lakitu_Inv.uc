class Lakitu_Inv extends Inventory;

var() Pawn PawnMaster;

Replication
{
	reliable if(Role == Role_Authority)
		PawnMaster;
}

defaultproperties
{
     ItemName="LakituInv"
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
}
