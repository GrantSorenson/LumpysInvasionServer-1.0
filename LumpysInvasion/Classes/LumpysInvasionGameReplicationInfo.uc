class LumpysInvasionGameReplicationInfo extends InvasionGameReplicationInfo;

var() int CurrentMonstersNum;
var() color WaveDrawColour;

replication
{
    reliable if(Role == ROLE_Authority)
       CurrentMonstersNum, WaveDrawColour;
}
defaultproperties
{
    WaveDrawColour=(R=0,G=0,B=255,A=255)
}
