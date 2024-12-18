class AbilityTestTelek extends RPGAbility
    abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local TestTelekInv R;
	local Inventory Inv;

	if (Other.Role != ROLE_Authority)
		return;

	//remove old one, if it exists
	//might happen if player levels up this ability while still alive
	Inv = Other.FindInventoryType(class'TestTelekInv');
	if (Inv != None)
		Inv.Destroy();

	R = Other.spawn(class'TestTelekInv', Other,,,rot(0,0,0));
    R.OwnerAbilityLevel = AbilityLevel;
	R.GiveTo(Other);
}


defaultproperties
{
    AbilityName="Test Telek"
	Description="Test Telek for MM Improvements"
	StartingCost=1
	CostAddPerLevel=1
	MaxLevel=10
	BotChance=0 //this ability is useless to bots
}