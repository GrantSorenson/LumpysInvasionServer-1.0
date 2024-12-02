class ReviveArtifact extends WeaponOfPowerArtifact;

var ReviveInteraction reviveInteraction;

////////////////////////////////////////////////////////////////////////////////

replication {
	reliable if (Role == ROLE_Authority)
		OpenReviveHud, CloseReviveHud;

	reliable if (Role < ROLE_Authority)
		RevivePlayer, RevivePlayerPRI;
}

////////////////////////////////////////////////////////////////////////////////

simulated function Destoyed() {
	CloseReviveHud();
}

////////////////////////////////////////////////////////////////////////////////

function bool Apply() {
	local Controller        player;
	local Array<Controller> controllers;

	if (Instigator == None) {
		return false;
	}

	foreach Instigator.DynamicActors(class'Controller', player) {
		if (
			(player.PlayerReplicationInfo != None) &&
			(player.PlayerReplicationInfo.bOutOfLives == True)
		) {
			controllers.Insert(0, 1);
			controllers[0] = player;
		}
	}

	if (controllers.length == 0) {
	  	Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',0,,,class);
		return false;
	}

	if (PlayerController(Instigator.Controller) != None) {
		OpenReviveHud();
		return false;
	} else {
		RevivePlayer(controllers[rand(controllers.Length)]);

		return true;
	}
}

////////////////////////////////////////////////////////////////////////////////

function bool RevivePlayer(
	Controller player
) {
	if (player.PlayerReplicationInfo.bOutOfLives == False) {
	  	Instigator.ReceiveLocalizedMessage(Class'UnrealGame.StringMessagePlus',1,,,class);
		return false;
	}

	player.PlayerReplicationInfo.bOutOfLives = False;

	if (PlayerController(player) != None) {
		PlayerController(player).BehindView(false);
		PlayerController(player).ServerViewSelf();
	}

	player.Level.Game.RestartPlayer(player);

	Instigator.Spawn(class'ReviveEffect', Instigator,, Instigator.Location, Instigator.Rotation);
	BroadcastLocalizedMessage(class'ReviveMessage', 0, Instigator.PlayerReplicationInfo, player.PlayerReplicationInfo);

	return true;
}

////////////////////////////////////////////////////////////////////////////////

function RevivePlayerPRI(
	PlayerReplicationInfo PRI
) {
	local Controller player;

	foreach Instigator.DynamicActors(class'Controller', player) {
		if (player.PlayerReplicationInfo == PRI) {
			if (RevivePlayer(player) == true) {
				RemoveOne();
			}

			return;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function OpenReviveHud() {
	local PlayerController      player;
	local PlayerReplicationInfo PRI;

	// Don't open multiple ones.
	if (reviveInteraction != None) {
		return;
	}

	player = PlayerController(Instigator.Controller);

	reviveInteraction = ReviveInteraction(player.Player.InteractionMaster.AddInteraction("WeaponsOfPower.ReviveInteraction", player.Player));

	player.Player.LocalInteractions.Insert(0, 1);
	player.Player.LocalInteractions[0] = reviveInteraction;
	player.Player.LocalInteractions.Remove(player.Player.LocalInteractions.Length - 1, 1);

	reviveInteraction.Owner          = player;
	reviveInteraction.ReviveArtifact = self;

	foreach Instigator.DynamicActors(class'PlayerReplicationInfo', PRI) {
		if (PRI.bOutOfLives == True) {
			reviveInteraction.Players.Insert(0, 1);
			reviveInteraction.Players[0] = PRI;
		}
	}

	if (reviveInteraction.Players.Length == 0) {
		reviveInteraction.Close();
		return;
	}

	reviveInteraction.PostInitialize();
}

////////////////////////////////////////////////////////////////////////////////

simulated function CloseReviveHud() {
	if (reviveInteraction != None) {
		reviveInteraction.Close();
	}
}

////////////////////////////////////////////////////////////////////////////////

function HolderDied() {
	CloseReviveHud();
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "No one is dead to revive.";

		case 1:
			return "Selected player is not dead.";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    Description="This artifact will allow you to revive another player that has fallen."
    PickupClass=Class'RevivePickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.RevivePickupIcon'
    ItemName="Revive Artifact"
}
