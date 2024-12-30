class AbilityGeneralVampire extends AbilityVampire
    abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
    if (Data.Attack < 50 * CurrentLevel)
        return 0;
    else
        return Super.Cost(Data, CurrentLevel);
}

defaultproperties
{
    AbilityName="Vampirism"
    Description="Ability Name: Vampirism|Max Level: 10|Starting Cost: 25|Cost Increase Per Level: 25|Requirements: +50 Damage Bonus Per Level||You are given a light curse of Vampirism. Whenever you damage another player, you are healed for 5% of the damage per level (up to your starting health amount + 50). You can't gain health from self-damage and you can't gain health from damage caused by the Retaliation ability. "
    StartingCost=25
    CostAddPerLevel=25
    MaxLevel=10
}

