//RPGPlayerDataObject is used for saving player data. Using PerObjectConfig objects over arrays of structs is faster
//because native code can do the name search. Additionally, structs have a 1024 character limit when converted
//to text for .ini saving, which is not an issue for objects since they are not stored on one line.
class RPGPlayerDataObject extends Object
	config(LumpyRPG)
	PerObjectConfig;

//Player name is the object name
var config string OwnerID; //unique PlayerID of person who owns this name ("Bot" for bots)

var config int Level, Experience, WeaponSpeed, HealthBonus, AdrenalineMax, Attack, Defense, AmmoMax,
	       PointsAvailable, NeededExp, Credits, Stacks, Gold, ClassPoints;
var config float ExperienceFraction; // when player gets EXP less than a full point, it gets added up here until it's >= 1.0

//these two should really be a struct but can't be since they need to be able to be put into RPGPlayerData struct
//and structs inside structs are not supported
var config array<class<RPGAbility> > Abilities;
var config array<class<RPGClass> > ClassAbilities;
var config array<int> AbilityLevels;
var config array<int> ClassLevels;

//AI related
var config class<RPGAbility> BotAbilityGoal; //Bot is saving points towards this ability
var config int BotGoalAbilityCurrentLevel; //Bot's current level in the ability it wants (so don't have to search for it)

//This struct is used for the data when it needs to be replicated, since an Object cannot be
struct RPGPlayerData
{
	var int Level, Experience, WeaponSpeed, HealthBonus, AdrenalineMax;
	var int Attack, Defense, AmmoMax, PointsAvailable, NeededExp, ClassPoints;
	var int Credits, Stacks, Gold;
	var array<class<RPGAbility> > Abilities;
	var array<class<RPGClass> > ClassAbilities;
	var array<int> AbilityLevels;
	var array<int> ClassLevels;
};

//adds a fractional amount of EXP
//the mutator and our owner's PRI are passed in for calling CheckLevelUp() if we've reached a whole number
function AddExperienceFraction(float Amount, MutLumpysRPG RPGMut, PlayerReplicationInfo MessagePRI)
{
	ExperienceFraction += Amount;
	if (Abs(ExperienceFraction) >= 1.0)
	{
		Experience += int(ExperienceFraction);
		ExperienceFraction -= int(ExperienceFraction);
		RPGMut.CheckLevelUp(self, MessagePRI);
	}
}

function CreateDataStruct(out RPGPlayerData Data, bool bOnlyEXP)
{
	Data.Level = Level;
	Data.Experience = Experience;
	Data.NeededExp = NeededExp;
	Data.PointsAvailable = PointsAvailable;
	Data.ClassPoints = ClassPoints;
	if (bOnlyEXP)
		return;

	Data.WeaponSpeed = WeaponSpeed;
	Data.HealthBonus = HealthBonus;
	Data.AdrenalineMax = AdrenalineMax;
	Data.Attack = Attack;
	Data.Defense = Defense;
	Data.AmmoMax = AmmoMax;
	Data.Abilities = Abilities;
	Data.ClassAbilities = ClassAbilities;
	Data.AbilityLevels = AbilityLevels;
	Data.ClassLevels = ClassLevels;
	Data.Credits = Credits;
	Data.Stacks=Stacks;
	Data.Gold=Gold;
}

function InitFromDataStruct(RPGPlayerData Data)
{
	Level = Data.Level;
	Experience = Data.Experience;
	NeededExp = Data.NeededExp;
	PointsAvailable = Data.PointsAvailable;
	ClassPoints = Data.ClassPoints;
	WeaponSpeed = Data.WeaponSpeed;
	HealthBonus = Data.HealthBonus;
	AdrenalineMax = Data.AdrenalineMax;
	Attack = Data.Attack;
	Defense = Data.Defense;
	AmmoMax = Data.AmmoMax;
	Abilities = Data.Abilities;
	ClassAbilities = Data.ClassAbilities;
	AbilityLevels = Data.AbilityLevels;
	ClassLevels = Data.ClassLevels;
	Credits=Data.Credits;
	Stacks=Data.Stacks;
	Gold=Data.Gold;

}

function CopyDataFrom(RPGPlayerDataObject DataObject)
{
	OwnerID = DataObject.OwnerID;
	Level = DataObject.Level;
	Experience = DataObject.Experience;
	NeededExp = DataObject.NeededExp;
	PointsAvailable = DataObject.PointsAvailable;
	ClassPoints = DataObject.ClassPoints;
	WeaponSpeed = DataObject.WeaponSpeed;
	HealthBonus = DataObject.HealthBonus;
	AdrenalineMax = DataObject.AdrenalineMax;
	Attack = DataObject.Attack;
	Defense = DataObject.Defense;
	AmmoMax = DataObject.AmmoMax;
	Abilities = DataObject.Abilities;
	ClassAbilities = DataObject.ClassAbilities;
	AbilityLevels = DataObject.AbilityLevels;
	ClassLevels = DataObject.ClassLevels;
	Credits = DataObject.Credits;
	Stacks=DataObject.Stacks;
	Gold=DataObject.Gold;
	BotAbilityGoal = DataObject.BotAbilityGoal;
	BotGoalAbilityCurrentLevel = DataObject.BotGoalAbilityCurrentLevel;
}

defaultproperties
{
}
