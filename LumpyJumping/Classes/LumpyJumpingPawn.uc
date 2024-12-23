class LumpyJumpingPawn extends xPawn;

//var EDoubleClickDir LastDodgeDirection;

function DoDoubleJump( bool bUpdating )
{
	PlayDoubleJump();

	if ( !bIsCrouched && !bWantsToCrouch )
	{
        if ( !IsLocallyControlled() || (AIController(Controller) != None) )
            MultiJumpRemaining -= 1;
		Velocity.Z = JumpZ + MultiJumpBoost;
		SetPhysics(PHYS_Falling);
		if ( !bUpdating )
			PlayOwnedSound(GetSound(EST_DoubleJump), SLOT_Pain, GruntVolume,,80);
	}
}

function bool CanDoubleJump()
{
    return (MultiJumpRemaining > 0);
}


function bool DoJump( bool bUpdating )
{
	if ( !bUpdating && IsLocallyControlled() )
	{
		if ( PlayerController(Controller) != None )
			PlayerController(Controller).bDoubleJump = true;
		DoDoubleJump(bUpdating);
        MultiJumpRemaining -= 1;
		return true;
	}

	if ( Super.DoJump(bUpdating) )
	{
		if ( !bUpdating )
			PlayOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
		return true;
	}
	return false;
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	local vector X,Y,Z;
	local float VelocityZ;
	local name Anim;

	if ( bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking && Physics != PHYS_Falling)
	 || MultiJumpRemaining == 0/* || LastDodgeDirection == DoubleClickMove */)
		return false;

	GetAxes(Rotation,X,Y,Z);

	if (Physics == PHYS_Falling)
	{
		if (DoubleClickMove == DCLICK_Forward)
				Anim = WallDodgeAnims[0];
		else if (DoubleClickMove == DCLICK_Back)
				Anim = WallDodgeAnims[1];
		else if (DoubleClickMove == DCLICK_Left)
				Anim = WallDodgeAnims[2];
		else if (DoubleClickMove == DCLICK_Right)
				Anim = WallDodgeAnims[3];

		if ( PlayAnim(Anim, 1.0, 0.1) )
				bWaitForAnim = true;
				AnimAction = Anim;

		if (Velocity.Z < -DodgeSpeedZ*0.5) Velocity.Z += DodgeSpeedZ*0.5;
	}

	VelocityZ = Velocity.Z;

	if (DoubleClickMove == DCLICK_Forward)
		Velocity = DodgeSpeedFactor*GroundSpeed*X + (Velocity Dot Y)*Y;
	else if (DoubleClickMove == DCLICK_Back)
		Velocity = -DodgeSpeedFactor*GroundSpeed*X + (Velocity Dot Y)*Y; 
	else if (DoubleClickMove == DCLICK_Left)
		Velocity = -DodgeSpeedFactor*GroundSpeed*Y + (Velocity Dot X)*X; 
	else if (DoubleClickMove == DCLICK_Right)
		Velocity = DodgeSpeedFactor*GroundSpeed*Y + (Velocity Dot X)*X; 
 
	if ( !bCanDodgeDoubleJump )
	    MultiJumpRemaining = 0;

    MultiJumpRemaining -= 1;
	Velocity.Z = VelocityZ + DodgeSpeedZ;
	CurrentDir = DoubleClickMove;
//	LastDodgeDirection = DoubleClickMove;
	SetPhysics(PHYS_Falling);
	PlayOwnedSound(GetSound(EST_Dodge), SLOT_Pain, GruntVolume,,80);
	return true;
}

event Landed(vector HitNormal)
{
//	LastDodgeDirection = DCLICK_None;

	Super.Landed(HitNormal);
}

defaultproperties
{
}
