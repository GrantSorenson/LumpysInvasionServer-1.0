class LumpyJumpingPlayer extends xPlayer;

var vector HoldAccel, HoldVelocity;
var bool bCanHover;
var float AirResistance;

state PlayerWalking
{
	ignores SeePlayer, HearNoise;

	function bool NotifyLanded(vector HitNormal)
	{
		bCanHover = true;
		return Super.NotifyLanded(HitNormal);
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		local vector OldAccel;
		local bool OldCrouch;

		if ( (DoubleClickMove == DCLICK_Active) && (Pawn.Physics == PHYS_Falling) )
			DoubleClickDir = DCLICK_Active;
		else if ( (DoubleClickMove != DCLICK_None) && (DoubleClickMove < DCLICK_Active) )
		{
			if ( LumpyJumpingPawn(Pawn).MultiJumpRemaining > 0 && LumpyJumpingPawn(Pawn).Dodge(DoubleClickMove) )
				DoubleClickDir = DCLICK_Active;
		}

		if ( Pawn == None )
			return;
		OldAccel = Pawn.Acceleration;
		Pawn.Acceleration = NewAccel;

		if ( bDoubleJump && (bUpdating || Pawn.CanDoubleJump()) &&  LumpyJumpingPawn(Pawn).MultiJumpRemaining > 0)
			Pawn.DoDoubleJump(bUpdating);
		else if ( bPressedJump && LumpyJumpingPawn(Pawn).MultiJumpRemaining > 0)
			Pawn.DoJump(bUpdating);

		if ( Pawn.Physics != PHYS_Falling )
		{
			OldCrouch = Pawn.bWantsToCrouch;
			if (bDuck == 0)
			Pawn.ShouldCrouch(false);
			else if ( Pawn.bCanCrouch )
			Pawn.ShouldCrouch(true);
		}

		if ((Pawn.Physics == PHYS_Falling) && (bDuck == 1) && bCanHover)
		{
			bCanHover = false;
			GotoState('Hover');
		}
	}

	function BeginState()
	{
		Super.BeginState();
		if (Pawn.Physics == PHYS_Walking)
		{
			bCanHover = true;
		}
	}
}

state Hover
{
	ignores SeePlayer, HearNoise, Bump;

	event Timer()
	{
		bDuck = 0;
	}

	function bool NotifyLanded(vector HitNormal)
	{
		bDuck = 0;
		return Global.NotifyLanded(HitNormal);
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		if ( Pawn == None )
			return;

		if( VSize(NewAccel) == 0.0 )
			Pawn.Velocity /= 1 + DeltaTime * AirResistance;

		if (bDuck == 0)
		{
			Pawn.SetPhysics(PHYS_Falling);
			GotoState('PlayerWalking');
		}
   	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;
		
		GetAxes(Rotation,X,Y,Z);

		if ( VSize(Pawn.Acceleration) < 1.0 )
			Pawn.Acceleration = vect(0,0,0);
		if ( VSize(Pawn.Velocity) < 1.0 )
			Pawn.Velocity = vect(0,0,0);

		UpdateRotation(DeltaTime, 2);

		if ( Role < ROLE_Authority )
			ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		else
	   		ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
	}
	
	function BeginState()
	{
		HoldAccel = Pawn.Acceleration;
		HoldVelocity = Pawn.Velocity;
		Pawn.Acceleration = vect(0, 0, 0);
		Pawn.SetPhysics(PHYS_Flying);
		Pawn.Velocity = vect(0, 0, 0);
	}

	function EndState()
	{
		SetTimer(0,false);
		if ( Pawn != None )
		{
			Pawn.Acceleration = HoldAccel;
			Pawn.Velocity = HoldVelocity;
			if ( Pawn.Physics != PHYS_Walking ) bCanHover = true;
			else bCanHover = true;
			Pawn.ShouldCrouch(false);
		}
	}

}

defaultproperties
{
    PawnClass=Class'LumpyJumpingPawn'
}
