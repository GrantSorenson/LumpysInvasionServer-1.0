class LumpysInvasionGameReplicationInfo extends InvasionGameReplicationInfo;

var() int CurrentMonstersNum;
var() color WaveDrawColour;
var() Monster FriendlyMonsters[32]; //list of friendly monsters
var() string PlayerNames[32];
var() int Playerlives[32];
var() bool bBossEncounter;
var() float BossTimeLimit;
var() bool bOverTime;
var() bool bInfiniteBossTime;




replication
{
    reliable if(Role == ROLE_Authority)
       CurrentMonstersNum, WaveDrawColour, FriendlyMonsters, PlayerLives, PlayerNames,bBossEncounter,BossTimeLimit,bOverTime,bInfiniteBossTime;
}

simulated function AddFriendlyMonster(Monster M)
{
	local int i;

	for(i=0;i<32;i++)
	{
		if(FriendlyMonsters[i] == None)
		{
			FriendlyMonsters[i] = M;
			break;
		}
	}
}

simulated function RemoveFriendlyMonster(Monster M)
{
	local int i;

	for(i=0;i<32;i++)
	{
		if(FriendlyMonsters[i] == M)
		{
			FriendlyMonsters[i] = None;
			break;
		}
	}
}

defaultproperties
{
    WaveDrawColour=(R=0,G=0,B=255,A=255)
}
