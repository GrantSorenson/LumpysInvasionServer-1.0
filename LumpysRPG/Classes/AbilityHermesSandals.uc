/*
AbilityHermesSandals ~ "Sandals of Hermes"
This ability combines general movement abilities into one that gives the player bonuses to their movement stats and physical appearance
Levels 1-10 of this ability augment the players jump height and movement speed to their maximum respective amounts
Levels 11-15 give increasing bonuses to the speed combo, as well as gives the player different colored foot emmitters
Level 16 provides the player with an artifact that allows them to customize their foot trail effect with different color effects or images

This Abilitie's total cost will be 10000 stats points or 400 Levels.
Level 1-10  = [50,50,100,100,200,200,400,400,400,400]
Level 11-15 = [1000,1000,1000,1200,1500]
Level 16    = [2000]
*/

class AbilityHermesSandals extends RPGAbility
  CacheExempt
  abstract;


  //var config xEmitter LeftTrail, RightTrail;
  var config bool bEffectStarted;
  var int MultiJumpBoost;

  static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
  {
    if(CurrentLevel >= 16)
      return 2000;
    else if(CurrentLevel == 15)
    {
      if(!default.bEffectStarted)
      {
        //StartEffect(Pawn(ViewportOwner.Actor.Pawn));
      }
      return 1500;
    }
    else if(CurrentLevel == 14)
    {
      if(!default.bEffectStarted)
      {
        //StartEffect(xPawn(ViewportOwner.Actor.Pawn));
      }
      return 1200;
    }
    else if(CurrentLevel >= 11)
    {
      if(!default.bEffectStarted)
      {
        //StartEffect(xPawn(ViewportOwner.Actor.Pawn));
      }
      return 1000;
    }
    else if(CurrentLevel >= 7)
      return 400;
    else if(CurrentLevel >= 5)
      return 200;
    else if(CurrentLevel >= 3)
      return 100;
    else if(CurrentLevel >= 0)
      return 50;
    else
  		return Super.Cost(Data, CurrentLevel);
  }

  function RPGStatsInv GetStatsInv(PlayerController PC)
  {
  	local Inventory Inv;

  	for (Inv = PC.Inventory; Inv != None; Inv = Inv.Inventory)
  		if ( Inv.IsA('RPGStatsInv') && ( Inv.Owner == PC || Inv.Owner == PC.Pawn
  						   || (Vehicle(PC.Pawn) != None && Inv.Owner == Vehicle(PC.Pawn).Driver) ) )
  			return RPGStatsInv(Inv);

  	//fallback - shouldn't happen
  	if (PC.Pawn != None)
  	{
  		Inv = PC.Pawn.FindInventoryType(class'RPGStatsInv');
  		if ( Inv != None && ( Inv.Owner == PC || Inv.Owner == PC.Pawn
  				      || (Vehicle(PC.Pawn) != None && Inv.Owner == Vehicle(PC.Pawn).Driver) ) )
  			return RPGStatsInv(Inv);
  	}
    return None;
  }

  static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
  {
    local xPawn x;
    //Modify jump and ground speed
    Log("Speed Modified");
  	Other.JumpZ = Other.default.JumpZ * (1.0 + 0.1 * float(Min(AbilityLevel,5)));
    Other.GroundSpeed = Other.default.GroundSpeed * (1.0 + 0.05 * float(Min(AbilityLevel,20)));
    Other.WaterSpeed = Other.default.WaterSpeed * (1.0 + 0.05 * float(Min(AbilityLevel,20)));
    Other.AirSpeed = Other.default.AirSpeed * (1.0 + 0.05 * float(Min(AbilityLevel,20)));
    Other.LadderSpeed = Other.default.LadderSpeed * (1.0 + 0.05 * float(Min(AbilityLevel,20)));
    Other.AccelRate = Other.default.AccelRate * (1.0 + 0.05 * float(Min(AbilityLevel,20)));
    //modify jump amount
    x = xPawn(Other); 
    if (x != None)
    {
      x.MaxMultiJump = 2 + AbilityLevel;
      x.MultiJumpBoost = default.MultiJumpBoost;
    }
    // if (!default.bEffectStarted && (AbilityLevel < 16 || AbilityLevel >= 11)
    // {
    //   StartEffect(xPawn(ViewportOwner.Actor.Pawn));
    // }
  }


static function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel, bool bAlreadyPrevented)
  {

    //P = xPawn(ViewportOwner.Actor.Pawn);
    default.bEffectStarted = false;
    //StopEffect(P);
  	return Super.PreventDeath(Killed,Killer,DamageType,HitLocation,AbilityLevel,bAlreadyPrevented);
  }

  static function bool StartEffect(Pawn P)
  {

    default.bEffectStarted = true;

    // LeftTrail = Spawn(class'SpeedTrail', P,, P.Location, P.Rotation);
    // P.AttachToBone(LeftTrail, 'lfoot');
    //
    // RightTrail = Spawn(class'SpeedTrail', P,, P.Location, P.Rotation);
    // P.AttachToBone(RightTrail, 'rfoot');
    return true;
  }

  static function bool StopEffect(xPawn P)
  {
    default.bEffectStarted = false;
    return true;
  }

  defaultproperties
  {
    MultiJumpBoost=50
    AbilityName="Sandals of Hermes"
  	Description="Ability Name: Hermes Sandles|Max Level: This ability combines general movement abilities into one that gives the player bonuses to their Jump Height and Movement Speed |Levels 1-10 of this ability augment the players jump height(+10%) and movement speed(+5%) per level. ||NOT IMPLEMENNETED(Hidden):|Levels 11-15 give increasing bonuses to the speed combo, as well as gives the player different colored foot emmitters |Level 16 provides the player with an artifact that allows them to customize their foot trail effect with different color effects or images"
  	StartingCost=1
  	CostAddPerLevel=0
  	MaxLevel=25
  }
