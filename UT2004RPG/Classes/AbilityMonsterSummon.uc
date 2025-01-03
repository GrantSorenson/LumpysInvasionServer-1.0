class AbilityMonsterSummon extends RPGAbility
	abstract;

static function bool AbilityIsAllowed(GameInfo Game, MutUT2004RPG RPGMut)
{
	//make sure invasion monsters get loaded
	if (DynamicLoadObject("SkaarjPack.Invasion", class'Class', true) == None)
		return false;

	return true;
}

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (Data.Attack < 75 || Data.Defense < 75)
		return 0;
	else if (CurrentLevel == 0)
		return 20;
	else
		return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local MonsterInv M;

	if (Other.Role != ROLE_Authority || Other.Controller == None || !Other.Controller.bIsPlayer)
		return;

	//remove old one, if it exists
	//might happen if player levels up this ability while still alive
	M = MonsterInv(Other.FindInventoryType(class'MonsterInv'));
	if (M != None)
	{
		if (M.AbilityLevel != AbilityLevel)
		{
			M.CurrentMonster.Pawn.Died(None, class'DamageType', vect(0,0,0));
			M.AbilityLevel = AbilityLevel;
			M.SpawnMonster(true);
		}
		return;
	}

	M = Other.spawn(class'MonsterInv', Other,,,rot(0,0,0));
	M.AbilityLevel = AbilityLevel;
	M.GiveTo(Other);
}

defaultproperties
{
     AbilityName="Monster Tongue"
     Description="With this ability, you can convince monsters to come to your aid. A monster will appear and follow you around, attacking any enemies it sees, and if it dies, another will eventually come to take its place. You will get the score and EXP for any of its kills. The level of the ability determines the type of monster that will assist you. Additionally, the monster will have the benefits of all of your stats and abilities except those which act on your death. You must have at least 75 Damage Bonus and 75 Damage Reduction to purchase this ability. (Max Level: 8)"
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=8
}
