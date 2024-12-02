//RPGInteraction - Level/stat info and creates levelup menu
//Also saves stats on level change for Listen and Standalone servers
//because on those types of games people often quit in the middle (which servers almost never do)
class RPGInteraction extends Interaction
	config(LumpyRPG);

var MutLumpysRPG RPGMut;
var bool bDefaultBindings, bDefaultArtifactBindings; //use default keybinds because user didn't set any
var RPGStatsInv StatsInv;
var float LastLevelMessageTime;
var config int LevelMessagePointThreshold; //player must have more than this many stat points for message to display
var Font TextFont;
var color EXPBarColor, WhiteColor, RedTeamTint, BlueTeamTint, GreenColor;
var localized string LevelText, StatsMenuText, ArtifactText, CreditText;
var int LastHeldCred, CredBonkAmount;
var bool bShowBonk;
var float CreditBonkAlpha, CredTime;
//Hate This


//wop
var config int ItemsToShow;
var config bool ShowItemDescriptions;
var int Distance;
var float Transition;
var float ScrollSpeed;
var float fInfoPosition;
var int Direction;
struct DescriptionMap {
	var class<RPGArtifact> ArtifactClass;
	var String             Description;
};
var config array<DescriptionMap> RpgDescriptions;

event Initialized()
{
	local EInputKey key;
	local string tmp;

	if (ViewportOwner.Actor.Level.NetMode != NM_Client)
		foreach ViewportOwner.Actor.DynamicActors(class'MutLumpysRPG', RPGMut)
			break;

	//detect if user made custom binds for our aliases
	for (key = IK_None; key < IK_OEMClear; key = EInputKey(key + 1))
	{
		tmp = ViewportOwner.Actor.ConsoleCommand("KEYNAME"@Key);
		tmp = ViewportOwner.Actor.ConsoleCommand("KEYBINDING"@tmp);
		if (tmp ~= "rpgstatsmenu")
			bDefaultBindings = false;
		else if (tmp ~= "activateitem" || tmp ~= "nextitem" || tmp ~= "previtem")
			bDefaultArtifactBindings = false;
		if (!bDefaultBindings && !bDefaultArtifactBindings)
			break;
	}

	TextFont = Font(DynamicLoadObject("UT2003Fonts.jFontSmall", class'Font'));
}

//Detect pressing of a key bound to one of our aliases
//KeyType() would be more appropriate for what's done here, but Key doesn't seem to work/be set correctly for that function
//which prevents ConsoleCommand() from working on it
function bool KeyEvent(EInputKey Key, EInputAction Action, float Delta)
{
	local string tmp;

	if (Action != IST_Press)
		return false;

	//Use console commands to get the name of the numeric Key, and then the alias bound to that keyname
	if (!bDefaultBindings)
	{
		tmp = ViewportOwner.Actor.ConsoleCommand("KEYNAME"@Key);
		tmp = ViewportOwner.Actor.ConsoleCommand("KEYBINDING"@tmp);
	}

	//If it's our alias (which doesn't actually exist), then act on it
	if (tmp ~= "rpgstatsmenu" || (bDefaultBindings && Key == IK_L))
	{
		if (StatsInv == None)
			FindStatsInv();
		if (StatsInv == None)
			return false;
		//Show stat menu
		ViewportOwner.GUIController.OpenMenu("LumpysRPG.RPGLumpyStatMenu");
		RPGLumpyStatMenu(GUIController(ViewportOwner.GUIController).TopPage()).InitFor(StatsInv);
		LevelMessagePointThreshold = StatsInv.Data.PointsAvailable;
		return true;
	}

	else if (bDefaultArtifactBindings)
	{
		if (Key == IK_U)
		{
			ViewportOwner.Actor.ActivateItem();
			return true;
		}
		else if (Key == IK_LeftBracket)
		{
			ViewportOwner.Actor.PrevItem();
			return true;
		}
		else if (Key == IK_RightBracket)
		{
			if (ViewportOwner.Actor.Pawn != None)
				ViewportOwner.Actor.Pawn.NextItem();
			return true;
		}
		else if (Key == IK_J)
		{
			ShowItemDescriptions = !ShowItemDescriptions;
			return true;
		}
	}

	//Don't care about this event, pass it on for further processing
	return false;
}

//Find local player's stats inventory item
function FindStatsInv()
{
	local Inventory Inv;
	local RPGStatsInv FoundStatsInv;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		StatsInv = RPGStatsInv(Inv);
		if (StatsInv != None)
			return;
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'RPGStatsInv', FoundStatsInv)
				{
					if (FoundStatsInv.Owner == ViewportOwner.Actor || FoundStatsInv.Owner == ViewportOwner.Actor.Pawn)
					{
						StatsInv = FoundStatsInv;
						Inv.Inventory = StatsInv;
						break;
					}
				}
				return;
			}
		}
	}
}

static function bool ShouldDisplayHud(
	Player ViewportOwner
) {
	local Pawn HudOwner;

	if (
		(ViewportOwner       == None) ||
		(ViewportOwner.Actor == None)
	) {
		return false;
	}

	HudOwner = ViewportOwner.Actor.Pawn;

	// If no owner or the owner is dead.
	if (
		(HudOwner        == None) ||
		(HudOwner.Health <= 0)
	) {
		return false;
	}

	if (ViewportOwner.Actor.myHUD == None) {
		return false;
	}

	// Don't display if there's one of the alternate game screens being shown.
	if (
		(ViewportOwner.Actor.myHud != None) &&
		(
			(ViewportOwner.Actor.myHud.bHideHUD        == true) ||
			(ViewportOwner.Actor.myHud.bShowScoreBoard == true) ||
			(ViewportOwner.Actor.myHud.bShowLocalStats == true)
		)
	) {
		return false;
	}

	// Check if they have the HUD minimized to not show certain components.
	if (ViewportOwner.Actor.myHUD.bShowWeaponBar == false) {
		return false;
	}

	// Don't display if the game is over.
	if (
		(ViewportOwner.Actor.GameReplicationInfo        != None) &&
		(ViewportOwner.Actor.GameReplicationInfo.Winner != None)
	) {
		return false;
	}

	// Don't display when inside vehicles.
	if (Vehicle(ViewportOwner.Actor.Pawn) != None) {
		return false;
	}

	return true;
}

////////////////////////////////////////////////////////////////

function PostRender(Canvas Canvas)
{
	local float XL, YL, XLSmall, YLSmall, EXPBarX, EXPBarY;
	local float CreditTextX, CreditTextY, CreditBonkX, CreditBonkY;
	local int CredStock;
	local Color CreditBonkColor;

	CreditBonkColor = GreenColor;

	if (ShouldDisplayHud(ViewportOwner) == False) {
		return;
	}

	if (StatsInv == None) {
		FindStatsInv();

		if (StatsInv == None) {
			return;
		}
	}

	if (TextFont != None) {
		Canvas.Font = TextFont;
	}

	Canvas.FontScaleX = Canvas.ClipX / 1024.f;
	Canvas.FontScaleY = Canvas.ClipY / 768.f;
	Canvas.TextSize(LevelText@StatsInv.Data.Level, XL, YL);



	// Increase size of the display if necessary for really high levels
	XL = FMax(XL + 9.f * Canvas.FontScaleX, 135.f * Canvas.FontScaleX);
	Canvas.Style = 5;
	EXPBarX = Canvas.ClipX - XL - 1.f;
	EXPBarY = Canvas.ClipY * 0.75 - YL * 3.75;
//Draw XP Bar
	Canvas.DrawColor = class'Colors'.static.MultiplyColor(class'HudCDeathmatchHelper'.static.GetHudTeamColor(ViewportOwner.Actor.Pawn), 0.5);
	Canvas.DrawColor.A = 255;
	Canvas.SetPos(EXPBarX, EXPBarY);
	Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL, 15.0 * Canvas.FontScaleY, 836, 454, -386, 36);
//Draw Colored Filled XP Bar Portion
	Canvas.DrawColor = class'Colors'.static.ScaleColor(class'HudCDeathmatchHelper'.static.GetHudTeamColor(ViewportOwner.Actor.Pawn), 1.0, 0.15);
	Canvas.SetPos(EXPBarX, EXPBarY);
	Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL * StatsInv.Data.Experience / StatsInv.Data.NeededExp, 15.0 * Canvas.FontScaleY, 836, 454, -386 * StatsInv.Data.Experience / StatsInv.Data.NeededExp, 36);

	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(EXPBarX, EXPBarY);
	Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL, 16.0 * Canvas.FontScaleY, 836, 415, -386, 38);
//Draw Level
	Canvas.Style = 2;
	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(EXPBarX + 9.f * Canvas.FontScaleX, Canvas.ClipY * 0.75 - YL * 5.0);
	Canvas.DrawText(LevelText@StatsInv.Data.Level);
	//Draw EXP bar values smaller
	Canvas.FontScaleX *= 0.75;
	Canvas.FontScaleY *= 0.75;
	Canvas.TextSize(StatsInv.Data.Experience$"/"$StatsInv.Data.NeededExp, XLSmall, YLSmall);
	Canvas.SetPos(Canvas.ClipX - XL * 0.5 - XLSmall * 0.5, Canvas.ClipY * 0.75 - YL * 3.75 + 12.5 * Canvas.FontScaleY - YLSmall * 0.5);
	Canvas.DrawText(StatsInv.Data.Experience$"/"$StatsInv.Data.NeededExp);
	/*Credit Bonk-Just a dream
	When the player gets a kill, they will gain credits on their data object. this change will be used to calculate the point bonk.
		the vaiables LastHeldCred will hold the last cred amount the player had. if the value changes, credits wont be updated,
		we will draw another text below above credits where the amount will sum until the player hasnt killed an enemy for 3 seconds.
		Equation for our cred alpha line y=-1.1^{x-50} + 255
	*/
	if (LastHeldCred != 0 && LastHeldCred != StatsInv.Data.Credits)
	{
		Log("Last Cred:" @ LastHeldCred @ "Stat Cred:" @ StatsInv.Data.Credits);
		if(bShowBonk)
		{
			CredBonkAmount += StatsInv.Data.Credits - LastHeldCred;
		}else
		{
			bShowBonk = true;
			CredBonkAmount += StatsInv.Data.Credits - LastHeldCred;
		}
		//CreditBonkColor = GreenColor;
		CredTime = 0;
	}

	if(bShowBonk)
	{
		//Log("Alpha: " @ string(byte((-1.1**(CredTime-50)) + 255)) @ "CredTime: " @ CredTime);
		CreditBonkColor.A = byte(255 -(1.007**(CredTime-50)));//byte(-1.1**(CredTime-50) + 255);//int((-1.1**(CredTime-50)) + 255);byte(CreditBonkColor.A - 1*CredTime);
		Canvas.TextSize("+"@CredBonkAmount, CreditBonkX, CreditBonkY);
		Canvas.Style = 2;
		Canvas.DrawColor = CreditBonkColor;
		Canvas.SetPos(EXPBarX + 138.f * Canvas.FontScaleX - CreditBonkX, Canvas.ClipY * 0.75 - YL * 2.60);//EXPBarX + 9.f * Canvas.FontScaleX + 50, Canvas.ClipY * 0.75 - YL * 3.0
		Canvas.DrawText("+"$(CredBonkAmount));
		if(CredTime>=820)
		{
			bShowBonk = false;
			CredBonkAmount = 0;
		}
		CredTime += 1;
	}

	//Draw credits smaller
	Canvas.TextSize(CreditText@StatsInv.Data.Credits, CreditTextX, CreditTextY);
	Canvas.Style = 2;
	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(EXPBarX + 2.f * Canvas.FontScaleX, Canvas.ClipY * 0.75 - YL * 2.0);
	Canvas.DrawText(CreditText$StatsInv.Data.Credits);

	LastHeldCred = StatsInv.Data.Credits;
//Draw Invenotry
	DrawInventory(Canvas, YL);

	Canvas.FontScaleX = Canvas.default.FontScaleX;
	Canvas.FontScaleY = Canvas.default.FontScaleY;

}

function int GetPowerupCount() {
	local int       powerupCount;
	local Inventory inv;

	inv = ViewportOwner.Actor.Pawn.Inventory;

	powerupCount = 0;

	while (inv != none) {
		if (
			(inv.IsA('PowerUps') == true) &&
			(PowerUps(inv).bActivatable == true)
		) {
			++powerupCount;
		}

		inv = inv.Inventory;
	}

	return powerupCount;
}

function DrawInventory(Canvas Canvas, Float YL) {
	local float iBoxLeft;
	local float iBoxTop;
	local float iBoxWidth;
	local float iBoxOriginalLeft;
	local float iBoxHeight;
	local float iBoxClipX;
	local float iconLeft;
	local float iconTop;
	local float iconWidth;
	local float iconHeight;
	local int   i;
	local int   numToShow;
	local int   numToShow2;
	local int   powerupCount;
	local int   halfToShow;

	local Inventory   firstInventory;
	local RPGStatsInv RPGStatsInv;

	if ((ItemsToShow % 2) == 0) {
		++ItemsToShow;
	}

	RPGStatsInv  = FindRPGStatsInv();

	if (RPGStatsInv == None) {
		return;
	}

	powerupCount = GetPowerupCount();
	numToShow    = powerupCount;

	if (numToShow > ItemsToShow) {
		numToShow = ItemsToShow;
	} else if ((numToShow % 2) == 0) {
		++numToShow;
	}

	numToShow2 = numToShow;
	halfToShow = numToShow / 2;

	Canvas.FontScaleX *= 1.33333;
	Canvas.FontScaleY *= 1.33333;

	if (RPGArtifact(ViewportOwner.Actor.Pawn.SelectedItem) != None) {
		iBoxLeft = -YL;
		iBoxTop  = Canvas.ClipY * 0.75 - YL * 4;

		if (numToShow == 1) {
			iBoxWidth  = YL * (1.2 + 1.6);
		} else {
			iBoxWidth  = YL * (1.2 + 1.6 * (numToShow - 1));
		}

		iBoxHeight = YL * 2.5;
		iBoxClipX  = iBoxWidth + iBoxLeft;

		//Draw Artifact HUD info
		Canvas.Drawcolor = class'Colors'.default.White;
		Canvas.SetPos(0, Canvas.ClipY * 0.75 - YL * 5.0);
		Canvas.DrawText(ViewportOwner.Actor.Pawn.SelectedItem.ItemName);

		Canvas.Style = 5;
 		Canvas.DrawColor = class'Colors'.default.Black;
 		Canvas.DrawColor.A = 212;
		Canvas.SetPos(iBoxLeft, iBoxTop);
		Canvas.DrawTileStretched(texture'UCGeneric.Black', iBoxWidth - YL * 0.1, iBoxHeight);

		Canvas.Style = 1;
		Canvas.DrawColor = class'HudCDeathmatchHelper'.static.GetHudTeamColor(ViewportOwner.Actor.Pawn);
		Canvas.SetPos(iBoxLeft, iBoxTop);
		Canvas.DrawTileStretched(Texture'InterfaceContent.Menu.ScoreBoxA', iBoxWidth, iBoxHeight);

		iconLeft   = YL * 0.09;
		iconTop    = Canvas.ClipY * 0.75 - YL * 3.78;
		iconWidth  = YL * 1.5;
		iconHeight = YL * 1.5;

		if (numToShow > 1) {
			iconLeft -= ((iconWidth + YL * 0.1) / 2);
		}

		iBoxOriginalLeft = iBoxLeft;

		// During scrolling, require one additional item to be shown.
		if (Transition != 0) {
			++numToShow;

			if (Direction >= 0) {
				iconLeft -= iconWidth + YL * 0.1;
			} else{
				firstInventory = FindPrevNthItem(StatsInv.DisplayItem, (numToShow / 2) - 1);
			}
			iconLeft += (Transition * Direction) * (iconWidth + YL * 0.1);
		}

		 if (firstInventory == None)
		 	  firstInventory = FindPrevNthItem(StatsInv.DisplayItem, (numToShow / 2));


		Canvas.FontScaleX *= 0.66666;
		Canvas.FontScaleY *= 0.66666;

		for (i = 0; i < numToShow; ++i) {
			if (iconLeft < iBoxClipX) {
				DrawItem(canvas, iconLeft, iconTop, iconWidth, iconHeight, YL, iBoxClipX, firstInventory);
			}

			firstInventory = FindNextNthItem(firstInventory, 1);

			iconLeft += iconWidth + YL * 0.1;
		}

		if (numToShow > 1) {
			iBoxOriginalLeft += YL * 0.25;

			for (i = 0; i < numToShow2; ++i) {
				Canvas.Style = 5;
		 		Canvas.DrawColor = class'Colors'.default.Black;

				if (i == halfToShow) {
					Canvas.DrawColor.A = 0;
				} else {
					Canvas.DrawColor.A = 148;
				}

				if (i == numToShow2 - 1) {
					Canvas.SetPos(iBoxOriginalLeft, iBoxTop + YL * 0.06);
					Canvas.DrawTileStretched(texture'UCGeneric.Black', (iconWidth + YL * 0.1) / 2.0 - YL * 0.15, iBoxHeight - YL * 0.2);
					Canvas.SetPos(iBoxOriginalLeft + (iconWidth + YL * 0.1) / 2.0 - YL * 0.15, iBoxTop + YL * 0.1);
					Canvas.DrawTileStretched(texture'UCGeneric.Black', YL * 0.3, iBoxHeight - YL * 0.2);
				} else {
					Canvas.SetPos(iBoxOriginalLeft, iBoxTop);
					Canvas.DrawTileStretched(texture'UCGeneric.Black', iconWidth + YL * 0.1, iBoxHeight);
				}

				iBoxOriginalLeft += iconWidth + YL * 0.1;
			}
		}

		Canvas.Style = 1;
		Canvas.DrawColor = class'Colors'.default.White;
		Canvas.SetPos(iBoxLeft, iBoxTop);
		Canvas.DrawTileStretched(Material'InterfaceContent.BorderBoxA', iBoxWidth, iBoxHeight);

		DrawItemDescription(Canvas, YL, ViewportOwner.Actor.Pawn.SelectedItem);
	}
}
////////////////////////////////////////////////////////////////
function Inventory FindNextNthItem(
	Inventory startInv,
	int       index
) {
	local Inventory inv;
	local Inventory firstInv;
	local int       invCount;
	local int       powerupCount;
	local bool      shouldCount;
	local bool      bIsPowerup;
	local int       sanity;

	if (index < 0) {
		FindPrevNthItem(startInv, -index);
	}

	// Verify that the inventory to start from actually exists within the
	// player's inventory.
	//##FIXME## This location contains a bug in the vanilla version
	//Change: Inv = startInv -> inv = startInv
	if (IsInInventory(startInv) == True) {
		inv = startInv;
	}

	if (inv == None) {
		inv = ViewportOwner.Actor.Pawn.SelectedItem;
	}

	if (inv == None) {
		inv = ViewportOwner.Actor.Pawn.Inventory;
	}

	if (inv == None) {
		return None;
	}

	firstInv     = inv;
	shouldCount  = true;
	invCount     = 0;
	powerupCount = 0;
	sanity       = 0;

	while (index > 0) {
		inv = inv.Inventory;

		// Wrap to the beginning of the inventory list.
		if (inv == None) {
			inv = ViewportOwner.Actor.Pawn.Inventory;

			if (inv == None) {
				return None;
			}
		}

		if (
			(inv.IsA('PowerUps') == true) &&
			(PowerUps(inv).bActivatable == true)
		) {
			bIsPowerup = true;
		} else {
			bIsPowerup = false;
		}

		if (bIsPowerUp == true) {
			--index;
		}

		if (shouldCount == true) {
			if (bIsPowerUp) {
				++powerupCount;
			}

			++invCount;
			++sanity;

			if (sanity > 1000) {
				return None;
			}

			if (inv == firstInv) {
				shouldCount = false;

				if (powerupCount == 0) {
					break;
				}

				// If this is an extremely high number, we can optimize now that
				// we know the size of the inventory.
				index = (index % powerupCount);
			}
		}
	}

	return inv;
}
////////////////////////////////////////////////////////////////
function Bool IsInInventory(
	Inventory toFind
) {
	local Inventory Inv;

	Inv = ViewportOwner.Actor.Pawn.Inventory;

	while (Inv != None) {
		if (Inv == toFind) {
			return true;
		}

		Inv = Inv.Inventory;
	}

	return false;
}
////////////////////////////////////////////////////////////////
function Inventory FindPrevNthItem(
	Inventory startInv,
	int       index
) {
	return FindNextNthItem(startInv, GetPowerupCount() - index);
}
////////////////////////////////////////////////////////////////
function DrawItem(
	Canvas    Canvas,
	Float     iconLeft,
	Float     iconTop,
	Float     iconWidth,
	Float     iconHeight,
	Float     YL,
	Float     iBoxClipX,
	Inventory inv
) {
//	local string remaining;
//	local float  stringWidth;
//	local float  stringHeight;
	local bool   bClipping;
	local float  iconMaterialWidth;
	local float  newIconWidth;

	iconMaterialWidth = inv.IconMaterial.MaterialUSize();

	if (iconLeft + iconWidth > iBoxClipX) {
		bClipping = true;

		newIconWidth = iBoxClipX - iconLeft;
		iconMaterialWidth *= (newIconWidth /iconWidth);
		iconWidth = newIconWidth;
	}

	Canvas.DrawColor = class'Colors'.default.White;

	if (inv.IconMaterial != None) {
		Canvas.Style = 6;
		Canvas.SetPos(iconLeft, iconTop);
		Canvas.DrawTile(inv.IconMaterial, iconWidth, iconHeight, 0, 0, iconMaterialWidth, inv.IconMaterial.MaterialVSize());
	}

	// if (
	// 	(bClipping == false) &&
	// 	(WeaponOfPowerArtifact(inv) != None)
	// ) {
	// 	remaining = "" $ WeaponOfPowerArtifact(inv).RemainingUses;
	//
	// 	Canvas.Style = 1;
	// 	Canvas.StrLen(remaining, stringWidth, stringHeight);
	// 	canvas.SetPos(iconLeft + (iconWidth - stringWidth) / 2.0 + YL * 0.05, iconTop + iconHeight + YL * 0.1);
	// 	canvas.DrawText(remaining);
	// }
}

////////////////////////////////////////////////////////////////////////////////

function DrawItemDescription(
	Canvas    Canvas,
	Float     YL,
	Inventory Inv
) {
	local float iBoxLeft;
	local float iBoxTop;
	local float iBoxWidth;
	local float iBoxHeight;
	local int   i;
	local float stringWidth;
	local float stringHeight;

	local array<string> descriptionText;
	local string        description;

	if (fInfoPosition > 0.0) {
		Canvas.StrLen("Test", stringWidth, stringHeight);

		iBoxLeft = -YL;
		iBoxTop  = Canvas.ClipY * 0.75 - YL * 1.3;
		iBoxWidth  = YL * 15.0;//prev 16.4
		iBoxHeight = stringHeight * 9;

		iBoxLeft -= (iBoxWidth + YL) * (1.0 - fInfoPosition);

		Canvas.Style = 5;
 		Canvas.DrawColor = class'Colors'.default.Black;
 		Canvas.DrawColor.A = 212;
		Canvas.SetPos(iBoxLeft, iBoxTop);
		Canvas.DrawTileStretched(texture'UCGeneric.Black', iBoxWidth - YL * 0.1, iBoxHeight);

		Canvas.Style = 1;
		Canvas.DrawColor = class'HudCDeathmatchHelper'.static.GetHudTeamColor(ViewportOwner.Actor.Pawn);
		Canvas.SetPos(iBoxLeft, iBoxTop);
		Canvas.DrawTileStretched(Texture'InterfaceContent.Menu.ScoreBoxA', iBoxWidth, iBoxHeight);

		// if (WeaponOfPowerArtifact(Inv) != None) {
		// 	description = WeaponOfPowerArtifact(Inv).Description;
		// } else
		if (RPGArtifact(Inv) != None) {
			// Add some descriptions to the rpg artifacts. Didn't feel like
			// creating derived classes for these.
			for (i = 0; i < RpgDescriptions.Length; ++i) {
				if (Inv.class == RpgDescriptions[i].ArtifactClass) {
					description = RpgDescriptions[i].Description;
					break;
				}
			}
		}

		if (description == "") {
			description = "No information available...";
		}

		Canvas.WrapStringToArray(description, descriptionText, iBoxWidth * 0.80, "|");//iBoxWidth + 3 * YL

		Canvas.DrawColor = class'Colors'.default.White;

		for (i = 0; i < descriptionText.Length; ++i) {
			Canvas.SetPos(iBoxLeft + YL * 1.2, iBoxTop + YL * 0.15 + stringHeight * i);
			Canvas.DrawText(descriptionText[i]);
		}

		Canvas.DrawColor.A = 255;
		Canvas.SetPos(iBoxLeft, iBoxTop);
		Canvas.DrawTileStretched(Material'InterfaceContent.BorderBoxA', iBoxWidth, iBoxHeight);
	}
}

function RPGStatsInv FindRPGStatsInv() {
	if (
		(ViewportOwner            == None) ||
		(ViewportOwner.Actor      == None) ||
		(ViewportOwner.Actor.Pawn == None)
	) {
		return None;
	}

	return RPGStatsInv(ViewportOwner.Actor.Pawn.FindInventoryType(class'RPGStatsInv'));
}

function int GetDistanceBetweenItems(
	Inventory current,
	Inventory to
) {
	local int       itemDistance;
	local Inventory first;

	itemDistance = 0;

	if (current == None) {
		return -1;
	}

	if (to == None) {
		return -2;
	}

	if (IsInInventory(current) == False) {
		return -3;
	}

	if (IsInInventory(to) == False) {
		return -4;
	}

	first = current;

	while (current != to) {
		if (
			(current.IsA('PowerUps') == true) &&
			(PowerUps(current).bActivatable == true)
		) {
			++itemDistance;
		}

		current = current.Inventory;

		if (first == current) {
			return 0;
		}

		if (current == None) {
			current = ViewportOwner.Actor.Pawn.Inventory;
		}
	}

	return itemDistance;
}
////////////////////////////////////////////////////////////////////////////////

function Tick(
	float fDeltaTime
) {
	local int         powerupCount;
	local RPGStatsInv RPGStatsInv;

	if (
		(ViewportOwner == None) ||
		(ViewportOwner.Actor == None) ||
		(ViewportOwner.Actor.Pawn == None)
	) {
		return;
	}

	if (ShowItemDescriptions == true) {
		if (fInfoPosition < 1.0) {
			fInfoPosition += 3 * fDeltaTime;
		}

		if (fInfoPosition > 1.0) {
			fInfoPosition = 1.0;
		}
	} else {
		if (fInfoPosition > 0.0) {
			fInfoPosition -= 3 * fDeltaTime;
		}

		if (fInfoPosition < 0.0) {
			fInfoPosition = 0.0;
		}
	}

	powerupCount = GetPowerupCount();
	RPGStatsInv  = FindRPGStatsInv();


	if (RPGStatsInv == None) {
		return;
	}

	//Log("This Ran");
	if (LastHeldCred != 0 && LastHeldCred != RPGStatsInv.Data.Credits)
	{
		bShowBonk = true;
		if(fDeltaTime - 3.0 > 0)
		{
		//Log("LastHeldCred:" @ LastHeldCred);
		bShowBonk=false;
		}
	}

	if (RPGStatsInv.CurrentItem == None) {
		if (RPGStatsInv.NextItem != None) {
			RPGStatsInv.CurrentItem = RPGStatsInv.NextItem;
			RPGStatsInv.NextItem    = RPGStatsInv.NextItem.Inventory;
		} else {
			RPGStatsInv.CurrentItem = ViewportOwner.Actor.Pawn.SelectedItem;
		}

		RPGStatsInv.DisplayItem = ViewportOwner.Actor.Pawn.SelectedItem;

	//if(ViewportOwner.Actor.Pawn.SelectedItem == None)
	//{
		Distance   = 0;
		Transition = 0.0;
	//}
	}
	if (RPGStatsInv.DisplayItem == None) {
		RPGStatsInv.DisplayItem = RPGStatsInv.CurrentItem;
	}

	 if(ViewportOwner.Actor.Pawn.SelectedItem == None)
	 	return;

	if (RPGStatsInv.NextItem == None) {
		RPGStatsInv.NextItem = RPGStatsInv.CurrentItem.Inventory;
	}

	if (
		(RPGStatsInv.CurrentItem != ViewportOwner.Actor.Pawn.SelectedItem) ||
		(RPGStatsInv.CurrentItem != RPGStatsInv.DisplayItem)
	) {
		Distance = GetDistanceBetweenItems(RPGStatsInv.DisplayItem, ViewportOwner.Actor.Pawn.SelectedItem);

	 	if (Distance < 0) {
			RPGStatsInv.CurrentItem = ViewportOwner.Actor.Pawn.SelectedItem;
			RPGStatsInv.DisplayItem = ViewportOwner.Actor.Pawn.SelectedItem;
			RPGStatsInv.NextItem    = None;
	 		Distance                = 0;
	 	}
	//
		if (Distance != 0) {
			if (Distance > (powerupCount / 2)) {
				// Scroll right
				Distance  = Distance - powerupCount;
				Direction = 1;
			} else {
				// Scroll left
				Direction = -1;
			}
		}

		RPGStatsInv.CurrentItem = ViewportOwner.Actor.Pawn.SelectedItem;
	}

	if (Distance != 0){
		Transition += ScrollSpeed * fDeltaTime;

		if (Transition >= 1.0) {
			if (Direction > 0) {
				RPGStatsInv.DisplayItem = FindPrevNthItem(RPGStatsInv.DisplayItem, Direction);
			} else {
				RPGStatsInv.DisplayItem = FindNextNthItem(RPGStatsInv.DisplayItem, -Direction);
			}

			Transition   = 0;
			Distance    += Direction;
		}

		if (Distance == 0) {
			RPGStatsInv.DisplayItem = RPGStatsInv.CurrentItem;
			RPGStatsInv.NextItem    = RPGStatsInv.DisplayItem.Inventory;
		}
	} else {
		if (Transition != 0) {
			Transition -= ScrollSpeed * fDeltaTime;

			if (Transition <= 0.0) {
				Transition = 0;
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

event NotifyLevelChange()
{
	//close stats menu if it's open
	FindStatsInv();
	if (StatsInv != None && StatsInv.StatsMenu != None)
		StatsInv.StatsMenu.CloseClick(None);
	StatsInv = None;

	//Save player data (standalone/listen servers only)
	if (RPGMut != None)
	{
		RPGMut.SaveData();
		RPGMut = None;
	}

	SaveConfig();
	Master.RemoveInteraction(self);
}

defaultproperties
{
		 RpgDescriptions(0)=(ArtifactClass=Class'LumpysRPG.ArtifactMagicWeaponMaker',Description="Change the modifier of your current weapon. Costs 100 Adrenaline",)
		 RpgDescriptions(1)=(ArtifactClass=Class'LumpysRPG.ArtifactFlight',Description="Use this and you'll be able to fly around the level while your adrenaline lasts.",)
		 //RpgDescriptions(2)=(ArtifactClass=Class'LumpysRPG.ArtifactTripleDamage',Description="Triple the damage dealt by your weapons while your adrenaline last.",)
		 //RpgDescriptions(3)=(ArtifactClass=Class'LumpysRPG.ArtifactLightningRod',Description="Shoots a bolt of lightning at any enemy that comes within your sights, dealing them damage.",)
		 //RpgDescriptions(4)=(ArtifactClass=Class'LumpysRPG.ArtifactTeleport',Description="Randomly teleports you around the levels for a quick escape.",)
		 //RpgDescriptions(5)=(ArtifactClass=Class'LumpysRPG.ArtifactMonsterSummon',Description="Summons a friendly monster that will fight on your behalf. Only you can kill your summoned monsters.||Monsters with green halos are yours, monsters with red are teammate summoned monsters.",)
		 ItemsToShow=3
		 ScrollSpeed=8.00
		 bRequiresTick=true
     bDefaultBindings=True
     bDefaultArtifactBindings=True
     EXPBarColor=(B=128,G=255,R=128,A=255)
     WhiteColor=(B=255,G=255,R=255,A=255)
		 GreenColor=(B=128,G=255,R=128,A=255)
     RedTeamTint=(R=100,A=100)
     BlueTeamTint=(B=102,G=66,R=37,A=150)
     LevelText="Level:"
     StatsMenuText="Press L for stats/levelup menu"
     ArtifactText="U to use, brackets to switch"
		 CreditText="Credits:"
     bVisible=True
}
