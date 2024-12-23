class RPGStoreList extends GUIMultiColumnList;

struct StoreItemInfo {
  var string ItemName;
  var string ItemClass;
  var string ItemCost;
};

var array<StoreItemInfo> StoreItems;

function InitComponent(GUIController InController, GUIComponent InOwner)
{
  local int i;
    Super.InitComponent(InController,InOwner);

    for (i = 0; i < default.StoreItems.Length; i++)
    {
      StoreItems[i] = default.StoreItems[i];
      AddedItem();
    }
}

function MyOnDrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;
    local GUIStyles DrawStyle;
    local color TempColor;
  //  local RPGStatsInv StatsInv;
  //  local PlayerController PC;

    if (bSelected)
    {
        DrawStyle = SelectedStyle;
        DrawStyle.Draw(Canvas,MSAT_Pressed, X, Y-2, W, H+2 );
    }

    else DrawStyle = Style;

    TempColor = DrawStyle.FontColors[MenuState];

    // Find out if we have a team number
    //PlayerStat = Players[SortData[i].SortItem].StatsID;
    //Team = (PlayerStat >> 29) - 1;

    // Clear the extra bits
    //PlayerStat = PlayerStat & 268435456;    // 1 << 28
    // Team = 1;
    // if (Team == 0 || Team == 1)
    //     DrawStyle.FontColors[MenuState] = SetColor(Team);

    GetCellLeftWidth( 0, CellLeft, CellWidth );
    DrawStyle.DrawText( Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, StoreItems[SortData[i].SortItem].ItemName, FontScale);

    GetCellLeftWidth( 1, CellLeft, CellWidth );
    DrawStyle.DrawText( Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, StoreItems[SortData[i].SortItem].ItemCost, FontScale );
    //
    // if( Players[SortData[i].SortItem].StatsID != 0 )
    // {
    //     GetCellLeftWidth( 2, CellLeft, CellWidth );
    //     DrawStyle.DrawText( Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, string(PlayerStat), FontScale );
    // }
    //
    // GetCellLeftWidth( 3, CellLeft, CellWidth );
    // DrawStyle.DrawText( Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, string(Players[SortData[i].SortItem].Ping), FontScale );

    DrawStyle.FontColors[MenuState] = TempColor;
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
  OnDrawItem = RPGStoreList.MyOnDrawItem
 StoreItems(0)=(ItemName="Rainbow Shock Rfle",ItemClass="tk_RainbowShockRifle.RainbowShockRifle",ItemCost="1000 Credits")
 StoreItems(1)=(ItemName="AK-47",ItemClass="tk_AK47.AK47Weapon",ItemCost="10 Credits")
 StoreItems(2)=(ItemName="Holy Hand Grenade",ItemClass="tk_HolyHandGrenade.HolyHandGrenade",ItemCost="10 Credits")
 StoreItems(3)=(ItemName="UnHoly Hand Grenade",ItemClass="tk_HolyHandGrenade.UnHolyHandGrenade",ItemCost="10 Credits")
 StoreItems(4)=(ItemName="Lil Lady",ItemClass="tk_LilLady.LilLady",ItemCost="10 Credits")
 StoreItems(5)=(ItemName="Magic Wand",ItemClass="tk_MagicWand.MagicWand",ItemCost="10 Credits")
 StoreItems(6)=(ItemName="Howitzer",ItemClass="tk_FHIWeapons.Howitzer",ItemCost="10 Credits")
 StoreItems(7)=(ItemName="Turbo Laser",ItemClass="tk_FHIWeapons.TurboLaser",ItemCost="10 Credits")
 StoreItems(8)=(ItemName="Combat Shotgun",ItemClass="tk_FHIWeapons.Shotgun",ItemCost="10 Credits")
 StoreItems(9)=(ItemName="Singularity Cannon",ItemClass="tk_FHIWeapons.SingularityCannon",ItemCost="10 Credits")
 ColumnHeadings(0)="Item"
 ColumnHeadings(1)="Cost"
 InitColumnPerc(0)=0.50000
 InitColumnPerc(1)=0.250000
 ExpandLastColumn=True
}
