class IPDefaultWaves extends Object;

struct WaveInfo
{
	var() bool bBossWave;
	var() bool bBossesSpawnTogether;
	var() string BossID;
	var() int FallbackBossID;
	var() int BossTimeLimit;
	var() int BossOverTimeDamage;
	var() string WaveName;
	var() color WaveDrawColour;
	var() int WaveDuration;
	var() float WaveDifficulty;
	var() int WaveMaxMonsters;
	var() int MaxMonsters;
	var() int MaxLives;
	var() string Monsters[30];
	var() string WaveFallbackMonster;
};

var() array<WaveInfo> Waves;

defaultproperties
{
Waves(0)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Slow and Steady",WaveDrawColour=(B=255,G=255,R=255,A=255),WaveDuration=60,WaveDifficulty=0.250000,WaveMaxMonsters=90,MaxMonsters=35,MaxLives=1,Monsters[0]="Pupae",Monsters[1]="Razor Fly",Monsters[2]="Super Mario Angry Sun",Monsters[3]="Super Mario Blooper",Monsters[4]="Super Mario Boo",Monsters[5]="Super Mario Bob Omb",Monsters[6]="Super Mario Bullet Bill",Monsters[7]="Super Mario Goomba",Monsters[8]="Super Mario Hammer Bro",Monsters[9]="Super Mario Koopa",Monsters[10]="Super Mario Piranha Plant",Monsters[11]="Super Mario Pokey",Monsters[12]="Super Mario Spiny",Monsters[13]="Super Mario Thwomp",Monsters[14]="Super Mario Lakitu",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(1)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 2",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=0.350000,WaveMaxMonsters=10,MaxMonsters=6,MaxLives=1,Monsters[0]="Pupae",Monsters[1]="Krall",Monsters[2]="Manta",Monsters[3]="Razor Fly",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(2)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 3",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=0.450000,WaveMaxMonsters=10,MaxMonsters=6,MaxLives=1,Monsters[0]="Razor Fly",Monsters[1]="Krall",Monsters[2]="Elite Krall",Monsters[3]="Pupae",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(3)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 4",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=0.540000,WaveMaxMonsters=10,MaxMonsters=6,MaxLives=1,Monsters[0]="Gasbag",Monsters[1]="Pupae",Monsters[2]="Manta",Monsters[3]="Krall",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(4)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 5",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=0.620000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Manta",Monsters[1]="Krall",Monsters[2]="Skaarj",Monsters[3]="Pupae",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(5)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 6",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=0.750000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Skaarj",Monsters[1]="Gasbag",Monsters[2]="Krall",Monsters[3]="Razor Fly",Monsters[4]="Ice Skaarj",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(6)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 7",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=0.840000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Elite Krall",Monsters[1]="Gasbag",Monsters[2]="Razor Fly",Monsters[3]="Skaarj",Monsters[4]="Fire Skaarj",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(7)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 8",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=0.970000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Fire Skaarj",Monsters[1]="Ice Skaarj",Monsters[2]="Skaarj",Monsters[3]="None",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(8)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=320,BossOverTimeDamage=5,WaveName="Wave 9",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.110000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Brute",Monsters[1]="Pupae",Monsters[2]="Gasbag",Monsters[3]="None",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(9)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName="Wave 10",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.140000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Krall",Monsters[1]="Brute",Monsters[2]="Skaarj",Monsters[3]="Elite Krall",Monsters[4]="Ice Skaarj",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(10)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName="Wave 11",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.230000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Brute",Monsters[1]="Behemoth",Monsters[2]="Skaarj",Monsters[3]="Krall",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(11)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName="Wave 12",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.350000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Elite Krall",Monsters[1]="Skaarj",Monsters[2]="Gasbag",Monsters[3]="Behemoth",Monsters[4]="Brute",Monsters[5]="Ice Skaarj",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(12)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName="Wave 13",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.460000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Behemoth",Monsters[1]="Brute",Monsters[2]="Fire Skaarj",Monsters[3]="Ice Skaarj",Monsters[4]="Skaarj",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(13)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName="Wave 14",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.600000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Krall",Monsters[1]="Elite Krall",Monsters[2]="Gasbag",Monsters[3]="Brute",Monsters[4]="Behemoth",Monsters[5]="Behemoth",Monsters[6]="Brute",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(14)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName="Wave 15",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.840000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="Pupae",Monsters[1]="Razor Fly",Monsters[2]="Manta",Monsters[3]="Krall",Monsters[4]="Elite Krall",Monsters[5]="Gasbag",Monsters[6]="Brute",Monsters[7]="Skaarj",Monsters[8]="Behemoth",Monsters[9]="Ice Skaarj",Monsters[10]="Fire Skaarj",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(15)=(bBossWave=False,bBossesSpawnTogether=False,BossID="0",FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName="Wave 16",WaveDrawColour=(B=255,G=0,R=0,A=255),WaveDuration=90,WaveDifficulty=1.910000,WaveMaxMonsters=25,MaxMonsters=8,MaxLives=1,Monsters[0]="WarLord",Monsters[1]="None",Monsters[2]="None",Monsters[3]="None",Monsters[4]="None",Monsters[5]="None",Monsters[6]="None",Monsters[7]="None",Monsters[8]="None",Monsters[9]="None",Monsters[10]="None",Monsters[11]="None",Monsters[12]="None",Monsters[13]="None",Monsters[14]="None",Monsters[15]="None",Monsters[16]="None",Monsters[17]="None",Monsters[18]="None",Monsters[19]="None",Monsters[20]="None",Monsters[21]="None",Monsters[22]="None",Monsters[23]="None",Monsters[24]="None",Monsters[25]="None",Monsters[26]="None",Monsters[27]="None",Monsters[28]="None",Monsters[29]="None",WaveFallbackMonster="Pupae")
Waves(16)=(bBossWave=False,bBossesSpawnTogether=False,BossID=,FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName=,WaveDrawColour=(B=0,G=0,R=0,A=0),WaveDuration=0,WaveDifficulty=0.000000,WaveMaxMonsters=0,MaxMonsters=0,MaxLives=0,Monsters[0]=,Monsters[1]=,Monsters[2]=,Monsters[3]=,Monsters[4]=,Monsters[5]=,Monsters[6]=,Monsters[7]=,Monsters[8]=,Monsters[9]=,Monsters[10]=,Monsters[11]=,Monsters[12]=,Monsters[13]=,Monsters[14]=,Monsters[15]=,Monsters[16]=,Monsters[17]=,Monsters[18]=,Monsters[19]=,Monsters[20]=,Monsters[21]=,Monsters[22]=,Monsters[23]=,Monsters[24]=,Monsters[25]=,Monsters[26]=,Monsters[27]=,Monsters[28]=,Monsters[29]=,WaveFallbackMonster=)
Waves(17)=(bBossWave=False,bBossesSpawnTogether=False,BossID=,FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName=,WaveDrawColour=(B=0,G=0,R=0,A=0),WaveDuration=0,WaveDifficulty=0.000000,WaveMaxMonsters=0,MaxMonsters=0,MaxLives=0,Monsters[0]=,Monsters[1]=,Monsters[2]=,Monsters[3]=,Monsters[4]=,Monsters[5]=,Monsters[6]=,Monsters[7]=,Monsters[8]=,Monsters[9]=,Monsters[10]=,Monsters[11]=,Monsters[12]=,Monsters[13]=,Monsters[14]=,Monsters[15]=,Monsters[16]=,Monsters[17]=,Monsters[18]=,Monsters[19]=,Monsters[20]=,Monsters[21]=,Monsters[22]=,Monsters[23]=,Monsters[24]=,Monsters[25]=,Monsters[26]=,Monsters[27]=,Monsters[28]=,Monsters[29]=,WaveFallbackMonster=)
Waves(18)=(bBossWave=False,bBossesSpawnTogether=False,BossID=,FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName=,WaveDrawColour=(B=0,G=0,R=0,A=0),WaveDuration=0,WaveDifficulty=0.000000,WaveMaxMonsters=0,MaxMonsters=0,MaxLives=0,Monsters[0]=,Monsters[1]=,Monsters[2]=,Monsters[3]=,Monsters[4]=,Monsters[5]=,Monsters[6]=,Monsters[7]=,Monsters[8]=,Monsters[9]=,Monsters[10]=,Monsters[11]=,Monsters[12]=,Monsters[13]=,Monsters[14]=,Monsters[15]=,Monsters[16]=,Monsters[17]=,Monsters[18]=,Monsters[19]=,Monsters[20]=,Monsters[21]=,Monsters[22]=,Monsters[23]=,Monsters[24]=,Monsters[25]=,Monsters[26]=,Monsters[27]=,Monsters[28]=,Monsters[29]=,WaveFallbackMonster=)
Waves(19)=(bBossWave=False,bBossesSpawnTogether=False,BossID=,FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName=,WaveDrawColour=(B=0,G=0,R=0,A=0),WaveDuration=0,WaveDifficulty=0.000000,WaveMaxMonsters=0,MaxMonsters=0,MaxLives=0,Monsters[0]=,Monsters[1]=,Monsters[2]=,Monsters[3]=,Monsters[4]=,Monsters[5]=,Monsters[6]=,Monsters[7]=,Monsters[8]=,Monsters[9]=,Monsters[10]=,Monsters[11]=,Monsters[12]=,Monsters[13]=,Monsters[14]=,Monsters[15]=,Monsters[16]=,Monsters[17]=,Monsters[18]=,Monsters[19]=,Monsters[20]=,Monsters[21]=,Monsters[22]=,Monsters[23]=,Monsters[24]=,Monsters[25]=,Monsters[26]=,Monsters[27]=,Monsters[28]=,Monsters[29]=,WaveFallbackMonster=)
Waves(20)=(bBossWave=False,bBossesSpawnTogether=False,BossID=,FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName=,WaveDrawColour=(B=0,G=0,R=0,A=0),WaveDuration=0,WaveDifficulty=0.000000,WaveMaxMonsters=0,MaxMonsters=0,MaxLives=0,Monsters[0]=,Monsters[1]=,Monsters[2]=,Monsters[3]=,Monsters[4]=,Monsters[5]=,Monsters[6]=,Monsters[7]=,Monsters[8]=,Monsters[9]=,Monsters[10]=,Monsters[11]=,Monsters[12]=,Monsters[13]=,Monsters[14]=,Monsters[15]=,Monsters[16]=,Monsters[17]=,Monsters[18]=,Monsters[19]=,Monsters[20]=,Monsters[21]=,Monsters[22]=,Monsters[23]=,Monsters[24]=,Monsters[25]=,Monsters[26]=,Monsters[27]=,Monsters[28]=,Monsters[29]=,WaveFallbackMonster=)
Waves(21)=(bBossWave=False,bBossesSpawnTogether=False,BossID=,FallbackBossID=0,BossTimeLimit=0,BossOverTimeDamage=0,WaveName=,WaveDrawColour=(B=0,G=0,R=0,A=0),WaveDuration=0,WaveDifficulty=0.000000,WaveMaxMonsters=0,MaxMonsters=0,MaxLives=0,Monsters[0]=,Monsters[1]=,Monsters[2]=,Monsters[3]=,Monsters[4]=,Monsters[5]=,Monsters[6]=,Monsters[7]=,Monsters[8]=,Monsters[9]=,Monsters[10]=,Monsters[11]=,Monsters[12]=,Monsters[13]=,Monsters[14]=,Monsters[15]=,Monsters[16]=,Monsters[17]=,Monsters[18]=,Monsters[19]=,Monsters[20]=,Monsters[21]=,Monsters[22]=,Monsters[23]=,Monsters[24]=,Monsters[25]=,Monsters[26]=,Monsters[27]=,Monsters[28]=,Monsters[29]=,WaveFallbackMonster=)
}
