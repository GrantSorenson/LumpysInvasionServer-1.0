class DragonGameReplicationInfo extends ReplicationInfo;

var bool UseConfigs;
var float FireDragonHealth;
var float IceDragonHealth;
var float NatureDragonHealth;
var float BeamDragonHealth;
var float ElectricDragonHealth;
var float WindDragonHealth;
var float IonDragonHealth;
var float EarthDragonHealth;

var bool EasterEggMode;
var float LurveChance;
var bool LogLurveInformation;
var float LurveDragonHealth;
var bool LurveDragonLoveMonsters;
var int LurveHealthMax;
var int LurveHealthAmount;
var float LurveRange;

var float WindStrength;
var int BeamAmount;
var int NatureAmountMax;

replication
{
	reliable if(ROLE == Role_Authority)
		UseConfigs, FireDragonHealth, IceDragonHealth, NatureDragonHealth, BeamDragonHealth;
	reliable if(ROLE == Role_Authority)
		ElectricDragonHealth, WindDragonHealth, LurveDragonHealth, IonDragonHealth, EarthDragonHealth;
	reliable if(ROLE == Role_Authority)
		LurveDragonLoveMonsters, LurveHealthMax, EasterEggMode, LurveChance, LogLurveInformation;
	reliable if(ROLE == Role_Authority)
	LurveHealthAmount, LurveRange, WindStrength, BeamAmount, NatureAmountMax;
}

defaultproperties
{
}
