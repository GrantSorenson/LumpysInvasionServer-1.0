/*
This Tab holds data for Stats
*/

class RPGTabStats extends MidGamePanel;

var RPGStatsInv StatsInv;

var moEditBox WepSpeedEdit, HealthBonusEdit, AdrenalineMaxEdit,AttackEdit,DefenseEdit, AmmoMaxEdit, PointsAvailableEdit;
var GUIEditBox WeaponSpeedAmt, HealthBonusAmt, AdrenalineMaxAmt, AttackAmt, DefenseAmt, MaxAmmoAmt;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
  local PlayerController PC;
    super.InitComponent(MyController, MyOwner);
//Values
    WepSpeedEdit = moEditBox(Controls[0]);
    HealthBonusEdit =moEditBox(Controls[1]);
    AdrenalineMaxEdit = moEditBox(Controls[2]);
    AttackEdit = moEditBox(Controls[3]);
    DefenseEdit = moEditBox(Controls[4]);
    AmmoMaxEdit = moEditBox(Controls[5]);
    PointsAvailableEdit = moEditBox(Controls[6]);
// Edit Boxes
    WeaponSpeedAmt = GUIEditBox(Controls[7]);

    RefreshStats();
}

function RefreshStats()
{
  local PlayerController PC;
  PC = PlayerOwner();
  //Could this be sent from RPGLumpyStatMenu?
  StatsInv = GetStatsInv(PC);

  WepSpeedEdit.SetText(string(StatsInv.Data.WeaponSpeed));
	HealthBonusEdit.SetText(string(StatsInv.Data.HealthBonus));
	AdrenalineMaxEdit.SetText(string(StatsInv.Data.AdrenalineMax));
	AttackEdit.SetText(string(StatsInv.Data.Attack));
	DefenseEdit.SetText(string(StatsInv.Data.Defense));
	AmmoMaxEdit.SetText(string(StatsInv.Data.AmmoMax));
	PointsAvailableEdit.SetText(string(StatsInv.Data.PointsAvailable));
}

function ShowPanel(bool bShow)
{
    Super.ShowPanel(bShow);
    if(bShow)
      RefreshStats();

}

function RPGStatsInv GetStatsInv(PlayerController PC)
{
	local Inventory Inv;

	for (Inv = PC.Inventory; Inv != None; Inv = Inv.Inventory)
		if ( Inv.IsA('RPGStatsInv') && ( Inv.Owner == PC || Inv.Owner == PC.Pawn
						   || (Vehicle(PC.Pawn) != None && Inv.Owner == Vehicle(PC.Pawn).Driver) ) )
			return RPGStatsInv(Inv);

	//fallback - shouldn't happen
	if (PC.Pawn != None)
	{
		Inv = PC.Pawn.FindInventoryType(class'RPGStatsInv');
		if ( Inv != None && ( Inv.Owner == PC || Inv.Owner == PC.Pawn
				      || (Vehicle(PC.Pawn) != None && Inv.Owner == Vehicle(PC.Pawn).Driver) ) )
			return RPGStatsInv(Inv);
	}

	return None;
}

function bool StatPlusClick(GUIComponent Sender)
{
	local int x, SenderIndex, stat, amount;

//get the control location for buttons and check to see if it matches sender
	for (x = 7; x <= 12; x++)
		if (Controls[x] == Sender)
		{
			SenderIndex = x;//set our sender index
			break;
		}
//offset the index by the starting index to get values between 0-5(total amount of stat types and the correspongding stat to increase)
  stat = SenderIndex;
	//we have the stat index and control, we need to find the connexted guiedit with the increase value
	//gui edit boxes are in controls 19-24
	SenderIndex += 6;
	amount = int(GUIEditBox(Controls[SenderIndex]).GetText());
	//DisablePlusButtons();
	StatsInv.ServerAddPointTo(amount, EStatType(stat-7));
  RefreshStats();
	//InitFor(StatsInv);
	return true;
}

defaultproperties
{
  Begin Object Class=moEditBox Name=WeaponSpeedSelect
      bReadOnly=True
      CaptionWidth=0.775000
      Caption="Weapon Speed Bonus (%)"
      OnCreateComponent=WeaponSpeedSelect.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinTop=0.200000
      WinLeft=0.072254
      WinWidth=0.362500
      WinHeight=0.040000
  End Object
  Controls(0)=moEditBox'LumpysRPG.RPGTabStats.WeaponSpeedSelect'

  Begin Object Class=moEditBox Name=HealthBonusSelect
      bReadOnly=True
      CaptionWidth=0.775000
      Caption="Health Bonus"
      OnCreateComponent=HealthBonusSelect.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinTop=0.300000
      WinLeft=0.072254
      WinWidth=0.362500
      WinHeight=0.040000
  End Object
  Controls(1)=moEditBox'LumpysRPG.RPGTabStats.HealthBonusSelect'

  Begin Object Class=moEditBox Name=AdrenalineMaxSelect
      bReadOnly=True
      CaptionWidth=0.775000
      Caption="Max Adrenaline"
      OnCreateComponent=AdrenalineMaxSelect.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinTop=0.400000
      WinLeft=0.072254
      WinWidth=0.362500
      WinHeight=0.040000
  End Object
  Controls(2)=moEditBox'LumpysRPG.RPGTabStats.AdrenalineMaxSelect'

  Begin Object Class=moEditBox Name=AttackSelect
      bReadOnly=True
      CaptionWidth=0.775000
      Caption="Damage Bonus (0.5%)"
      OnCreateComponent=AttackSelect.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinTop=0.500000
      WinLeft=0.072254
      WinWidth=0.362500
      WinHeight=0.040000
  End Object
  Controls(3)=moEditBox'LumpysRPG.RPGTabStats.AttackSelect'

  Begin Object Class=moEditBox Name=DefenseSelect
      bReadOnly=True
      CaptionWidth=0.775000
      Caption="Damage Reduction (0.5%)"
      OnCreateComponent=DefenseSelect.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinTop=0.600000
      WinLeft=0.072254
      WinWidth=0.362500
      WinHeight=0.040000
  End Object
  Controls(4)=moEditBox'LumpysRPG.RPGTabStats.DefenseSelect'

  Begin Object Class=moEditBox Name=MaxAmmoSelect
      bReadOnly=True
      CaptionWidth=0.775000
      Caption="Max Ammo Bonus (%)"
      OnCreateComponent=MaxAmmoSelect.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinTop=0.700000
      WinLeft=0.072254
      WinWidth=0.362500
      WinHeight=0.040000
  End Object
  Controls(5)=moEditBox'LumpysRPG.RPGTabStats.MaxAmmoSelect'

  Begin Object Class=moEditBox Name=PointsAvailableSelect
      bReadOnly=True
      CaptionWidth=0.775000
      Caption="Stat Points Available"
      OnCreateComponent=PointsAvailableSelect.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinWidth=0.289789
  		WinHeight=0.038119
  		WinLeft=0.349904
  		WinTop=0.799510
  End Object
  Controls(6)=moEditBox'LumpysRPG.RPGTabStats.PointsAvailableSelect'
//Plus buttons
  Begin Object Class=GUIButton Name=WeaponSpeedButton
      Caption="+"
      WinWidth=0.051757
      WinHeight=0.066281
      WinLeft=0.588808
      WinTop=0.188564
      OnClick=RPGTabStats.StatPlusClick
      OnKeyEvent=WeaponSpeedButton.InternalOnKeyEvent
  End Object
  Controls(7)=GUIButton'LumpysRPG.RPGTabStats.WeaponSpeedButton'

  Begin Object Class=GUIButton Name=HealthBonusButton
      Caption="+"
      WinWidth=0.051757
      WinHeight=0.066281
      WinLeft=0.588808
      WinTop=0.288564
      OnClick=RPGTabStats.StatPlusClick
      OnKeyEvent=HealthBonusButton.InternalOnKeyEvent
  End Object
  Controls(8)=GUIButton'LumpysRPG.RPGTabStats.HealthBonusButton'

  Begin Object Class=GUIButton Name=AdrenalineMaxButton
      Caption="+"
      WinWidth=0.051757
      WinHeight=0.066281
      WinLeft=0.588808
      WinTop=0.388564
      OnClick=RPGTabStats.StatPlusClick
      OnKeyEvent=AdrenalineMaxButton.InternalOnKeyEvent
  End Object
  Controls(9)=GUIButton'LumpysRPG.RPGTabStats.AdrenalineMaxButton'

  Begin Object Class=GUIButton Name=AttackButton
      Caption="+"
      WinWidth=0.051757
      WinHeight=0.066281
      WinLeft=0.588808
      WinTop=0.488564
      OnClick=RPGTabStats.StatPlusClick
      OnKeyEvent=AttackButton.InternalOnKeyEvent
  End Object
  Controls(10)=GUIButton'LumpysRPG.RPGTabStats.AttackButton'

  Begin Object Class=GUIButton Name=DefenseButton
      Caption="+"
      WinWidth=0.051757
      WinHeight=0.066281
      WinLeft=0.588808
      WinTop=0.588564
      OnClick=RPGTabStats.StatPlusClick
      OnKeyEvent=DefenseButton.InternalOnKeyEvent
  End Object
  Controls(11)=GUIButton'LumpysRPG.RPGTabStats.DefenseButton'

  Begin Object Class=GUIButton Name=AmmoMaxButton
      Caption="+"
      WinWidth=0.051757
      WinHeight=0.066281
      WinLeft=0.588808
      WinTop=0.688564
      OnClick=RPGTabStats.StatPlusClick
      OnKeyEvent=AmmoMaxButton.InternalOnKeyEvent
  End Object
  Controls(12)=GUIButton'LumpysRPG.RPGTabStats.AmmoMaxButton'

  Begin Object Class=GUIEditBox Name=WeaponSpeedThing
      WinLeft=0.479708
      WinTop=0.191105
      WinWidth=0.080000
  End Object
  Controls(13)=GUIEditBox'LumpysRPG.RPGTabStats.WeaponSpeedThing'

  Begin Object Class=GUIEditBox Name=HealthBonusThing
      WinLeft=0.479708
        WinTop=0.291105
      WinWidth=0.080000
  End Object
  Controls(14)=GUIEditBox'LumpysRPG.RPGTabStats.HealthBonusThing'

  Begin Object Class=GUIEditBox Name=AdrenalineMaxThing
      WinLeft=0.479708
      WinTop=0.391105
      WinWidth=0.080000
  End Object
  Controls(15)=GUIEditBox'LumpysRPG.RPGTabStats.AdrenalineMaxThing'

  Begin Object Class=GUIEditBox Name=AttackThing
      WinLeft=0.479708
      WinTop=0.491105
      WinWidth=0.080000
  End Object
  Controls(16)=GUIEditBox'LumpysRPG.RPGTabStats.AttackThing'

  Begin Object Class=GUIEditBox Name=DefenseThing
      WinLeft=0.479708
      WinTop=0.591105
      WinWidth=0.080000
  End Object
  Controls(17)=GUIEditBox'LumpysRPG.RPGTabStats.DefenseThing'

  Begin Object Class=GUIEditBox Name=MaxAmmoThing
      WinLeft=0.479708
      WinTop=0.691105
      WinWidth=0.080000
  End Object
  Controls(18)=GUIEditBox'LumpysRPG.RPGTabStats.MaxAmmoThing'

  WinHeight=0.700000
}
