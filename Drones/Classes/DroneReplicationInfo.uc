class DroneReplicationInfo extends ReplicationInfo;

var PlayerReplicationInfo PRI;
var int numDrones;

replication
{
	reliable if(bNetInitial && Role==ROLE_Authority)
		PRI;
	reliable if(Role==ROLE_Authority)
		numDrones;
}

simulated function PostBeginPlay()
{
	if(Pawn(Owner) != None)
		PRI = Pawn(Owner).PlayerReplicationInfo;
}
defaultproperties
{
}
