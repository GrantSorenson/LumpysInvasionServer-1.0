class IPMonsterReplicationInfo extends ReplicationInfo;

var() string MonsterClassName[500];
var() string MonsterName[500];
var() float MonsterGibSize[500];
var() int MonsterGibCount[500];

var() string BossMonsterName[500];
var() float BossMonsterGibSize[500];
var() float BossMonsterGibCount[500];

replication
{
    reliable if(Role == ROLE_Authority)
    	MonsterClassName, MonsterGibSize, MonsterGibCount, MonsterName, BossMonsterName, BossMonsterGibSize, BossMonsterGibCount;
}

simulated function AddMonsterInfo(int Pos, string MName, string MClassName, float MSize, float MCount)
{
	MonsterName[Pos] = MName;
	MonsterClassName[Pos] = MClassName;
	MonsterGibSize[Pos] = MSize;
	MonsterGibCount[Pos] = Round(MCount);
}

simulated function AddBossInfo(int Pos, string BName, float BSize, float BCount)
{
	BossMonsterName[Pos] = BName;
	BossMonsterGibSize[Pos] = BSize;
	BossMonsterGibCount[Pos] = Round(BCount);
}

simulated function string GetMonsterClassName(int Pos)
{
	return MonsterClassName[Pos];
}

simulated function float GetGibSize(string MClass, bool bBoss)
{
	local int i;
	local string MonsterMatch;

	if(bBoss)
	{
		for(i=0;i<500;i++)
		{
			if(MonsterClassName[i] ~= MClass)
			{
				MonsterMatch = MonsterName[i];
				break;
			}
		}

		for(i=0;i<500;i++)
		{
			if(BossMonsterName[i] ~= MonsterMatch)
			{
				return BossMonsterGibSize[i];
			}
		}
	}

	for(i=0;i<500;i++)
	{
		if(MonsterClassName[i] ~= MClass)
		{
			return MonsterGibSize[i];
		}
	}

	return 1.00;
}

simulated function int GetGibCount(string MClass, bool bBoss)
{
	local int i;
	local string MonsterMatch;

	if(bBoss)
	{
		for(i=0;i<500;i++)
		{
			if(MonsterClassName[i] ~= MClass)
			{
				MonsterMatch = MonsterName[i];
				break;
			}
		}

		for(i=0;i<500;i++)
		{
			if(BossMonsterName[i] ~= MonsterMatch)
			{
				return BossMonsterGibCount[i];
			}
		}
	}

	for(i=0;i<500;i++)
	{
		if(MonsterClassName[i] ~= MClass)
		{
			return MonsterGibCount[i];
		}
	}

	return 1;
}

simulated function int GetLength()
{
	local int i;

	for(i=0;i<500;i++)
	{
		if(MonsterClassName[i] ~= "")
		{
			return i;
		}
	}

	return 1;
}

defaultproperties
{
}
