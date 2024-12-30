class AbilityAmmoRegen extends RPGAbility
    abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
    if (Data.AmmoMax < 50)
        return 0;
    else
        return Super.Cost(Data, CurrentLevel);
}


static simulated function UnModifyPawn(Pawn Other, int AbilityLevel)
{
    local Inventory Inv;

    if (Other.Role != ROLE_Authority)
        return;

    //remove old one, if it exists
    Inv = Other.FindInventoryType(class'AmmoRegenInv');
    if (Inv != None)
        Inv.Destroy();
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
    local AmmoRegenInv R;
    local Inventory Inv;

    if (Other.Role != ROLE_Authority)
        return;

    //remove old one, if it exists
    //might happen if player levels up this ability while still alive
    Inv = Other.FindInventoryType(class'AmmoRegenInv');
    if (Inv != None)
        Inv.Destroy();

    R = Other.spawn(class'AmmoRegenInv', Other,,,rot(0,0,0));
    R.RegenAmount = AbilityLevel;
    R.GiveTo(Other);
}

    defaultproperties
    {
        AbilityName="Ammo Regen"
        Description="Ability Name: Ammo Regen|Max Level: 15|Starting Cost: 20|Cost Add Per Level: 5|Requirements: 50 Ammo Bonus||Regenerate Ammo for all Non-Super weapons|Levels 1-5 of this ability generate ammo every second|Levels 6-10 of this ability generate ammo every 3 seconds|Levels 11-15 generate ammo every 5 seconds"
        StartingCost=20
        CostAddPerLevel=5
        MaxLevel=15
    }