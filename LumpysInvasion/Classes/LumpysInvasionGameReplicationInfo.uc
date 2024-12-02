class LumpysInvasionGameReplicationInfo extends InvasionGameReplicationInfo;

var() int CurrentMonstersNum;

replication
{
    reliable if(Role == ROLE_Authority)
       CurrentMonstersNum;
}
defaultproperties
{

}
