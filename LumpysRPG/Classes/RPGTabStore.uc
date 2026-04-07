/*
This Tab holds data for the Store
*/

class RPGTabStore extends MidGamePanel;

var moEditBox CreditAmt, StacksAmt, GoldAmt;

var GUIMultiColumnListBox StoreListBox;
var RPGStoreList StoreList;
var RPGStatsInv StatsInv;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
  local PlayerController PC;

  super.InitComponent(MyController, MyOwner);

  CreditAmt = moEditBox(Controls[0]);
  StacksAmt = moEditBox(Controls[1]);
  GoldAmt = moEditBox(Controls[2]);
  StoreListBox = GUIMultiColumnListBox(Controls[3]);

  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);
  CreditAmt.SetText(String(StatsInv.Data.Credits));
  StacksAmt.SetText(String(StatsInv.Data.Stacks));
  GoldAmt.SetText(String(StatsInv.Data.Gold));

  //StoreListBox.List.AddedItem();
}

function ShowPanel(bool bShow)
{
  super.ShowPanel(bShow);

  if(bShow)
    RefreshCurrency();
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
function bool PurchaseItem(GUIComponent Sender)
{
  local int x, cost;
  local array<string> ItemParts;
  local PlayerController PC;

  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);

  if (PC.Pawn == None || PC.Pawn.IsA('Monster') || StatsInv == None)
      return false;

  x = StoreListBox.List.CurrentListId();
  split(RPGStoreList(StoreListBox.List).default.StoreItems[x].ItemCost, " ", ItemParts);
  cost = int(ItemParts[0]);

  StatsInv.ServerBuyItem(
      RPGStoreList(StoreListBox.List).default.StoreItems[x].ItemClass,
      cost,
      ItemParts[1]
  );

  return true;
}


function RefreshCurrency()
{
  local PlayerController PC;

  PC = PlayerOwner();
  StatsInv = GetStatsInv(PC);
  CreditAmt.SetText(String(StatsInv.Data.Credits));
  StacksAmt.SetText(String(StatsInv.Data.Stacks));
  GoldAmt.SetText(String(StatsInv.Data.Gold));
}

defaultproperties
{

  Begin Object Class=moEditBox Name=CreditEditBox
      bReadOnly=True
      CaptionWidth=0.25
      Caption="Credits: "
      OnCreateComponent=CreditEditBox.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinWidth=0.137031
  		WinHeight=0.038119
  		WinLeft=0.233401
  		WinTop=0.860738
  End Object
  Controls(0)=moEditBox'LumpysRPG.RPGTabStore.CreditEditBox'

  Begin Object Class=moEditBox Name=StacksEditBox
      bReadOnly=True
      CaptionWidth=0.25
      Caption="Stacks: "
      OnCreateComponent=StacksEditBox.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinWidth=0.137031
  		WinHeight=0.038119
  		WinLeft=0.433401
  		WinTop=0.860738
  End Object
  Controls(1)=moEditBox'LumpysRPG.RPGTabStore.StacksEditBox'

  Begin Object Class=moEditBox Name=GoldEditBox
      bReadOnly=True
      CaptionWidth=0.25
      Caption="$Gold$: "
      OnCreateComponent=GoldEditBox.InternalOnCreateComponent
      IniOption="@INTERNAL"
      WinWidth=0.137031
  		WinHeight=0.038119
  		WinLeft=0.633401
  		WinTop=0.860738
  End Object
  Controls(2)=moEditBox'LumpysRPG.RPGTabStore.GoldEditBox'

  Begin Object Class=GUIMultiColumnListBox Name=StoreMListBox
    bVisibleWhenEmpty=true
    DefaultListClass="LumpysRPG.RPGStoreList"
    //StyleName="ServerBrowserGrid"
    WinWidth=0.408096
    WinHeight=0.699384
    WinLeft=0.271767
    WinTop=0.087039
  End Object
  Controls(3)=GUIMultiColumnListBox'LumpysRPG.RPGTabStore.StoreMListBox'

  Begin Object Class=GUIButton Name=BuyItemButton
      Caption="Buy"
      WinWidth=0.142656
  		WinHeight=0.085599
  		WinLeft=0.711666
  		WinTop=0.088137
      OnClick=RPGTabStore.PurchaseItem
      OnKeyEvent=BuyItemButton.InternalOnKeyEvent
  End Object
  Controls(4)=GUIButton'LumpysRPG.RPGTabStore.BuyItemButton'

  WinHeight=0.700000
}
