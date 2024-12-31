class AbilityShieldUpgrade extends RPGAbility
	abstract;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	if (xPawn(Other) != none)
		xPawn(Other).ShieldStrengthMax = xPawn(Other).default.ShieldStrengthMax + 25 * AbilityLevel;
}

static simulated function UnModifyPawn(Pawn Other, int AbilityLevel)
{
	if (xPawn(Other) != none)
		xPawn(Other).ShieldStrengthMax = xPawn(Other).default.ShieldStrengthMax;
}

defaultproperties
{
	AbilityName="Shield Upgrade"
	Description(0)="Ability Name: Shield Upgrade|Max Level: 20|Starting Cost: 50|Cost Add Per Level: 25|Requirements: None||Liandri Corp tech salvaged from rim worlds allowed the upgrade of the shield module. This Module will Increases your maximum shield by 25 per ability level."
	StartingCost=50
	CostAddPerLevel=25
	MaxLevel=20
}