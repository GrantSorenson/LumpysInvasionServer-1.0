class WeaponInteraction extends Interaction config(WeaponsOfPower);

#EXEC OBJ LOAD FILE=WeaponsOfPowerTextures.utx

var WeaponsOfPower WopMutator;

const WEAPON_BAR_SIZE = 9;

// Used to precalculate values
var int X5, X6, X2, X7, X3;
var int Y14, Y6, Y4;
var float fScaleX, fScaleY;
var color TeamColor;
var float HudScaleOffset;
var Pawn HudOwner;
var float fAspectScale;

var bool bShowWeaponInformation;
var float fInfoAlpha;

////////////////////////////////////////////////////////////////////////////////

event Initialized() {
	if (ViewportOwner.Actor.Level.NetMode != NM_Client)
		foreach ViewportOwner.Actor.DynamicActors(class'WeaponsOfPower', WopMutator)
			break;
}

////////////////////////////////////////////////////////////////////////////////

function bool KeyEvent(
	EInputKey    key,
	EInputAction action,
	float        fDelta
) {
	local string strKeyName;
	local string strKeyBinding;

//	local WopStatsInv StatsInv;

    if (ViewPortOwner.Actor.Pawn == None) {
        return false;
    }

	strKeyName    = ViewportOwner.Actor.ConsoleCommand("KEYNAME"    @ key);
	strKeyBinding = ViewportOwner.Actor.ConsoleCommand("KEYBINDING" @ strKeyName);

	if (class'WeaponsOfPower'.default.EnableHud == false) {
		return false;
	}

//	if (strKeyBinding ~= "WopGetBigger") {
//		StatsInv = WopStatsInv(ViewportOwner.Actor.Pawn.FindInventoryType(class'WopStatsInv'));
//
//		if (StatsInv != None) {
//			StatsInv.GetBigger();
//		}
//
//		return true;
//	}
//
//	if (strKeyBinding ~= "WopGetSmaller") {
//		StatsInv = WopStatsInv(ViewportOwner.Actor.Pawn.FindInventoryType(class'WopStatsInv'));
//
//		if (StatsInv != None) {
//			StatsInv.GetSmaller();
//		}
//
//		return true;
//	}

	if (Action == IST_Press && strKeyBinding ~= "ResetWeapon") {
		if (
			(ViewportOwner.Actor.Pawn                       != None) &&
			(WeaponOfPower(ViewportOwner.Actor.Pawn.Weapon) != None)
		) {
			WeaponOfPower(ViewportOwner.Actor.Pawn.Weapon).RemoveModifiers();
		}

		return true;
	}

	if (Action == IST_Press && strKeyBinding ~= "UnloadWeapon") {
		if (
			(ViewportOwner.Actor.Pawn                       != None) &&
			(WeaponOfPower(ViewportOwner.Actor.Pawn.Weapon) != None)
		) {
			WeaponOfPower(ViewportOwner.Actor.Pawn.Weapon).ClientUnloadModifiers();
		}

		return true;
	}

	if (Action == IST_Press && strKeyBinding ~= "ToggleWeaponInfo") {
		bShowWeaponInformation = !bShowWeaponInformation;
		return true;
	}

	if (
		(ViewportOwner.Actor.Pawn                       != None) &&
		(WeaponOfPower(ViewportOwner.Actor.Pawn.Weapon) != None)
	) {
		if (WeaponOfPower(ViewportOwner.Actor.Pawn.Weapon).KeyEvent(key, action, strKeyBinding, fDelta)) {
			return true;
		}
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

function PostRender(Canvas canvas) {
	local WeaponOfPower weapon;

	if (class'WopRpgInteraction'.static.ShouldDisplayHud(ViewportOwner) == false) {
		return;
	}

	if (ViewportOwner.Actor.Pawn.PendingWeapon != None) {
		weapon = WeaponOfPower(ViewportOwner.Actor.Pawn.PendingWeapon);
	} else {
		weapon = WeaponOfPower(ViewportOwner.Actor.Pawn.Weapon);
	}

	HudOwner = ViewportOwner.Actor.Pawn;

	fAspectScale = (canvas.ClipX / canvas.ClipY) / 1.25;
	fScaleX = canvas.ClipX / 1280.0f * fAspectScale;
	fScaleY = canvas.ClipY / 1024.0f;

	X2  = 2  * fScaleX;
	X3  = 3  * fScaleX;
	X5  = 5  * fScaleX;
	X6  = 6  * fScaleX;
	X7  = 7  * fScaleX;
	Y4  = 4  * fScaleY;
	Y6  = 6  * fScaleY;
	Y14 = 14 * fScaleY;

	HudScaleOffset = 1 - (HudCDeathmatch(ViewportOwner.Actor.myHud).HudScale - 0.5) / 0.5;

	TeamColor = class'HudCDeathmatchHelper'.static.GetHudTeamColor(HudOwner);

	DrawWeaponPowerBars(canvas);
	DrawWeaponFireModes(canvas, weapon);

	if (weapon != None) {
		weapon.PostRender(canvas);

  		DrawWeaponInformation(canvas, weapon);
	}

	Canvas.Reset();
}

////////////////////////////////////////////////////////////////////////////////

function RenderFireModeSelection(
	Canvas         canvas,
	WeaponFireMode mode,
	int            iTop
) {
	local Pawn PawnOwner;

	PawnOwner = ViewportOwner.Actor.Pawn;

	canvas.DrawColor = class'Colors'.default.White;

	if (mode == None) {
		canvas.DrawColor.A = 64;
	}

	canvas.SetPos(X2, fScaleY * (iTop - 2));

	canvas.DrawTile(
		Material'HUDContent.Generic.HUD',
		58 * fScaleX,
		58 * fScaleY,
		122,
		261,
		54,
		54
	);

	canvas.DrawColor = TeamColor;

	if (mode == None) {
		canvas.DrawColor.A = 64;
	}

	canvas.SetPos(X3, fScaleY * (iTop + 1));

	canvas.DrawTile(
		Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud',
		53 * fScaleX,
		53 * fScaleY,
		1,
		18,
		50,
		50
	);

	if (mode != None) {
		canvas.DrawColor = class'Colors'.default.White;
		mode.DrawIcon(canvas, X3, fScaleY * iTop);
		mode.RenderOverlays(canvas);
	}
}

////////////////////////////////////////////////////////////////////////////////

function DrawWeaponFireModes(
	Canvas        canvas,
	WeaponOfPower weapon
) {
	local WeaponFireMode primary;
	local WeaponFireMode secondary;

	canvas.Style = 1;

	if (weapon != None) {
		primary   = weapon.CurrentPrimaryFireMode;
		secondary = weapon.CurrentAlternateFireMode;
	}

	RenderFireModeSelection(canvas, primary,   140);
	RenderFireModeSelection(canvas, secondary, 200);
}

////////////////////////////////////////////////////////////////////////////////

function DrawWeaponPowerBar(
	Canvas        canvas,
	WeaponOfPower Weapon,
	int           iPosition,
	int           iVerticalPosition,
	Weapon        PendingWeapon
) {
	local WeaponModifier Current;
	local int            iMaxSlots;
	local int            iCurrentSlot;
	local int            i;
	local float          fPosX;
	local float          fPosY;
	local color          HighlightColor;
	local color          ModifierColor;
	local bool           bIsCurrentWeapon;

	if (
		(Weapon               == None) ||
		(Weapon.GetMaxSlots() <= 0)
	) {
		return;
	}

	fPosY = canvas.ClipY - (64 * fScaleY);

	if (
		(Weapon == PendingWeapon) ||
		(
			(PendingWeapon == None) &&
			(Weapon        == ViewportOwner.Actor.Pawn.Weapon)
		)
	) {
		fPosY            -= (11 * fScaleY);
		HighlightColor   =  class'HudCDeathmatchHelper'.default.HudColorHighLight;
		bIsCurrentWeapon =  true;
	} else {
		HighlightColor   = TeamColor;
		bIsCurrentWeapon = false;
	}

	iMaxSlots = Weapon.GetMaxSlots();

	fPosY -= (iVerticalPosition * 8 * fScaleY);

	fPosX =
		canvas.ClipX * (
			class'HudCDeathmatchHelper'.static.GetBarBorder(iPosition).PosX +
			(
				class'HudCDeathmatchHelper'.static.GetBarBorderScaledPosition(iPosition) -
				class'HudCDeathmatchHelper'.static.GetBarBorder(iPosition).PosX
			) * HudScaleOffset
		) +
		fScaleX * (
			(
				class'HudCDeathmatchHelper'.static.GetBarBorder(iPosition).TextureCoords.X2 -
				class'HudCDeathmatchHelper'.static.GetBarBorder(iPosition).TextureCoords.X1
			) -
			(iMaxSlots * (8.0 / fAspectScale))
		) / fAspectScale
	;

	HighlightColor.A = 255;

	canvas.SetPos(fPosX, fPosY);
	canvas.DrawColor = HighlightColor;
	canvas.Style = 1;
	canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', X5, Y14, 0, 0, 5, 14);
	fPosX += X5;

	Current = Weapon.FirstModifier;

	iCurrentSlot = 0;

	while (
		(Current      != None)  &&
		(iCurrentSlot <  iMaxSlots)
	) {
		ModifierColor = Current.ModifierColor;

		// Dim the modifier display when this isn't the current weapon.
		if (bIsCurrentWeapon == false) {
			ModifierColor.A = 128;
		} else {
			ModifierColor.A = 255;
		}

		for (
			i = 0;
			(i < Current.GetSlotsUsed()) && (iCurrentSlot <  iMaxSlots);
			++i
		) {
			canvas.SetPos(fPosX, fPosY);
			canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', X6, Y14, 5, 0, 6, 14);
			canvas.DrawColor = ModifierColor;
			canvas.SetPos(fPosX, fPosY + Y4);
			canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', X6, Y6, 19, 4, 6, 6);
			canvas.DrawColor = HighlightColor;
			fPosX += X6;

			if (iCurrentSlot < iMaxSlots - 1) {
				canvas.SetPos(fPosX, fPosY);
				canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', X3, Y14, 11, 0, 1, 14);

				fPosX += X2;
			}

			++iCurrentSlot;
		}

		Current = Current.NextModifier;
	}

	while (iCurrentSlot < iMaxSlots) {
		canvas.SetPos(fPosX, fPosY);
		canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', X6, Y14, 5, 0, 6, 14);
		fPosX += X6;

		if (iCurrentSlot < iMaxSlots - 1) {
			canvas.SetPos(fPosX, fPosY);
			canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', X3, Y14, 11, 0, 1, 14);

			fPosX += X2;
		}

		++iCurrentSlot;
	}

	canvas.SetPos(fPosX, fPosY);
	canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', X5, Y14, 13, 0, 5, 14);
}

////////////////////////////////////////////////////////////////////////////////

function DrawWeaponPowerBars(
	Canvas canvas
) {
	local int       i;
	local int       Count;
	local int       iPosition;
	local Weapon    Weapons[WEAPON_BAR_SIZE];
	local Weapon    ExtraWeapons[WEAPON_BAR_SIZE];
	local Inventory tempInventory;
	local Weapon    tempWeapon;
	local Weapon    PendingWeapon;

	local HudCDeathmatch hud;

	hud = HudCDeathmatch(ViewportOwner.Actor.myHud);

	for (
		tempInventory = HudOwner.Inventory;
		tempInventory != None;
		tempInventory = tempInventory.Inventory
	) {
		tempWeapon = Weapon(tempInventory);

		if (++Count > 100) {
			break;
		}

		if (
			(tempweapon              == None) ||
			(tempweapon.IconMaterial == None)
		) {
			continue;
		}

		if (tempweapon.InventoryGroup == 0) {
			iPosition = 8;
		} else if (tempweapon.InventoryGroup < 10) {
			iPosition = tempweapon.InventoryGroup - 1;
		} else {
			continue;
		}

		if (Weapons[iPosition] != None) {
			ExtraWeapons[iPosition] = tempWeapon;
		} else {
			Weapons[iPosition] = tempWeapon;
		}
	}

	if (HudOwner.PendingWeapon != None) {
		PendingWeapon = HudOwner.PendingWeapon;
	} else {
		PendingWeapon = HudOwner.Weapon;
	}

	if (PendingWeapon != None) {
		if (PendingWeapon.InventoryGroup == 0) {
			Weapons[8] = PendingWeapon;
		} else if (PendingWeapon.InventoryGroup < 10) {
			Weapons[PendingWeapon.InventoryGroup - 1] = PendingWeapon;
		}
	}

	for (i = 0; i < WEAPON_BAR_SIZE; ++i) {
		if (
			(ExtraWeapons[i]                != None) &&
			(WeaponOfPower(ExtraWeapons[i]) != None) &&
			(PendingWeapon                  != None) &&
			(PendingWeapon.InventoryGroup   != Weapons[i].InventoryGroup)
		) {
			DrawWeaponPowerBar(
				canvas,
				WeaponOfPower(ExtraWeapons[i]),
				i,
				1,
				PendingWeapon
			);
		}

		if (
			(Weapons[i]                != None) &&
			(WeaponOfPower(Weapons[i]) != None)
		) {
			DrawWeaponPowerBar(
				canvas,
				WeaponOfPower(Weapons[i]),
				i,
				0,
				PendingWeapon
			);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function DrawWeaponInformation(
	Canvas        canvas,
	WeaponOfPower weapon
) {
	local WeaponModifier CurrentModifier;
	local float XL;
	local float YL;
	local float XMax;
	local float YMax;
	local float XPos;
	local float YPos;

	local int   SelLeft, i;
	local float SMOriginX;
	local float SMOriginY;
	local float SMMargin;
	local float SMLineSpace;
	local int   SMArraySize;
	local bool  bInserted;

	local array<WeaponModifier> Modifiers;

	Canvas.Reset();

	if (fInfoAlpha <= 0.0) {
		return;
	}

	// Update which font to use.
	canvas.Font = class'UT2MidGameFont'.static.GetMidGameFont(canvas.ClipX);

	// Figure out max key name size
	XMax = 0;
	YMax = 0;

	SMArraySize = 0;

	SMOriginX = 0.010000;
	SMOriginY = 0.300000;
	SMMargin  = 0.015000;

	XPos = Canvas.ClipX * (SMOriginX + SMMargin);
	YPos = Canvas.ClipY * (SMOriginY + SMMargin);

	canvas.TextSize(weapon.ItemName, XL, YL);
	XMax = Max(XMax, XPos + XL);

	CurrentModifier = weapon.FirstModifier;

	if (CurrentModifier == None) {
		YMax = YL;
	}

	while (CurrentModifier != None) {
		canvas.TextSize(CurrentModifier.GetName(), XL, YL);
		XMax = Max(XMax, XPos + XL);
		YMax = Max(YMax, YL);
		CurrentModifier = CurrentModifier.NextModifier;
		++SMArraySize;
	}

	SMLineSpace = YMax * 1.1;

	SelLeft = SMArraySize;

	// First we figure out how big the bounding box needs to be
	// XMax, YMax now contain to maximum bottom-right corner we drew to.

	// Then draw the box
	XMax = XMax - canvas.ClipX * SMOriginX;
	YMax = YPos + (SMLineSpace * SMArraySize) - canvas.ClipY * SMOriginY;
	canvas.SetDrawColor(255,255,255,255 * fInfoAlpha);
	canvas.SetPos(canvas.ClipX * SMOriginX, canvas.ClipY * SMOriginY);
	canvas.DrawTileStretched(texture 'InterfaceContent.Menu.BorderBoxD', XMax + (SMMargin * canvas.ClipX), YMax + (SMMargin * canvas.ClipY));

	XPos = Canvas.ClipX * (SMOriginX + SMMargin);
	YPos = Canvas.ClipY * (SMOriginY + SMMargin);

	// Then actually draw the stuff
	CurrentModifier = weapon.FirstModifier;

	while (CurrentModifier != None) {
		bInserted = false;

		for (i = 0; i < Modifiers.Length; ++i) {
			if (StrCmp(CurrentModifier.GetName(), Modifiers[i].GetName(),,false) < 0) {
				Modifiers.Insert(i, 1);
				Modifiers[i] = CurrentModifier;
				bInserted = true;
				break;
			}
		}

		if (bInserted == false) {
			Modifiers.Insert(Modifiers.Length, 1);
			Modifiers[Modifiers.Length - 1] = CurrentModifier;
		}

		CurrentModifier = CurrentModifier.NextModifier;
	}

	for (i = 0; i < Modifiers.Length; ++i) {
		canvas.DrawColor   = Modifiers[i].ModifierColor;
		canvas.DrawColor.A = 255 * fInfoAlpha;
		canvas.SetPos(XPos, YPos + X3);
		canvas.DrawTile(Material'WeaponsOfPowerTextures.HUD.WeaponsOfPowerHud', 2 * X6, 2 * Y6, 19, 4, 6, 6);

		canvas.SetDrawColor(128,255,128,255 * fInfoAlpha);
		canvas.SetPos(XPos + (4 * X5), YPos);
		canvas.DrawText(Modifiers[i].CurrentLevel $ " - " $ Modifiers[i].GetName(), false);

		YPos += SMLineSpace;
	}

	// Finally, draw a nice title bar.
	canvas.SetDrawColor(255, 255, 255, 255 * fInfoAlpha);
	canvas.SetPos(canvas.ClipX * SMOriginX, (canvas.ClipY * SMOriginY) - (1.5 * SMLineSpace));
	canvas.DrawTileStretched(texture 'InterfaceContent.Menu.BorderBoxD', XMax + (SMMargin * canvas.ClipX), (1.5 * SMLineSpace));

	canvas.SetDrawColor(255,255,128,255 * fInfoAlpha);
	canvas.SetPos(canvas.ClipX * (SMOriginX + SMMargin), (canvas.ClipY * SMOriginY) - (1.2 * SMLineSpace));
	canvas.DrawText(weapon.ItemName);
}

////////////////////////////////////////////////////////////////////////////////

event NotifyLevelChange() {
	Master.RemoveInteraction(self);
}

////////////////////////////////////////////////////////////////////////////////

function Tick(float fDeltaTime) {
	if (bShowWeaponInformation == true) {
		if (fInfoAlpha < 1.0) {
			fInfoAlpha += 3 * fDeltaTime;
		}

		if (fInfoAlpha > 1.0) {
			fInfoAlpha = 1.0;
		}
	} else {
		if (fInfoAlpha > 0.0) {
			fInfoAlpha -= 3 * fDeltaTime;
		}

		if (fInfoAlpha < 0.0) {
			fInfoAlpha = 0.0;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    bVisible=True
    bRequiresTick=True
}
