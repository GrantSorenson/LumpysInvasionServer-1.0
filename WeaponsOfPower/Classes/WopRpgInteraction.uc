class WopRpgInteraction extends RPGInteraction config(WeaponsOfPower);

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////

function WopStatsInv FindWopStatsInv() {
	if (
		(ViewportOwner            == None) ||
		(ViewportOwner.Actor      == None) ||
		(ViewportOwner.Actor.Pawn == None)
	) {
		return None;
	}

	return WopStatsInv(ViewportOwner.Actor.Pawn.FindInventoryType(class'WopStatsInv'));
}

////////////////////////////////////////////////////////////////////////////////

static function bool ShouldDisplayHud(
	Player ViewportOwner
) {
	local Pawn HudOwner;

	if (class'WeaponsOfPower'.default.EnableHud == false) {
		return false;
	}

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

////////////////////////////////////////////////////////////////////////////////

function bool KeyEvent(
	EInputKey    Key,
	EInputAction Action,
	float        Delta
) {
	local string strKeyBinding;

	if (Action != IST_Press) {
		return false;
	}

	if (super.KeyEvent(Key, Action, Delta) == True) {
		return true;
	}

	strKeyBinding = ViewportOwner.Actor.ConsoleCommand("KEYNAME" @ Key);
	strKeyBinding = ViewportOwner.Actor.ConsoleCommand("KEYBINDING" @ strKeyBinding);

	if (strKeyBinding ~= "ShowItemDescriptions") {
		ShowItemDescriptions = !ShowItemDescriptions;
		return true;
	}

	if (strKeyBinding ~= "ShowMoreItems") {
		ItemsToShow += 2;
		SaveConfig();
		return true;
	}

	if (strKeyBinding ~= "ShowLessItems") {
		if (ItemsToShow >= 3) {
			ItemsToShow -= 2;
			SaveConfig();
		}

		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

function PostRender(Canvas Canvas) {
	local float XL, YL, XLSmall, YLSmall, EXPBarX, EXPBarY;

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

	Canvas.DrawColor = class'Colors'.static.MultiplyColor(class'HudCDeathmatchHelper'.static.GetHudTeamColor(ViewportOwner.Actor.Pawn), 0.5);
	Canvas.DrawColor.A = 255;
	Canvas.SetPos(EXPBarX, EXPBarY);
	Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL, 15.0 * Canvas.FontScaleY, 836, 454, -386, 36);

	Canvas.DrawColor = class'Colors'.static.ScaleColor(class'HudCDeathmatchHelper'.static.GetHudTeamColor(ViewportOwner.Actor.Pawn), 1.0, 0.15);
	Canvas.SetPos(EXPBarX, EXPBarY);
	Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL * StatsInv.Data.Experience / StatsInv.Data.NeededExp, 15.0 * Canvas.FontScaleY, 836, 454, -386 * StatsInv.Data.Experience / StatsInv.Data.NeededExp, 36);

	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(EXPBarX, EXPBarY);
	Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL, 16.0 * Canvas.FontScaleY, 836, 415, -386, 38);

	Canvas.Style = 2;
	Canvas.DrawColor = WhiteColor;
	Canvas.SetPos(EXPBarX + 9.f * Canvas.FontScaleX, Canvas.ClipY * 0.75 - YL * 5.0);
	Canvas.DrawText(LevelText@StatsInv.Data.Level);
	Canvas.FontScaleX *= 0.75;
	Canvas.FontScaleY *= 0.75;
	Canvas.TextSize(StatsInv.Data.Experience$"/"$StatsInv.Data.NeededExp, XLSmall, YLSmall);
	Canvas.SetPos(Canvas.ClipX - XL * 0.5 - XLSmall * 0.5, Canvas.ClipY * 0.75 - YL * 3.75 + 12.5 * Canvas.FontScaleY - YLSmall * 0.5);
	Canvas.DrawText(StatsInv.Data.Experience$"/"$StatsInv.Data.NeededExp);

	DrawInventory(Canvas, YL);

	Canvas.FontScaleX = Canvas.default.FontScaleX;
	Canvas.FontScaleY = Canvas.default.FontScaleY;
}

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////

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
	if (IsInInventory(startInv) == True) {
		Inv = startInv;
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

////////////////////////////////////////////////////////////////////////////////

function Inventory FindPrevNthItem(
	Inventory startInv,
	int       index
) {
	return FindNextNthItem(startInv, GetPowerupCount() - index);
}

////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////

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
	local WopStatsInv WopStatsInv;

	if ((ItemsToShow % 2) == 0) {
		++ItemsToShow;
	}

	WopStatsInv  = FindWopStatsInv();

	if (WopStatsInv == None) {
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
			} else {
				firstInventory = FindPrevNthItem(WopStatsInv.DisplayItem, (numToShow / 2) - 1);//WopStatsInv.DisplayItem
			}

			iconLeft += (Transition * Direction) * (iconWidth + YL * 0.1);
		}

		if (firstInventory == None) {
			firstInventory = FindPrevNthItem(WopStatsInv.DisplayItem, (numToShow / 2));
		}

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

////////////////////////////////////////////////////////////////////////////////

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
	local string remaining;
	local float  stringWidth;
	local float  stringHeight;
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

	if (
		(bClipping == false) &&
		(WeaponOfPowerArtifact(inv) != None)
	) {
		remaining = "" $ WeaponOfPowerArtifact(inv).RemainingUses;

		Canvas.Style = 1;
		Canvas.StrLen(remaining, stringWidth, stringHeight);
		canvas.SetPos(iconLeft + (iconWidth - stringWidth) / 2.0 + YL * 0.05, iconTop + iconHeight + YL * 0.1);
		canvas.DrawText(remaining);
	}
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

		if (WeaponOfPowerArtifact(Inv) != None) {
			description = WeaponOfPowerArtifact(Inv).Description;
		} else if (RPGArtifact(Inv) != None) {
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

////////////////////////////////////////////////////////////////////////////////

function Tick(
	float fDeltaTime
) {
	local int         powerupCount;
	local WopStatsInv WopStatsInv;

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
	WopStatsInv  = FindWopStatsInv();

	if (WopStatsInv == None) {
		return;
	}

	if (WopStatsInv.CurrentItem == None) {
		if (WopStatsInv.NextItem != None) {
			WopStatsInv.CurrentItem = WopStatsInv.NextItem;
			WopStatsInv.NextItem    = WopStatsInv.NextItem.Inventory;
		} else {
			WopStatsInv.CurrentItem = ViewportOwner.Actor.Pawn.SelectedItem;
		}

		WopStatsInv.DisplayItem = ViewportOwner.Actor.Pawn.SelectedItem;

		Distance   = 0;
		Transition = 0.0;
	}

	if (WopStatsInv.DisplayItem == None) {
		WopStatsInv.DisplayItem = WopStatsInv.CurrentItem;
	}

	if (WopStatsInv.CurrentItem == None) {
		return;
	}

	if (WopStatsInv.NextItem == None) {
		WopStatsInv.NextItem = WopStatsInv.CurrentItem.Inventory;
	}

	if (
		(WopStatsInv.CurrentItem != ViewportOwner.Actor.Pawn.SelectedItem) ||
		(WopStatsInv.CurrentItem != WopStatsInv.DisplayItem)
	) {
		Distance = GetDistanceBetweenItems(WopStatsInv.DisplayItem, ViewportOwner.Actor.Pawn.SelectedItem);

		if (Distance < 0) {
			WopStatsInv.CurrentItem = ViewportOwner.Actor.Pawn.SelectedItem;
			WopStatsInv.DisplayItem = ViewportOwner.Actor.Pawn.SelectedItem;
			WopStatsInv.NextItem    = None;
			Distance                = 0;
		}

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

		WopStatsInv.CurrentItem = ViewportOwner.Actor.Pawn.SelectedItem;
	}

	if (Distance != 0) {
		Transition += ScrollSpeed * fDeltaTime;

		if (Transition >= 1.0) {
			if (Direction > 0) {
				WopStatsInv.DisplayItem = FindPrevNthItem(WopStatsInv.DisplayItem, Direction);
			} else {
				WopStatsInv.DisplayItem = FindNextNthItem(WopStatsInv.DisplayItem, -Direction);
			}

			Transition   = 0;
			Distance    += Direction;
		}

		if (Distance == 0) {
			WopStatsInv.DisplayItem = WopStatsInv.CurrentItem;
			WopStatsInv.NextItem    = WopStatsInv.DisplayItem.Inventory;
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

defaultproperties
{
    ItemsToShow=5
    ScrollSpeed=8.00
		RpgDescriptions(0)=(ArtifactClass=Class'ArtifactInvulnerability',Description="While active you will be invincible but your adrenaline will drain quickly.||Note that falling off levels and into death volumes will still kill you.",)
		RpgDescriptions(1)=(ArtifactClass=Class'ArtifactFlight',Description="Use this and you'll be able to fly around the level while your adrenaline lasts.",)
		RpgDescriptions(2)=(ArtifactClass=Class'ArtifactTripleDamage',Description="Triple the damage dealt by your weapons while your adrenaline last.",)
		RpgDescriptions(3)=(ArtifactClass=Class'ArtifactLightningRod',Description="Shoots a bolt of lightning at any enemy that comes within your sights, dealing them damage.",)
	//	RpgDescriptions(4)=(ArtifactClass=Class'ArtifactTeleport',Description="Randomly teleports you around the levels for a quick escape.",)
		//RpgDescriptions(5)=(ArtifactClass=Class'ArtifactMonsterSummon',Description="Summons a friendly monster that will fight on your behalf. Only you can kill your summoned monsters.||Monsters with green halos are yours, monsters with red are teammate summoned monsters.",)

//     RpgDescriptions=[0]=(ArtifactClass (Object) = Class'UT2004RPG.ArtifactInvulnerability',Description (Str) = "While active you will be invincible but your adrenaline will drain quickly.||Note that falling off levels and into death volumes will still kill you.",)
// [1]=(ArtifactClass (Object) = Class'UT2004RPG.ArtifactFlight',Description (Str) = "Use this and you'll be able to fly around the level while your adrenaline lasts.",)
// [2]=(ArtifactClass (Object) = Class'UT2004RPG.ArtifactTripleDamage',Description (Str) = "Triple the damage dealt by your weapons while your adrenaline last.",)
// [3]=(ArtifactClass (Object) = Class'UT2004RPG.ArtifactLightningRod',Description (Str) = "Shoots a bolt of lightning at any enemy that comes within your sights, dealing them damage.",)
// [4]=(ArtifactClass (Object) = Class'UT2004RPG.ArtifactTeleport',Description (Str) = "Randomly teleports you around the levels for a quick escape.",)
// [5]=(ArtifactClass (Object) = Class'UT2004RPG.ArtifactMonsterSummon',Description (Str) = "Summons a friendly monster that will fight on your behalf. Only you can kill your summoned monsters.||Monsters with green halos are yours, monsters with red are teammate summoned monsters.",)
     bRequiresTick=True
}
