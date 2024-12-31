class AbilityFeatherFall extends RPGAbility
	abstract;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	Other.MaxFallSpeed = Other.default.MaxFallSpeed * (1.0 + 0.05 * float(AbilityLevel));
}

static simulated function UnModifyPawn(Pawn Other, int AbilityLevel)
{
	Other.MaxFallSpeed = Other.default.MaxFallSpeed;
}

defaultproperties
{
	AbilityName="Boots of Feather Fall"
	Description="Ability Name: Boots of Feather Fall|Max Level: 20|Starting Cost: 50|Cost Add Per Level: 10|Requirements: None||This Ability grants the player the Boots of Feather Fall. These Enchanted boots increase the distance you can safely fall by 5% per level."
	StartingCost=15
	CostAddPerLevel=5
	MaxLevel=20
}