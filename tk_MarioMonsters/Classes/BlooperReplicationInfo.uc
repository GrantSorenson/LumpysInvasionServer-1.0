class BlooperReplicationInfo extends ReplicationInfo;

var() float Inkduration;
var() float InkFadeStart;

replication
{
    reliable if(Role == ROLE_Authority)
        Inkduration;
}

defaultproperties
{
     Inkduration=1.000000
     InkFadeStart=3.000000
}
