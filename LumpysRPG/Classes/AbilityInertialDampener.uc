class AbilityInertialDampener extends RPGAbility
	abstract;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (bOwnedByInstigator)
		return;

	Momentum = Momentum * (1 - (AbilityLevel * 0.05));
}

defaultproperties
{
	AbilityName="Inertial Dampener"
	Description(0)="Ability Name: Inertial Dampener|Max Level: 20|Starting Cost: 25|Cost Add Per Level: 25|Requirements: None||The latest in Inertial Dampening tech, Liandri has sourced belts that reduce how far enemy fire can push you by 5% per level.|May not work on heavy load monsters like Titans and Queens."
	StartingCost=15
	CostAddPerLevel=5
	MaxLevel=20
}