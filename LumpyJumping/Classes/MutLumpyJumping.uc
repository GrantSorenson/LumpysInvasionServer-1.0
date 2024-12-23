class MutLumpyJumping extends Mutator;

function PostBeginPlay()
{
	SetTimer(0.2, true);

	Super.PostBeginPlay();
}

function ModifyLogin(out string Portal, out string Options)
{
	Level.Game.PlayerControllerClassName = "LumpyJumping.LumpyJumpingPlayer";
	Super.ModifyLogin(Portal, Options);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (Controller(Other) != None && Controller(Other).PawnClass == class'xPawn')
		Controller(Other).PawnClass = class'LumpyJumpingPawn';

	return true;
}

simulated function Tick(float deltaTime)
{
	local PlayerController PC;

	if (Level.NetMode != NM_DedicatedServer)
	{
		PC = Level.GetLocalPlayerController();
		if (PC != None && PC.DoubleClickDir >= DCLICK_Active)
		{
			PC.DoubleClickDir = DCLICK_Done;
			PC.ClearDoubleClick();
			PC.DoubleClickDir = DCLICK_None;
		}
	}
}

function Timer()
{
	local Controller C;
	local float Chance;

	for (C = Level.ControllerList; C != None; C = C.NextController)
	{
		if (C.PawnClass == class'xPawn')
			C.PawnClass = class'LumpyJumpingPawn';
		if (Bot(C) != None && C.Pawn != None && C.Pawn.Physics == PHYS_Falling && Bot(C).Skill > 3 && FRand() < 0.15)
		{
			Chance = FRand();
			if (Chance < 0.25)
				UnrealPawn(C.Pawn).Dodge(DCLICK_Left);
			else if (Chance < 0.50)
				UnrealPawn(C.Pawn).Dodge(DCLICK_Right);
			else if (Chance < 0.75)
				UnrealPawn(C.Pawn).Dodge(DCLICK_Forward);
			else
				UnrealPawn(C.Pawn).Dodge(DCLICK_Back);
		}
	}
}

defaultproperties
{
    GroupName="Pawn"
    FriendlyName="Lumpy Jumping"
    Description="Jumping for Lumpy Invasion and RPG"
    bAlwaysRelevant=True
    RemoteRole=2
}
