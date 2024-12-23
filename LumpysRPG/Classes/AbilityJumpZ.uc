class AbilityJumpZ extends RPGAbility
	abstract;

var int MultiJumpCount, MultiJumpBoost;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (Data.Level < 10 * (CurrentLevel + 1))
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local xPawn x; //x is a variable
	x = xPawn(Other); 
	if (x != None)
	{
		x.MaxMultiJump = default.MultiJumpCount;
		x.MultiJumpBoost = default.MultiJumpBoost;
	}
	Other.JumpZ = Other.default.JumpZ * (1.0 + 0.1 * float(AbilityLevel));
}

defaultproperties
{
	MultiJumpCount=5
	MultiJumpBoost=50
	AbilityName="Power Jump"
	Description="Increases your jumping height by 10% per level. The Speed adrenaline combo will stack with this effect. You must be a Level equal to ten times the ability level you wish to have before you can purchase it. (Max Level: 3)"
	StartingCost=15
	CostAddPerLevel=5
	MaxLevel=3
}
