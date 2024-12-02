class ReviveInteraction extends Interaction;

var int CurrentPlayer;

var array<PlayerReplicationInfo> Players;

var ReviveArtifact ReviveArtifact;

var PlayerController Owner;

var bool bDefaultArtifactBindings;

var SpinnyWeap              SelectedPlayer;
var (SelectedPlayer) vector SelectedPlayerOffset;

////////////////////////////////////////////////////////////////////////////////

event Initialized() {
	local EInputKey key;
	local string    tmp;

	for (key = IK_None; key < IK_OEMClear; key = EInputKey(key + 1)) {
		tmp = ViewportOwner.Actor.ConsoleCommand("KEYNAME"    @ Key);
		tmp = ViewportOwner.Actor.ConsoleCommand("KEYBINDING" @ tmp);

		if (
			(tmp ~= "activateitem") ||
			(tmp ~= "nextitem")     ||
			(tmp ~= "previtem")
		) {
			bDefaultArtifactBindings = false;
			break;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

simulated function PostInitialize() {
	local rotator R;

	R.Yaw = 32768;

	SelectedPlayer = Owner.spawn(class'XInterface.SpinnyWeap');
	SelectedPlayer.SetDrawType(DT_Mesh);
	SelectedPlayer.SetDrawScale(0.18);
	SelectedPlayer.SetRotation(R + Owner.Rotation);

	UpdateCurrentPlayer();
}

////////////////////////////////////////////////////////////////////////////////

function bool KeyType(
	out      EInputKey Key,
	optional string    Unicode
) {
	return True;
}

////////////////////////////////////////////////////////////////////////////////

function bool KeyEvent(
	out EInputKey    Key,
	out EInputAction Action,
	    float        Delta
) {
	local string strKeyBinding;

	if (Action != IST_Press) {
		return True;
	}

	if (bDefaultArtifactBindings == false) {
		strKeyBinding = ViewportOwner.Actor.ConsoleCommand("KEYNAME"    @ Key);
		strKeyBinding = ViewportOwner.Actor.ConsoleCommand("KEYBINDING" @ strKeyBinding);
	} else if (Key == IK_U) {
		strKeyBinding = "activateitem";
	} else if (Key == IK_LeftBracket) {
		strKeyBinding = "previtem";
	} else if (Key == IK_RightBracket) {
		strKeyBinding = "nextitem";
	}

	if (Key == IK_Escape) {
  		// Remove interaction.
		Close();
		return True;
	}

	if (strKeyBinding ~= "previtem") {
		// Previous Player
		--CurrentPlayer;

		if (CurrentPlayer < 0) {
			CurrentPlayer = Players.Length - 1;
		}

		UpdateCurrentPlayer();

		return True;
	}

	if (strKeyBinding ~= "nextitem") {
		// Next Player
		++CurrentPlayer;

		if (CurrentPlayer == Players.Length) {
			CurrentPlayer = 0;
		}

		UpdateCurrentPlayer();

		return True;
	}

	if (strKeyBinding ~= "activateitem") {
		// Select Player
		ReviveArtifact.RevivePlayerPRI(Players[CurrentPlayer]);
		Close();
		return True;
	}

	return True;
}

////////////////////////////////////////////////////////////////////////////////

function PostRender(
	canvas Canvas
) {
	local vector  CamPos;
	local vector  X;
	local vector  Y;
	local vector  Z;
	local rotator CamRot;
	local float   originalX;
	local float   originalY;
	local float   originalClipX;
	local float   originalClipY;
	local float   XL;
	local float   YL;
	local float   oldFontScaleX;
	local float   oldFontScaleY;

	Canvas.Style = 5;
	Canvas.DrawColor = class'Colors'.default.Black;
	Canvas.DrawColor.A = 64;
	Canvas.SetPos(Canvas.ClipX * 0.35, Canvas.ClipY * 0.3);
	Canvas.DrawTileStretched(texture'UCGeneric.Black', Canvas.ClipX * 0.3, Canvas.ClipY * 0.4);

	Canvas.Style = 1;
	Canvas.DrawColor = class'HudCDeathmatchHelper'.static.GetHudTeamColor(Owner.Pawn);
	Canvas.DrawColor.A = 255;
	Canvas.SetPos(Canvas.ClipX * 0.35, Canvas.ClipY * 0.3);
	Canvas.DrawTileStretched(Texture'InterfaceContent.Menu.ScoreBoxA', Canvas.ClipX * 0.3, Canvas.ClipY * 0.4);

	oldFontScaleX = canvas.FontScaleX;
	oldFontScaleY = canvas.FontScaleY;

	canvas.FontScaleX *= 2;
	canvas.FontScaleY *= 2;

	canvas.TextSize(Players[CurrentPlayer].PlayerName, XL, YL);
	canvas.SetPos(Canvas.ClipX * 0.5 - XL / 2, Canvas.ClipY * (0.25));
	Canvas.Drawcolor = class'Colors'.default.White;
	canvas.DrawText(Players[CurrentPlayer].PlayerName);

	canvas.FontScaleX = oldFontScaleX;
	canvas.FontScaleY = oldFontScaleY;

	if (SelectedPlayer == None) {
		return;
	}

   	originalX     = Canvas.OrgX;
	originalY     = Canvas.OrgY;
	originalClipX = Canvas.ClipX;
	originalClipY = Canvas.ClipY;

	Canvas.OrgX  = 0;
	Canvas.OrgY  = 0;
	Canvas.ClipX = 1;
	Canvas.ClipY = 1;

	canvas.GetCameraLocation(CamPos, CamRot);
	GetAxes(CamRot, X, Y, Z);

	SelectedPlayer.SetLocation(
		CamPos +
		(SelectedPlayerOffset.X * X) +
		(SelectedPlayerOffset.Y * Y) +
		(SelectedPlayerOffset.Z * Z)
	);

	Canvas.Style = 1;
	Canvas.DrawActor(SelectedPlayer, false, true, 15);

	Canvas.OrgX  = originalX;
	Canvas.OrgY  = originalY;
	Canvas.ClipX = originalClipX;
	Canvas.ClipY = originalClipY;
}

////////////////////////////////////////////////////////////////////////////////

function UpdateCurrentPlayer() {
	local xUtil.PlayerRecord PlayerRecord;

	PlayerRecord = class'xUtil'.static.FindPlayerRecord(Players[CurrentPlayer].CharacterName);

    SelectedPlayerOffset = vect(250.0, 0.00, 0.00);

	SelectedPlayer.LinkMesh(Mesh(DynamicLoadObject(PlayerRecord.MeshName,class'Mesh')));
	SelectedPlayer.Skins[0] = Material(DynamicLoadObject(PlayerRecord.BodySkinName, class'Material'));
	SelectedPlayer.Skins[1] = Material(DynamicLoadObject(PlayerRecord.FaceSkinName, class'Material'));

	SelectedPlayer.LoopAnim('RunF');
}

////////////////////////////////////////////////////////////////////////////////

function Close() {
	local PlayerController tempOwner;

	tempOwner = Owner;

	SelectedPlayer.Destroy();
	SelectedPlayer = None;
	Owner          = None;

	ReviveArtifact.reviveInteraction = None;
	ReviveArtifact = None;

	tempOwner.Player.InteractionMaster.RemoveInteraction(self);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    bDefaultArtifactBindings=True
    bVisible=True
}
