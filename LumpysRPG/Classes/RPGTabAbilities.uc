/*
This Tab holds data for abilities
*/

class RPGTabAbilities extends MidGamePanel;

var RPGStatsInv StatsInv;
var GUIListBox Abilities;
var localized string CurrentLevelText, MaxText, CostText, CantBuyText, GenAbilityCat, ClassAbilityCat;
Var Array<string> OwnedClasses;

struct AbilityInfo
{
	var class<RPGAbility> Ability;
	var int Level;
};

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
  super.InitComponent(MyController, MyOwner);

  Abilities = GUIListBox(Controls[0]);
  RefreshAbilityBox();
}

function ShowPanel(bool bShow)
{
  super.ShowPanel(bShow);
	if(bShow)
	{
		RefreshAbilityBox();
	}

}

function GetOwnedClasses()
{
	local int x;

	OwnedClasses.Remove(0,OwnedClasses.length);

	for(x=0;x<StatsInv.Data.ClassAbilities.length;x++)
	{
		//OwnedClasses.Insert(0,1);
		OwnedClasses[x] = StatsInv.Data.ClassAbilities[x].default.MasterClass;
	}

}

function RefreshAbilityBox()
{
  local PlayerController PC;
  local int x, y,i, Index, Level, OldAbilityListIndex;
  local RPGPlayerDataObject TempDataObject;
  local AbilityInfo AInfo;
  local array<AbilityInfo> GenAbilities;
  local array<AbilityInfo> ClassAbilities;

  //Get the stats inv
  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);

  if (StatsInv.Role < ROLE_Authority)
  {
    TempDataObject = RPGPlayerDataObject(StatsInv.Level.ObjectPool.AllocateObject(class'RPGPlayerDataObject'));
    TempDataObject.InitFromDataStruct(StatsInv.Data);
  }
  else
	{
		TempDataObject = StatsInv.DataObject;
	}

	GetOwnedClasses();
  for(x=0;x<OwnedClasses.length;x++)
  {
    Log("Owned Class #"$x$": "$OwnedClasses[x],'LumpysInvasion');
  }

  //Adding sections to a list box can be done by adding an entry like  list.Add(CustomGameCaption,None,"",true); to the correct position
  //Yea i know i can make this faster. I will. Eventually.
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

    if (StatsInv.AllAbilities[x].default.bClassAbility)
    {
			for(i=0;i<OwnedClasses.length;i++)
			{
				if(OwnedClasses[i] == StatsInv.AllAbilities[x].default.MasterClass)
				{
		      AInfo.Ability = StatsInv.AllAbilities[x];
		      AInfo.Level = Level;
		      ClassAbilities.Insert(0,1);
		      ClassAbilities[0]=(AInfo);
				}
			}
  	}

    else if (!StatsInv.AllAbilities[x].default.bClassAbility && !StatsInv.AllAbilities[x].default.bMasterAbility)
    {
      AInfo.Ability = StatsInv.AllAbilities[x];
      AInfo.Level = Level;
      GenAbilities.Insert(0,1);
      GenAbilities[0]=(AInfo);
    }

  }

  OldAbilityListIndex = Abilities.List.Index;
  Abilities.List.Clear();
  AddGenAbilities(TempDataObject,GenAbilities);
  AddClassAbilities(TempDataObject,ClassAbilities);
  Abilities.List.SetIndex(OldAbilityListIndex);
  UpdateAbilityButtons(Abilities);

  // free the temporary data object on clients
  if (StatsInv.Role < ROLE_Authority)
  {
    StatsInv.Level.ObjectPool.FreeObject(TempDataObject);
  }
}

function bool UpdateAbilityButtons(GUIComponent Sender)
{
	local int Cost;
  local int AbilityLevel;

	Cost = int(Abilities.List.GetExtra());

	if (Cost <= 0 || Cost > StatsInv.Data.PointsAvailable)
	{
    Controls[1].MenuStateChange(MSAT_Disabled);
  }
	else
  {
	  Controls[1].MenuStateChange(MSAT_Blurry);
  }

  if (Cost > 0)
  {
    Controls[3].MenuStateChange(MSAT_Blurry);
  }else
  {
    Controls[3].MenuStateChange(MSAT_Disabled);
  }

	ShowAbilityInfo();

	return true;
}

function bool BuyAbility(GUIComponent Sender)
{
	Controls[1].MenuStateChange(MSAT_Disabled);
	StatsInv.ServerAddAbility(class<RPGAbility>(Abilities.List.GetObject()));
  RefreshAbilityBox();

	return true;
}

function bool RefundAbility(GUIComponent Sender)
{
  Controls[3].MenuStateChange(MSAT_Disabled);
  StatsInv.ServerRefundAbility(class<RPGAbility>(Abilities.List.GetObject()));
  RefreshAbilityBox();

  return true;
}

function AddGenAbilities(RPGPlayerDataObject Data, array<AbilityInfo> GenAbilities)
{
  local int i;
  local int Cost;

  Abilities.List.Add(GenAbilityCat,None,"1010",true);//SectionHeader

  for(i=0;i<GenAbilities.Length;i++)
  {
    if (GenAbilities[i].Level >= GenAbilities[i].Ability.default.MaxLevel)
    {
      Abilities.List.Add(GenAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@GenAbilities[i].Level@"["$MaxText$"])", GenAbilities[i].Ability, string(Cost));
    }
    else
    {
      Cost = GenAbilities[i].Ability.static.Cost(Data, GenAbilities[i].Level);

      if (Cost <= 0)
        Abilities.List.Add(GenAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@GenAbilities[i].Level$","@CantBuyText$")", GenAbilities[i].Ability, string(Cost));
      else
        Abilities.List.Add(GenAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@GenAbilities[i].Level$","@CostText@Cost$")", GenAbilities[i].Ability, string(Cost));
    }
  }
}

function AddClassAbilities(RPGPlayerDataObject Data, array<AbilityInfo> ClassAbilities)
{
  local int i;
  local int Cost;

  Abilities.List.Add(ClassAbilityCat,None,"1010",true);//SectionHeader

  for(i=0;i<ClassAbilities.Length;i++)
  {
    if (ClassAbilities[i].Level >= ClassAbilities[i].Ability.default.MaxLevel)
    {
      Abilities.List.Add(ClassAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@ClassAbilities[i].Level@"["$MaxText$"])", ClassAbilities[i].Ability, string(Cost));
    }
    else
    {
      Cost = ClassAbilities[i].Ability.static.Cost(Data, ClassAbilities[i].Level);

      if (Cost <= 0)
        Abilities.List.Add(ClassAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@ClassAbilities[i].Level$","@CantBuyText$")", ClassAbilities[i].Ability, string(Cost));
      else
        Abilities.List.Add(ClassAbilities[i].Ability.default.AbilityName@"("$CurrentLevelText@ClassAbilities[i].Level$","@CostText@Cost$")", ClassAbilities[i].Ability, string(Cost));
    }
  }
}

function bool ShowAbilityInfo(optional GUIComponent Sender)
{
	local string Info;
	local class<RPGAbility> Ability;
	local GUIScrollTextBox AbilityInfo;

	AbilityInfo = GUIScrollTextBox(Controls[2]);
	AbilityInfo.MyScrollBar.WinWidth = 0.01;

	Ability = class<RPGAbility>(Abilities.List.GetObject());
	//the fix for ability text updating correctly when a category is selected can go here
	if (Ability == None)
	{
		AbilityInfo.MyScrollText.Clear();
		return true;
	}

	Info = Ability.default.Description;

	AbilityInfo.SetContent(Info);

	return true;
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

defaultproperties
{
  GenAbilityCat="General Abilities"
  ClassAbilityCat="Class Abilities"
  CurrentLevelText="Current Level:"
  MaxText="MAX"
  CostText="Cost:"
  CantBuyText="Can't Buy"

Begin Object Class=GUIListBox Name=AbilityList
    bVisibleWhenEmpty=True
    OnCreateComponent=AbilityList.InternalOnCreateComponent
    StyleName="AbilityList"
    Hint="These are the abilities you can purchase with stat points."
    WinWidth=0.425917
		WinHeight=0.247268
		WinLeft=0.057170
		WinTop=0.086674
    OnClick=RPGTabAbilities.UpdateAbilityButtons
End Object
Controls(0)=GUIListBox'LumpysRPG.RPGTabAbilities.AbilityList'

Begin Object Class=GUIButton Name=AbilityBuyButton
    Caption="Buy"
		WinWidth=0.100000
		WinHeight=0.100000
		WinLeft=0.513865
		WinTop=0.088830
    OnClick=RPGTabAbilities.BuyAbility
    OnKeyEvent=AbilityBuyButton.InternalOnKeyEvent
End Object
Controls(1)=GUIButton'LumpysRPG.RPGTabAbilities.AbilityBuyButton'

Begin Object Class=GUIScrollTextBox Name=DescInfo
   CharDelay=0.000500
   EOLDelay=0.000500
   OnCreateComponent=DescInfo.InternalOnCreateComponent
   StyleName="AbilityList"
   WinWidth=0.425917
   WinHeight=0.393843
	 WinLeft=0.057170
   WinTop=0.409879
   bVisibleWhenEmpty=False
   bBoundToParent=True
   bScaleToParent=True
   bNeverFocus=True
End Object
Controls(2)=GUIScrollTextBox'LumpysRPG.RPGTabAbilities.DescInfo'

Begin Object Class=GUIButton Name=AbilityRefundButton
    Caption="Refund"
		WinWidth=0.100000
		WinHeight=0.100000
		WinLeft=0.515235
		WinTop=0.208938
    OnClick=RPGTabAbilities.RefundAbility
    OnKeyEvent=AbilityRefundButton.InternalOnKeyEvent
End Object
Controls(3)=GUIButton'LumpysRPG.RPGTabAbilities.AbilityRefundButton'
}
