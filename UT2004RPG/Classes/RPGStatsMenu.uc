class RPGStatsMenu extends GUIPage
	DependsOn(RPGStatsInv);

var RPGStatsInv StatsInv;

var moEditBox WeaponSpeedBox, HealthBonusBox, AdrenalineMaxBox, AttackBox, DefenseBox, AmmoMaxBox, PointsAvailableBox;
var GUIEditBox WeaponSpeedAmt, HealthBonusAmt, AdrenalineMaxAmt, AttackAmt, DefenseAmt,MaxAmmoAmt;
//Index of first stat display, first + button and first numeric edit in controls array
var int StatDisplayControlsOffset, ButtonControlsOffset, AmtControlsOffset, StatPlusHold;
var int NumButtonControls;
var GUIListBox Abilities;
var localized string CurrentLevelText, MaxText, CostText, CantBuyText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	WeaponSpeedBox = moEditBox(Controls[2]);
	HealthBonusBox = moEditBox(Controls[3]);
	AdrenalineMaxBox = moEditBox(Controls[4]);
	AttackBox = moEditBox(Controls[5]);
	DefenseBox = moEditBox(Controls[6]);
	AmmoMaxBox = moEditBox(Controls[7]);
	PointsAvailableBox = moEditBox(Controls[8]);
	Abilities = GUIListBox(Controls[16]);
	//Fixed
	WeaponSpeedAmt = GUIEditBox(Controls[19]);
	HealthBonusAmt = GUIEditBox(Controls[20]);
	AdrenalineMaxAmt = GUIEditBox(Controls[21]);
	AttackAmt = GUIEditBox(Controls[22]);
	DefenseAmt = GUIEditBox(Controls[23]);
	MaxAmmoAmt = GUIEditBox(Controls[24]);
	//hide
	HideAbilityControls();

}

function bool CloseClick(GUIComponent Sender)
{
	Controller.CloseMenu(false);

	return true;
}

function MyOnClose(optional bool bCanceled)
{
	if (StatsInv != None)
	{
		StatsInv.StatsMenu = None;
		StatsInv = None;
	}

	Super.OnClose(bCanceled);
}

function bool LevelsClick(GUIComponent Sender)
{
	Controller.OpenMenu("UT2004RPG.RPGPlayerLevelsMenu");
	StatsInv.ProcessPlayerLevel = RPGPlayerLevelsMenu(Controller.TopPage()).ProcessPlayerLevel;
	StatsInv.ServerRequestPlayerLevels();

	return true;
}

//Initialize, using the given RPGStatsInv for the stats data and for client->server function calls
function InitFor(RPGStatsInv Inv)
{
	local int x, y, Index, Cost, Level, OldAbilityListIndex, OldAbilityListTop;
	local RPGPlayerDataObject TempDataObject;

	StatsInv = Inv;
	StatsInv.StatsMenu = self;

	//GUIScrollTextBox(Controls[31]).MyScrollText.SetContent("oijfsdnflskmf");
	WeaponSpeedAmt.SetText(string(Min(0,StatsInv.Data.PointsAvailable)));
	HealthBonusAmt.SetText(string(Min(0,StatsInv.Data.PointsAvailable)));
	AdrenalineMaxAmt.SetText(string(Min(0,StatsInv.Data.PointsAvailable)));
	AttackAmt.SetText(string(Min(0,StatsInv.Data.PointsAvailable)));
	DefenseAmt.SetText(string(Min(0,StatsInv.Data.PointsAvailable)));
	MaxAmmoAmt.SetText(string(Min(0,StatsInv.Data.PointsAvailable)));
	//============================
	WeaponSpeedBox.SetText(string(StatsInv.Data.WeaponSpeed));
	HealthBonusBox.SetText(string(StatsInv.Data.HealthBonus));
	AdrenalineMaxBox.SetText(string(StatsInv.Data.AdrenalineMax));
	AttackBox.SetText(string(StatsInv.Data.Attack));
	DefenseBox.SetText(string(StatsInv.Data.Defense));
	AmmoMaxBox.SetText(string(StatsInv.Data.AmmoMax));
	PointsAvailableBox.SetText(string(StatsInv.Data.PointsAvailable));
	//GUILabel(Controls[27]).Caption = GUILabel(default.Controls[27]).Caption @ string(StatsInv.Data.Level);
	//GUILabel(Controls[28]).Caption = GUILabel(default.Controls[28]).Caption @ string(StatsInv.Data.Experience) $ "/" $ string(StatsInv.Data.NeededExp);

	if (StatsInv.Data.PointsAvailable <= 0)
		DisablePlusButtons();
	else
		EnablePlusButtons();

	//show/hide buttons if stat caps reached
	for (x = 0; x < 6; x++)
		if ( StatsInv.StatCaps[x] >= 0
		     && int(moEditBox(Controls[StatDisplayControlsOffset+x]).GetText()) >= StatsInv.StatCaps[x] )
		{
			Controls[ButtonControlsOffset+x].SetVisibility(false);
			Controls[AmtControlsOffset+x].SetVisibility(false);
		}

	// on a client, the data object doesn't exist, so make a temporary one for calling the abilities' functions
	if (StatsInv.Role < ROLE_Authority)
	{
		TempDataObject = RPGPlayerDataObject(StatsInv.Level.ObjectPool.AllocateObject(class'RPGPlayerDataObject'));
		TempDataObject.InitFromDataStruct(StatsInv.Data);
	}
	else
	{
		TempDataObject = StatsInv.DataObject;
	}

	//Fill the ability listbox
	OldAbilityListIndex = Abilities.List.Index;
	OldAbilityListTop = Abilities.List.Top;
	Abilities.List.Clear();
	for (x = 0; x < StatsInv.AllAbilities.length; x++)
	{
		Index = -1;
		for (y = 0; y < StatsInv.Data.Abilities.length; y++)
			if (StatsInv.AllAbilities[x] == StatsInv.Data.Abilities[y])
			{
				Index = y;
				y = StatsInv.Data.Abilities.length;
			}
		if (Index == -1)
			Level = 0;
		else
			Level = StatsInv.Data.AbilityLevels[Index];

		if (Level >= StatsInv.AllAbilities[x].default.MaxLevel)
			Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level@"["$MaxText$"])", StatsInv.AllAbilities[x], string(Cost));
		else
		{
			Cost = StatsInv.AllAbilities[x].static.Cost(TempDataObject, Level);

			if (Cost <= 0)
				Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CantBuyText$")", StatsInv.AllAbilities[x], string(Cost));
			else
				Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
		}
	}
	//restore list's previous state
	Abilities.List.SetIndex(OldAbilityListIndex);
	Abilities.List.SetTopItem(OldAbilityListTop);
	UpdateAbilityButtons(Abilities);

	// free the temporary data object on clients
	if (StatsInv.Role < ROLE_Authority)
	{
		StatsInv.Level.ObjectPool.FreeObject(TempDataObject);
	}
}

function bool WepSpeedClick(GUIComponent Sender)
{
	local int value;

	value = int(GUIEditBox(Controls[19]).GetText());
	DisablePlusButtons();
	StatsInv.ServerAddPointTo(value,EStatType(0));
//	InitFor(StatsInv);
	return true;
}

function bool HealthBonusClick(GUIComponent Sender)
{
	local int value;

	value = int(GUIEditBox(Controls[20]).GetText());
	DisablePlusButtons();
	StatsInv.ServerAddPointTo(value,EStatType(1));
//	InitFor(StatsInv);
	return true;
}

function bool AdrenalineMaxClick(GUIComponent Sender)
{
	local int value;

	value = int(GUIEditBox(Controls[21]).GetText());
	DisablePlusButtons();
	StatsInv.ServerAddPointTo(value,EStatType(2));
	//InitFor(StatsInv);
	return true;
}

function bool AttackBonusClick(GUIComponent Sender)
{
	local int value;

	value = int(GUIEditBox(Controls[22]).GetText());
	DisablePlusButtons();
	StatsInv.ServerAddPointTo(value,EStatType(3));
	//InitFor(StatsInv);
	return true;
}

function bool DefenseBonusClick(GUIComponent Sender)
{
	local int value;

	value = int(GUIEditBox(Controls[23]).GetText());
	DisablePlusButtons();
	StatsInv.ServerAddPointTo(value,EStatType(4));
	//InitFor(StatsInv);
	return true;
}

function bool AmmoMaxClick(GUIComponent Sender)
{
	local int value;

	value = int(GUIEditBox(Controls[24]).GetText());
	DisablePlusButtons();
	StatsInv.ServerAddPointTo(value,EStatType(5));
	//InitFor(StatsInv);
	return true;
}
/* why doesnt this work? the workaround hurts
function bool StatPlusClick(GUIComponent Sender)
{
	local int x, SenderIndex, stat;

//get the control location for buttons and check to see if it matches sender
	for (x = 9; x <= 14; x++)
		if (Controls[x] == Sender)
		{
			SenderIndex = x;//set our sender index
			break;
		}
//offset the index by the starting index to get values between 0-5(total amount of stat types and the correspongding stat to increase)
  stat = SenderIndex;
	//we have the stat index and control, we need to find the connexted guiedit with the increase value
	//gui edit boxes are in controls 19-24
	SenderIndex += 10;
	StatPlusHold = int(GUIEditBox(Controls[SenderIndex]).GetText());
	DisablePlusButtons();
	StatsInv.ServerAddPointTo(StatPlusHold, EStatType(stat));
	InitFor(StatsInv);
	return true;
}
*/
function DisablePlusButtons()
{
	local int x;

	for (x = 9; x < 15; x++)
		Controls[x].MenuStateChange(MSAT_Disabled);
}

function EnablePlusButtons()
{
	local int x;

	for (x = ButtonControlsOffset; x < ButtonControlsOffset + NumButtonControls; x++)
		Controls[x].MenuStateChange(MSAT_Blurry);

	for (x = 19; x < 25; x++)
	{
		if (StatsInv.Data.PointsAvailable < StatPlusHold)
			GUIEditBox(Controls[x]).SetText(string(StatsInv.Data.PointsAvailable));
		//newGUINumericEdit(Controls[x]).CalcMaxLen();
		else
			GUIEditBox(Controls[x]).SetText(string(StatPlusHold));
	}
}

function bool UpdateAbilityButtons(GUIComponent Sender)
{
	local int Cost;

	Cost = int(Abilities.List.GetExtra());
	if (Cost <= 0 || Cost > StatsInv.Data.PointsAvailable)
		Controls[18].MenuStateChange(MSAT_Disabled);
	else
{
		Controls[18].MenuStateChange(MSAT_Blurry);
}
	ShowAbilityInfo();

	return true;
}

function bool ShowAbilityDesc(GUIComponent Sender)
{
	local class<RPGAbility> Ability;

	Ability = class<RPGAbility>(Abilities.List.GetObject());
	Controller.OpenMenu("UT2004RPG.RPGAbilityDescMenu");
	RPGAbilityDescMenu(Controller.TopPage()).t_WindowTitle.Caption = Ability.default.AbilityName;
	RPGAbilityDescMenu(Controller.TopPage()).MyScrollText.SetContent(Ability.default.Description);

	return true;
}

function bool BuyAbility(GUIComponent Sender)
{
	DisablePlusButtons();
	Controls[18].MenuStateChange(MSAT_Disabled);
	StatsInv.ServerAddAbility(class<RPGAbility>(Abilities.List.GetObject()));

	return true;
}

function bool ResetClick(GUIComponent Sender)
{
	Controller.OpenMenu("UT2004RPG.RPGResetConfirmPage");
	RPGResetConfirmPage(Controller.TopPage()).StatsMenu = self;
	return true;
}
function bool StatsClick(GUIComponent Sender)
{
	HideAbilityControls();
	ShowStatControls();
	return true;
}
function bool AbilitiesClick(GUIComponent Sender)
{
	HideStatControls();
	ShowAbilityControls();
	return true;
}
function ShowStatControls()
{
	local int x;

	for (x = 2; x < 8; x++)
		{
			Controls[x].Show();
		}
	for (x = 9; x < 15; x++)
		{
			Controls[x].Show();
		}
	for (x = 19; x < 25; x++)
	{
		Controls[x].Show();
	}
	InitFor(StatsInv);
}
function HideStatControls()
{
	local int x;

	for (x = 2; x < 8; x++)
		{
			Controls[x].Hide();
		}
	for (x = 9; x < 15; x++)
		{
			Controls[x].Hide();
		}
	for (x = 19; x < 25; x++)
	{
		Controls[x].Hide();
	}
}

function ShowAbilityControls()
{
	Controls[16].Show();
	Controls[18].Show();
	Controls[17].Show();
	Controls[29].Show();
}
function HideAbilityControls()
{
	Controls[16].Hide();
	Controls[18].Hide();
	Controls[17].Hide();
	Controls[29].Hide();
}
function bool ShowAbilityInfo(optional GUIComponent Sender)
{
	local string Info;
	local class<RPGAbility> Ability;
	local GUIScrollTextBox AbilityInfo;

	AbilityInfo = GUIScrollTextBox(Controls[29]);
	AbilityInfo.MyScrollBar.WinWidth = 0.01;

	Ability = class<RPGAbility>(Abilities.List.GetObject());
	if (Ability == None)
	{
		return true;
	}

	Info = Ability.default.Description;

	AbilityInfo.SetContent(Info);

	return true;
}
defaultproperties
{
     StatDisplayControlsOffset=2
     ButtonControlsOffset=9
     AmtControlsOffset=19
     NumButtonControls=6
     CurrentLevelText="Current Level:"
     MaxText="MAX"
     CostText="Cost:"
     CantBuyText="Can't Buy"
     bRenderWorld=True
     bAllowedAsLast=True
     OnClose=RPGStatsMenu.MyOnClose

     Begin Object Class=FloatingImage Name=FloatingFrameBackground
         Image=Texture'LumpysTextures.MenuTextures.MenuDisplay01'//2K4Menus.CustomControls.CustomDisplay2
         DropShadow=None
         ImageStyle=ISTY_Stretched
         ImageRenderStyle=MSTY_Normal
				 WinWidth=1.500000
		 		WinHeight=0.700000
		 		WinLeft=-0.285590
		 		WinTop=0.168519
         RenderWeight=0.000003
     End Object
     Controls(0)=FloatingImage'UT2004RPG.RPGStatsMenu.FloatingFrameBackground'

     Begin Object Class=GUIButton Name=CloseButton
         Caption="Close"
         WinTop=0.900000
         WinLeft=0.550000
         WinWidth=0.200000
         OnClick=RPGStatsMenu.CloseClick
         OnKeyEvent=CloseButton.InternalOnKeyEvent
     End Object
     Controls(1)=GUIButton'UT2004RPG.RPGStatsMenu.CloseButton'

     Begin Object Class=moEditBox Name=WeaponSpeedSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Weapon Speed Bonus (%)"
         OnCreateComponent=WeaponSpeedSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.200000
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(2)=moEditBox'UT2004RPG.RPGStatsMenu.WeaponSpeedSelect'

     Begin Object Class=moEditBox Name=HealthBonusSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Health Bonus"
         OnCreateComponent=HealthBonusSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.300000
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(3)=moEditBox'UT2004RPG.RPGStatsMenu.HealthBonusSelect'

     Begin Object Class=moEditBox Name=AdrenalineMaxSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Max Adrenaline"
         OnCreateComponent=AdrenalineMaxSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(4)=moEditBox'UT2004RPG.RPGStatsMenu.AdrenalineMaxSelect'

     Begin Object Class=moEditBox Name=AttackSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Damage Bonus (0.5%)"
         OnCreateComponent=AttackSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(5)=moEditBox'UT2004RPG.RPGStatsMenu.AttackSelect'

     Begin Object Class=moEditBox Name=DefenseSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Damage Reduction (0.5%)"
         OnCreateComponent=DefenseSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.600000
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(6)=moEditBox'UT2004RPG.RPGStatsMenu.DefenseSelect'

     Begin Object Class=moEditBox Name=MaxAmmoSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Max Ammo Bonus (%)"
         OnCreateComponent=MaxAmmoSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.700000
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(7)=moEditBox'UT2004RPG.RPGStatsMenu.MaxAmmoSelect'

     Begin Object Class=moEditBox Name=PointsAvailableSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Stat Points Available"
         OnCreateComponent=PointsAvailableSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
				 WinWidth=0.226851
		 		WinHeight=0.030000
		 		WinLeft=0.338146
		 		WinTop=0.799510
     End Object
     Controls(8)=moEditBox'UT2004RPG.RPGStatsMenu.PointsAvailableSelect'
//=======================Control plus buttons============================9-14
     Begin Object Class=GUIButton Name=WeaponSpeedButton
         Caption="+"
         WinTop=0.200000
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.WepSpeedClick
         OnKeyEvent=WeaponSpeedButton.InternalOnKeyEvent
     End Object
     Controls(9)=GUIButton'UT2004RPG.RPGStatsMenu.WeaponSpeedButton'

     Begin Object Class=GUIButton Name=HealthBonusButton
         Caption="+"
         WinTop=0.300000
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.HealthBonusClick
         OnKeyEvent=HealthBonusButton.InternalOnKeyEvent
     End Object
     Controls(10)=GUIButton'UT2004RPG.RPGStatsMenu.HealthBonusButton'

     Begin Object Class=GUIButton Name=AdrenalineMaxButton
         Caption="+"
         WinTop=0.400000
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.AdrenalineMaxClick
         OnKeyEvent=AdrenalineMaxButton.InternalOnKeyEvent
     End Object
     Controls(11)=GUIButton'UT2004RPG.RPGStatsMenu.AdrenalineMaxButton'

     Begin Object Class=GUIButton Name=AttackButton
         Caption="+"
         WinTop=0.500000
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.AttackBonusClick
         OnKeyEvent=AttackButton.InternalOnKeyEvent
     End Object
     Controls(12)=GUIButton'UT2004RPG.RPGStatsMenu.AttackButton'

     Begin Object Class=GUIButton Name=DefenseButton
         Caption="+"
         WinTop=0.600000
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.DefenseBonusClick
         OnKeyEvent=DefenseButton.InternalOnKeyEvent
     End Object
     Controls(13)=GUIButton'UT2004RPG.RPGStatsMenu.DefenseButton'

     Begin Object Class=GUIButton Name=AmmoMaxButton
         Caption="+"
         WinTop=0.700000
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.AmmoMaxClick
         OnKeyEvent=AmmoMaxButton.InternalOnKeyEvent
     End Object
     Controls(14)=GUIButton'UT2004RPG.RPGStatsMenu.AmmoMaxButton'
//=========================End control plus buttons=============================
     Begin Object Class=GUIButton Name=LevelsButton
         Caption="Levels"
				 WinWidth=0.085000
				 WinHeight=0.125000
				 WinLeft=0.065000
				 WinTop=0.650000
         OnClick=RPGStatsMenu.LevelsClick
         OnKeyEvent=LevelsButton.InternalOnKeyEvent
     End Object
     Controls(15)=GUIButton'UT2004RPG.RPGStatsMenu.LevelsButton'
//Start Ability Controls=======================================
     Begin Object Class=GUIListBox Name=AbilityList
         bVisibleWhenEmpty=True
         OnCreateComponent=AbilityList.InternalOnCreateComponent
         StyleName="AbilityList"
         Hint="These are the abilities you can purchase with stat points."
				 WinWidth=0.435000
		 		 WinHeight=0.300000
		 		 WinLeft=0.200417
		 		 WinTop=0.180000
         OnClick=RPGStatsMenu.UpdateAbilityButtons
     End Object
     Controls(16)=GUIListBox'UT2004RPG.RPGStatsMenu.AbilityList'

     Begin Object Class=GUIButton Name=AbilityDescButton
         Caption="Refund"
				 WinWidth=0.100000
		 		 WinHeight=0.100000
 			   WinLeft=0.791990
		 		 WinTop=0.690571
         OnClick=RPGStatsMenu.ShowAbilityInfo
         OnKeyEvent=AbilityDescButton.InternalOnKeyEvent
     End Object
     Controls(17)=GUIButton'UT2004RPG.RPGStatsMenu.AbilityDescButton'

     Begin Object Class=GUIButton Name=AbilityBuyButton
         Caption="Buy"
				 WinWidth=0.100000
		 		 WinHeight=0.100000
		 		 WinLeft=0.687888
		 		 WinTop=0.690571
         OnClick=RPGStatsMenu.BuyAbility
         OnKeyEvent=AbilityBuyButton.InternalOnKeyEvent
     End Object
     Controls(18)=GUIButton'UT2004RPG.RPGStatsMenu.AbilityBuyButton'

// End Ability Controls==========================================
     Begin Object Class=GUIEditBox Name=WeaponSpeedThing
         //Value="5"
         //MinValue=1
         //MaxValue=5
         WinTop=0.20000
         WinLeft=0.645000
         WinWidth=0.080000
         //OnDeActivate=WeaponSpeedAmt.ValidateValue
     End Object
     Controls(19)=GUIEditBox'UT2004RPG.RPGStatsMenu.WeaponSpeedThing'

     Begin Object Class=GUIEditBox Name=HealthBonusThing
         //Value="5"
        // MinValue=1
         //MaxValue=5
         WinTop=0.300000
         WinLeft=0.645000
         WinWidth=0.080000
         //OnDeActivate=HealthBonusAmt.ValidateValue
     End Object
     Controls(20)=GUIEditBox'UT2004RPG.RPGStatsMenu.HealthBonusThing'

     Begin Object Class=GUIEditBox Name=AdrenalineMaxThing
         //Value="5"
         //MinValue=1
         //MaxValue=5
         WinTop=0.400000
         WinLeft=0.645000
         WinWidth=0.080000
         //OnDeActivate=AdrenalineMaxAmt.ValidateValue
     End Object
     Controls(21)=GUIEditBox'UT2004RPG.RPGStatsMenu.AdrenalineMaxThing'

     Begin Object Class=GUIEditBox Name=AttackThing
         //Value="5"
         //MinValue=1
         //MaxValue=5
         WinTop=0.500000
         WinLeft=0.645000
         WinWidth=0.080000
         //OnDeActivate=AttackAmt.ValidateValue
     End Object
     Controls(22)=GUIEditBox'UT2004RPG.RPGStatsMenu.AttackThing'

     Begin Object Class=GUIEditBox Name=DefenseThing
         //Value="5"
         //MinValue=1
         //MaxValue=5
         WinTop=0.600000
         WinLeft=0.645000
         WinWidth=0.080000
         //OnDeActivate=DefenseAmt.ValidateValue
     End Object
     Controls(23)=GUIEditBox'UT2004RPG.RPGStatsMenu.DefenseThing'

     Begin Object Class=GUIEditBox Name=MaxAmmoThing
         //Value="5"
         //MinValue=1
         //MaxValue=5
         WinTop=0.700000
         WinLeft=0.645000
         WinWidth=0.080000
         //OnDeActivate=MaxAmmoAmt.ValidateValue
     End Object
     Controls(24)=GUIEditBox'UT2004RPG.RPGStatsMenu.MaxAmmoThing'
//===================================
     Begin Object Class=GUIButton Name=ResetButton
         Caption="Reset"
         FontScale=FNS_Small
         StyleName="ResetButton"
				 WinLeft=0.074478
				 WinTop=0.790771
         WinWidth=0.065000
         WinHeight=0.025000

         OnClick=RPGStatsMenu.ResetClick
         OnKeyEvent=ResetButton.InternalOnKeyEvent
     End Object
     Controls(25)=GUIButton'UT2004RPG.RPGStatsMenu.ResetButton'

     // Begin Object Class=GUIHeader Name=TitleBar
     //     bUseTextHeight=True
     //     Caption="Stat Improvement"
     //     WinHeight=0.043750
     //     RenderWeight=0.100000
     //     bBoundToParent=True
     //     bScaleToParent=True
     //     bAcceptsInput=True
     //     bNeverFocus=False
     //     ScalingType=SCALE_X
     // End Object
     // Controls(26)=GUIHeader'UT2004RPG.RPGStatsMenu.TitleBar'

     // Begin Object Class=GUILabel Name=LevelLabel
     //     Caption="Level:"
     //     TextAlign=TXTA_Center
     //     TextColor=(B=255,G=255,R=255)
			// 	 WinTop=0.200000
     //     WinLeft=0.800000
     //     WinWidth=0.040000
     //     //bBoundToParent=True
     //     //bScaleToParent=True
     // End Object
     // Controls(26)=GUILabel'UT2004RPG.RPGStatsMenu.LevelLabel'
		 //
     // Begin Object Class=GUILabel Name=EXPLabel
     //     Caption="Experience:"
     //     TextAlign=TXTA_Center
     //     TextColor=(B=255,G=255,R=255)
			// 	 WinTop=0.250000
     //     WinLeft=0.800000
     //     WinWidth=0.040000
     //     //bBoundToParent=True
     //     //bScaleToParent=True
     // End Object
     // Controls(27)=GUILabel'UT2004RPG.RPGStatsMenu.EXPLabel'

		 //New Controls
		 Begin Object Class=GUIButton Name=AbilitiesButton
				 Caption="Abilities"
				 FontScale=FNS_Small
				 //StyleName="ResetButton"
				 WinHeight=0.125000
				 WinLeft=0.065000
				 WinTop=0.2000000
				 WinWidth=0.085000

				 OnClick=RPGStatsMenu.AbilitiesClick
				 OnKeyEvent=AbilitiesButton.InternalOnKeyEvent
		 End Object
		 Controls(26)=GUIButton'UT2004RPG.RPGStatsMenu.AbilitiesButton'

		 Begin Object Class=GUIButton Name=StatsButton
				 Caption="Stats"
				 FontScale=FNS_Small
				 //StyleName="ResetButton"
					WinWidth=0.085000
			 		WinHeight=0.125000
			 		WinLeft=0.065000
			 		WinTop=0.350000
				 OnClick=RPGStatsMenu.StatsClick
				 OnKeyEvent=StatsButton.InternalOnKeyEvent
		 End Object
		 Controls(27)=GUIButton'UT2004RPG.RPGStatsMenu.StatsButton'

		 Begin Object Class=GUIButton Name=StoreButton
				 Caption="Store"
				 FontScale=FNS_Small
				 //StyleName="ResetButton"
					WinWidth=0.085000
					WinHeight=0.125000
					WinLeft=0.065000
					WinTop=0.500000
				 OnClick=RPGStatsMenu.ResetClick
				 OnKeyEvent=ResetButton.InternalOnKeyEvent
		 End Object
		 Controls(28)=GUIButton'UT2004RPG.RPGStatsMenu.StoreButton'

		 Begin Object Class=GUIScrollTextBox Name=DescInfo
				CharDelay=0.000500
				EOLDelay=0.000500
				OnCreateComponent=DescInfo.InternalOnCreateComponent
				StyleName="AbilityList"
				WinWidth=0.45000
				WinHeight=0.5000
				WinLeft=0.743286
				WinTop=0.185257
				// WinWidth=0.725000
				// WinHeight=0.290000
				// WinLeft=0.000000
				// WinTop=0.490000
				bVisibleWhenEmpty=True
				bBoundToParent=True
				bScaleToParent=True
				bNeverFocus=True
		End Object
		Controls(29)=GUIScrollTextBox'UT2004RPG.RPGStatsMenu.DescInfo'

     WinLeft=0.200000
     WinWidth=0.600000
     WinHeight=1.000000
}
