class tK_MineProjectile extends ONSMineProjectile;

simulated function Destroyed()
{
    if (Role == ROLE_Authority && bScriptInitialized && tK_MineLayer(Owner) != None)
        tK_MineLayer(Owner).CurrentMines--;

    Super.Destroyed();
}

defaultproperties
{
}
