//---------------------------------------------------------------
//MutMonsterDrop by Shaun Goeppinger 2011
//Me@ShaunGoeppinger.com
//www.ShaunGoeppinger.com | www.Uneal.ShaunGoeppinger.com
//---------------------------------------------------------------
//Warning: MiniHealthPack DM-1on1-Idoma.MiniHealthPack (Function Engine.Pickup.SpawnCopy:0048) Accessed None 'Copy'
class MutMonsterDrop extends Mutator config(MonsterDropSettings);

struct ItemInfo
{
	var() string Item;
	var() float DropChance;
	var() float DropLifeSpan;
	var() bool bShowMessage;
	var() color MessageColour;
	var() color ItemNameColour;
	var() string ItemPickupName;
};

var() config Array<ItemInfo> ItemsToDrop;
var() config float OverallMonsterDropChance;
var() string ItemMessage;

function PostBeginPlay()
{
	local MonsterDropRules MDR;

	MDR = Spawn(class'MonsterDropRules');
	if(MDR != None)
	{
		if ( Level.Game.GameRulesModifiers == None )
		{
			Level.Game.GameRulesModifiers = MDR;
		}
		else
		{
			Level.Game.GameRulesModifiers.AddGameRules(MDR);
		}
	}

	Super.PostBeginPlay();
}

function NotifyItem(string ItemName, color MessageColour, color ItemColour)
{
	local Controller C;
	local string AnOrA, TestLetter;

	for(C=Level.ControllerList;C!=None;C=C.NextController)
	{
		if(PlayerController(C) != None)
		{
			AnOrA = "a";
			TestLetter = Left(ItemName, 1);
			if(TestLetter ~= "a" || TestLetter ~= "e" || TestLetter ~= "i" || TestLetter ~= "o" || TestLetter ~= "u")
			{
				AnOrA = "an";
			}

			PlayerController(C).ClientMessage(Level.Game.MakeColorCode(MessageColour)$"A monster dropped"@AnOrA@Level.Game.MakeColorCode(ItemColour)$ItemName);
		}
	}
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local int RandInv, i, LuckyItemCount;
	local Actor A;
	local float LuckFactor;
	local array< class<Actor> > ItemClasses;
	local array<float> DropLifeSpans;
	local class<Actor> MessageItemClass;
	local class<Inventory> InvClass;
	local array<string> ItemParts;

	if(Other != None && Other.Owner != None && Monster(Other.Owner) != None)
	{
		for(i=0;i<ItemsToDrop.Length;i++)
		{
			if(ItemsToDrop[i].bShowMessage)
			{
				InvClass = class<Inventory>(DynamicLoadObject(ItemsToDrop[i].Item, class'class', true));

				if(InvClass != None)
				{
				  if(InvClass.default.PickupClass == Other.Class)
					{
						if(ItemsToDrop[i].ItemPickupName ~= "")
						{
							Split(Other.Class, ".", ItemParts);
							ItemMessage = ItemParts[1];
							if(ItemMessage ~= "" || ItemMessage ~= "None")
							{
								ItemMessage = default.ItemMessage;
							}
							NotifyItem(ItemMessage, ItemsToDrop[i].MessageColour, ItemsToDrop[i].ItemNameColour);
							break;
						}
						else
						{

						NotifyItem(ItemsToDrop[i].ItemPickupName, ItemsToDrop[i].MessageColour, ItemsToDrop[i].ItemNameColour);
						break;
					 }
					}
				}
				else
				{
					MessageItemClass = class<Actor>(DynamicLoadObject(ItemsToDrop[i].Item, class'class', true));
				}

				if( Other.Class == MessageItemClass )
				{
					if(ItemsToDrop[i].ItemPickupName ~= "")
					{
						Split(Other.Class, ".", ItemParts);
						ItemMessage = ItemParts[1];
						if(ItemMessage ~= "" || ItemMessage ~= "None")
						{
							ItemMessage = default.ItemMessage;
						}
						NotifyItem(ItemMessage, ItemsToDrop[i].MessageColour, ItemsToDrop[i].ItemNameColour);
						break;
					}
					else
					{

					NotifyItem(ItemsToDrop[i].ItemPickupName, ItemsToDrop[i].MessageColour, ItemsToDrop[i].ItemNameColour);
					break;
				  }
				}
			}
		}
	}

	if(OverallMonsterDropChance >= fRand() && Monster(Other)!= None && ItemsToDrop.Length > 0)
	{
		i = 0;
		LuckyItemCount = 0;
		LuckFactor = fRand();

		ItemClasses.Remove(0, ItemClasses.Length);
		DropLifeSpans.Remove(0, DropLifeSpans.Length);

		for(i=0;i<ItemsToDrop.Length;i++)
		{
			if(ItemsToDrop[i].DropChance >= LuckFactor)
			{
				ItemClasses.Insert(LuckyItemCount, 1);
				ItemClasses[LuckyItemCount] = class<Actor>(DynamicLoadObject(ItemsToDrop[i].Item, class'class', true));

				DropLifeSpans.Insert(LuckyItemCount, 1);
				DropLifeSpans[LuckyItemCount] = ItemsToDrop[i].DropLifeSpan;
				LuckyItemCount++;
			}
		}

		if(LuckyItemCount == 0)
		{
			return true;
		}

		i = 0;
		RandInv = Rand(ItemClasses.Length);

		if(ClassIsChildOf(ItemClasses[RandInv], class'Inventory'))
		{
			A = Spawn(ItemClasses[RandInv], Monster(Other),,,);
		}
		else
		{
			A = Spawn(class'ItemDropInv', Monster(Other),,,);
			if(ItemDropInv(A) != None)
			{
				ItemDropInv(A).ItemToDrop = ItemClasses[RandInv];
				ItemDropInv(A).DropLifeSpan = DropLifeSpans[RandInv];
			}
		}

		if(Inventory(A) != None)
		{
			Inventory(A).GiveTo(Monster(Other));
		}
	}

    return true;
}

defaultproperties
{
    OverallMonsterDropChance=0.25
    ItemMessage="special item"
    bAddToServerPackages=True
    FriendlyName="Monster Artifact Drop v2"
    Description="Makes monsters drop artifacts and other items."
    bAlwaysRelevant=True
}
