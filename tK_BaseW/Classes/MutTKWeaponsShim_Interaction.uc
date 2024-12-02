class MutTKWeaponsShim_Interaction extends Interaction;

event NotifyLevelChange()
{
    class'MutTKWeaponsShim'.static.ResetDamageTypes();
    Super.NotifyLevelChange();
}

defaultproperties
{
}
