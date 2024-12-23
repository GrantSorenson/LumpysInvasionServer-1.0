class LumpysInvasionGameReplicationInfo extends InvasionGameReplicationInfo;

var() int CurrentMonstersNum;
var() color WaveDrawColour;
var() Monster FriendlyMonsters[32]; //list of friendly monsters
var() string PlayerNames[32];
var() int Playerlives[32];

replication
{
    reliable if(Role == ROLE_Authority)
       CurrentMonstersNum, WaveDrawColour, FriendlyMonsters, PlayerLives, PlayerNames;
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
