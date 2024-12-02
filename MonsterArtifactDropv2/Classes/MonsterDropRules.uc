Class MonsterDropRules extends GameRules;

function ScoreKill(Controller Killer, Controller Killed)
{
	local Inventory Inv;
	local Vector X,Y,Z;

	if( Monster(Killed.Pawn) != None)
	{
		Inv = Killed.Pawn.FindInventoryType(class'MonsterArtifactDropv2.ItemDropInv');
		if(Inv != None)
		{
			GetAxes(Killed.Pawn.GetViewRotation(), X, Y, Z);
			Inv.DropFrom(Killed.Pawn.Location + 0.8 * Killed.Pawn.CollisionRadius * X - 0.5 * Killed.Pawn.CollisionRadius * Y);
		}
	}

    if ( NextGameRules != None )
        NextGameRules.ScoreKill(Killer,Killed);
}
defaultproperties
{
}
