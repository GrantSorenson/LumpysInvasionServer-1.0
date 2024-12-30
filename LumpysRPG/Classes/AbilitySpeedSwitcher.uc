class AbilitySpeedSwitcher extends RPGAbility
    abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
    return Super.Cost(Data, CurrentLevel);
}

static simulated function UnModifyPawn(Pawn Other, int AbilityLevel)
{
    local Inventory Inv;

    for(Inv=Other.Inventory; Inv!=None; Inv=Inv.Inventory)
    {
        if(RPGStatsInv(Inv) != None)
            RPGStatsInv(Inv).ResetWeaponSwapSpeed();
    }
}

static simulated function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
    local float Modifier;
    local RPGWeapon RW;

    if (!Weapon.Instigator.IsLocallyControlled())
        return;

    Modifier = 1.0 + (0.5 * AbilityLevel);
    RW = RPGWeapon(Weapon);
    if (RW != None)
    {
        RW.ModifiedWeapon.BringUpTime = RW.ModifiedWeapon.default.BringUpTime / Modifier;
        RW.ModifiedWeapon.PutDownTime = RW.ModifiedWeapon.default.PutDownTime / Modifier;
        RW.ModifiedWeapon.MinReloadPct = RW.ModifiedWeapon.default.MinReloadPct / Modifier;
        RW.ModifiedWeapon.PutDownAnimRate = RW.ModifiedWeapon.default.PutDownAnimRate * Modifier;
        RW.ModifiedWeapon.SelectAnimRate = RW.ModifiedWeapon.default.SelectAnimRate * Modifier;
    }
    else
    {   Weapon.BringUpTime = Weapon.default.BringUpTime / Modifier;
        Weapon.PutDownTime = Weapon.default.PutDownTime / Modifier;
        Weapon.MinReloadPct = Weapon.default.MinReloadPct / Modifier;
        Weapon.PutDownAnimRate = Weapon.default.PutDownAnimRate * Modifier;
        Weapon.SelectAnimRate = Weapon.default.SelectAnimRate * Modifier;
    }
}

defaultproperties
{
     AbilityName="Fast Hands"
     Description="Ability Name: Fast Hands|Max Level: 15|Starting Cost: 50|Cost Increase Per Level: 50|RequireMents: None||Years of training has improved your dexterity, allowing you to switch weapons 10% faster for each level of this ability."
     StartingCost=50
     CostAddPerLevel=50
     BotChance=3
     MaxLevel=15
}