class IPMonsterTable extends Object config(IPSettings);

struct MonsterNames
{
	var() bool bSetup;
	var() string MonsterName;
	var() string MonsterClassName;
	var() int NumSpawns;
	var() int NumDamage;
	var() int NumKills;
	var() int NewHealth;
	var() int NewMaxHealth;
	var() float NewGroundSpeed;
	var() float NewAirSpeed;
	var() float NewWaterSpeed;
	var() float NewJumpZ;
	var() int NewScoreAward;
	var() float NewGibMultiplier;
	var() float NewGibSizeMultiplier;
	var() float NewDrawScale;
	var() float NewCollisionHeight;
	var() float NewCollisionRadius;
	var() vector NewPrePivot;
	var() float DamageMultiplier;
	var() bool bRandomHealth;
	var() bool bRandomSpeed;
	var() bool bRandomSize;
	var() string CurrentSkin;
};

var() config Array<MonsterNames> MonsterTable;

struct TacticalData
{
	var() string MonsterName;
	var() string BioData;
};

var() config Array<TacticalData> MonsterDescription;

defaultproperties
{
MonsterTable(0)=(bSetup=True,MonsterName="None",MonsterClassName="None",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=0,NewMaxHealth=0,NewGroundSpeed=0.00,NewAirSpeed=0.00,NewWaterSpeed=0.00,NewJumpZ=0.00,NewScoreAward=0,NewGibMultiplier=0.00,NewGibSizeMultiplier=0.00,NewDrawScale=0.00,NewCollisionHeight=0.00,NewCollisionRadius=0.00,NewPrePivot=(X=0.00,Y=0.00,Z=0.00),DamageMultiplier=0.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin="None")
MonsterTable(1)=(bSetup=True,MonsterName="Pupae",MonsterClassName="SkaarjPack.SkaarjPupae",NumSpawns=177,NumDamage=128,NumKills=15,NewHealth=60,NewMaxHealth=100,NewGroundSpeed=300.00,NewAirSpeed=440.00,NewWaterSpeed=300.00,NewJumpZ=450.00,NewScoreAward=1,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=12.00,NewCollisionRadius=28.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin="Texture'SkaarjPackSkins.Skins.JPupae1'")
MonsterTable(2)=(bSetup=True,MonsterName="Razor Fly",MonsterClassName="SkaarjPack.Razorfly",NumSpawns=165,NumDamage=60,NumKills=7,NewHealth=35,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=300.00,NewWaterSpeed=220.00,NewJumpZ=340.00,NewScoreAward=1,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=11.00,NewCollisionRadius=18.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(3)=(bSetup=True,MonsterName="Manta",MonsterClassName="SkaarjPack.Manta",NumSpawns=134,NumDamage=260,NumKills=11,NewHealth=100,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=400.00,NewWaterSpeed=300.00,NewJumpZ=340.00,NewScoreAward=1,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=12.00,NewCollisionRadius=25.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(4)=(bSetup=True,MonsterName="Krall",MonsterClassName="SkaarjPack.Krall",NumSpawns=45,NumDamage=175,NumKills=6,NewHealth=100,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=440.00,NewWaterSpeed=220.00,NewJumpZ=550.00,NewScoreAward=2,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=44.00,NewCollisionRadius=25.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(5)=(bSetup=True,MonsterName="Elite Krall",MonsterClassName="SkaarjPack.EliteKrall",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=100,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=440.00,NewWaterSpeed=220.00,NewJumpZ=550.00,NewScoreAward=3,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=44.00,NewCollisionRadius=25.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(6)=(bSetup=True,MonsterName="Gasbag",MonsterClassName="SkaarjPack.Gasbag",NumSpawns=10,NumDamage=126,NumKills=0,NewHealth=150,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=330.00,NewWaterSpeed=220.00,NewJumpZ=340.00,NewScoreAward=4,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=36.00,NewCollisionRadius=47.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(7)=(bSetup=True,MonsterName="Brute",MonsterClassName="SkaarjPack.Brute",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=220,NewMaxHealth=100,NewGroundSpeed=150.00,NewAirSpeed=440.00,NewWaterSpeed=100.00,NewJumpZ=100.00,NewScoreAward=5,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=52.00,NewCollisionRadius=47.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(8)=(bSetup=True,MonsterName="Skaarj",MonsterClassName="SkaarjPack.Skaarj",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=150,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=440.00,NewWaterSpeed=220.00,NewJumpZ=550.00,NewScoreAward=6,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=44.00,NewCollisionRadius=25.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(9)=(bSetup=True,MonsterName="Behemoth",MonsterClassName="SkaarjPack.Behemoth",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=260,NewMaxHealth=100,NewGroundSpeed=150.00,NewAirSpeed=440.00,NewWaterSpeed=100.00,NewJumpZ=100.00,NewScoreAward=6,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=52.00,NewCollisionRadius=47.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(10)=(bSetup=True,MonsterName="Ice Skaarj",MonsterClassName="SkaarjPack.IceSkaarj",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=150,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=440.00,NewWaterSpeed=220.00,NewJumpZ=550.00,NewScoreAward=6,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=44.00,NewCollisionRadius=25.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(11)=(bSetup=True,MonsterName="Fire Skaarj",MonsterClassName="SkaarjPack.FireSkaarj",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=150,NewMaxHealth=100,NewGroundSpeed=440.00,NewAirSpeed=440.00,NewWaterSpeed=220.00,NewJumpZ=550.00,NewScoreAward=7,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=44.00,NewCollisionRadius=25.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)
MonsterTable(12)=(bSetup=True,MonsterName="WarLord",MonsterClassName="SkaarjPack.WarLord",NumSpawns=0,NumDamage=0,NumKills=0,NewHealth=500,NewMaxHealth=100,NewGroundSpeed=400.00,NewAirSpeed=500.00,NewWaterSpeed=220.00,NewJumpZ=340.00,NewScoreAward=10,NewGibMultiplier=1.00,NewGibSizeMultiplier=1.00,NewDrawScale=1.00,NewCollisionHeight=78.00,NewCollisionRadius=47.00,NewPrePivot=(X=0.00,Y=0.00,Z=-5.00),DamageMultiplier=1.00,bRandomHealth=False,bRandomSpeed=False,bRandomSize=False,CurrentSkin=)

MonsterDescription(0)=(MonsterName="None",BioData="No Data Found")
MonsterDescription(1)=(MonsterName="Pupae",BioData="The Pupae is a relatively slow moving monster. It causes minimal damage but due to its small size, is able to go where most other monsters cannot.")
MonsterDescription[2]=(MonsterName="Razor Fly",BioData="This flying monster is slow moving. The low damage this monster causes is not significant enough to be worth considered an immediate threat.")
MonsterDescription[3]=(MonsterName="Manta",BioData="This graceful flying monster moves at a medium speed. It is melee only.",)
MonsterDescription[4]=(MonsterName="Krall",BioData="The primitive Krall have only melee attacks but they are very determined. Even losing legs wont stop them!")
MonsterDescription[5]=(MonsterName="Elite Krall",BioData="The elite version of the Krall carries a magic wand that it uses to shoot magic at its enemies.")
MonsterDescription[6]=(MonsterName="Gasbag",BioData="The Gasbag floats lazily around and although it does have melee attacks it prefers to attack from afar.")
MonsterDescription[7]=(MonsterName="Brute",BioData="The Brute is big, slow and mean. Its twin rocket launchers can cause massive damage in a short time.")
MonsterDescription[8]=(MonsterName="Skaarj",BioData="The Skaarj, the main infantry of all the monsters. They are agile and fast. However their magic can be reflected with the Shield Gun.")
MonsterDescription[9]=(MonsterName="Behemoth",BioData="The Behemoth is even bigger and badder and slower than the Brute.",)
MonsterDescription[10]=(MonsterName="Ice Skaarj",BioData="The Ice Skaarj prefers a cold habitat and is slightly more dangerous than the normal Skaarj.")
MonsterDescription[11]=(MonsterName="Fire Skaarj",BioData="The Fire Skaarj prefers a warmer habitat and is even more dangerous than the Ice Skaarj.")
MonsterDescription[12]=(MonsterName="WarLord",BioData="The boss of all the other monsters, the Warlord is very dangerous, especially when roaming in packs. They have both ranged and melee attacks and can even fly.")
}
