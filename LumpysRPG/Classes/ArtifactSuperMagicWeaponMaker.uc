class ArtifactSuperMagicWeaponMaker extends RPGArtifact;

var MutLumpysRPG RPGMut;
var float AdrenalineUsed;
Var Weapon OldWeapon;
var() Sound BrokenSound;

static function bool ArtifactIsAllowed(GameInfo Game)
{
  return true;
}

function PostBeginPlay()
{
	local Mutator m;

	Super.PostBeginPlay();

	for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
		if (MutLumpysRPG(m) != None)
		{
			RPGMut = MutLumpysRPG(m);
			break;
		}
}

function BotConsider()
{
	if (bActive)
		return;

	if (Instigator.Controller.Adrenaline < 50)
		return;

	if (bActive && (Instigator.Controller.Enemy == None || !Instigator.Controller.CanSee(Instigator.Controller.Enemy)))
		Activate();
	else if ( !bActive && Instigator.Controller.Enemy != None
		  && Instigator.Health > 70 && Instigator.Controller.CanSee(Instigator.Controller.Enemy) && NoArtifactsActive() && FRand() < 0.7 )
		Activate();
}

function Activate()
{
	if (bActive)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		GotoState('');
		return;
	}

	if (Instigator != None)
	{
		if(Instigator.Controller.Adrenaline < 50)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}

		OldWeapon = Instigator.Weapon;

		If(OldWeapon != None)
			Super.Activate();
		else
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2)
		return "Unable to generate magic weapon. LMB Cheater.";
	if (Switch == 3)
		return "100 Adrenaline is required to generate a magic weapon";
	if (Switch == 4)
		return "Already constructing magic weapon";
	if (Switch == 5)
		return "Your charm has broken";


	return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}

function DoEffect();

state Activated
{
	function BeginState()
	{
		if(Instigator.Controller.Adrenaline < 50)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}
		AdrenalineUsed = 50;
		bActive = true;
	}

	simulated function Tick(float deltaTime)
	{
		local float Cost;

		Cost = FMin(AdrenalineUsed, deltaTime * CostPerSec);
		AdrenalineUsed -= Cost;
		if (AdrenalineUsed <= 0.f)
		{
			//take the last bit of adrenaline from the player
			//add a tiny bit extra to fix float precision issues
			Instigator.Controller.Adrenaline -= Cost - 0.001;
			DoEffect();
		}
		else
		{
			Global.Tick(deltaTime);
		}
	}

	function DoEffect()
	{
		local inventory Copy;
		local RPGStatsInv StatsInv;
		local class<RPGWeapon> NewWeaponClass;
		local class<Weapon> OldWeaponClass;
		local int x;

		if(Instigator == None)
			return; //nothing to do and no one to tell.

		if(OldWeapon == None || !OldWeapon.HasAmmo())
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}


		//in this case, use the new weapon class anyway.
		if(OldWeapon.isA('RPGWeapon'))
			OldWeaponClass = RPGWeapon(OldWeapon).ModifiedWeapon.class;
		else
			OldWeaponClass = OldWeapon.class;

		if(OldWeaponClass == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}

		NewWeaponClass = GetRandomWeaponModifier(OldWeaponClass, Instigator);
		if(NewWeaponClass == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}

		Copy = spawn(NewWeaponClass, Instigator,,, rot(0,0,0));

		if(Copy == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}

		StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
		{
			for (x = 0; x < StatsInv.OldRPGWeapons.length; x++)
			{
				if(oldWeapon == StatsInv.OldRPGWeapons[x].Weapon)
				{
					StatsInv.OldRPGWeapons.Remove(x, 1);
					break;
				}
			}
		}

		if(RPGWeapon(Copy) == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
			GotoState('');
			bActive = false;
			return;
		}

		//try to generate a positive weapon.
		for(x = 0; x < 50; x++)
		{
			RPGWeapon(Copy).Generate(None);
			if(RPGWeapon(Copy).Modifier > -1)
				break;
		}

		RPGWeapon(Copy).SetModifiedWeapon(spawn(OldWeaponClass, Instigator,,, rot(0,0,0)), true);
		//stupid hack for speedy weapons since I can't seem to get them to work with DetachFromPawn correctly. :P
		//if(OldWeapon.isA('RW_Speedy'))
		//	(RW_Speedy(OldWeapon)).deactivate();
		OldWeapon.DetachFromPawn(Instigator);
		if(OldWeapon.isA('RPGWeapon'))
		{
			RPGWeapon(OldWeapon).ModifiedWeapon.Destroy();
			RPGWeapon(OldWeapon).ModifiedWeapon = None;
		}
		OldWeapon.Destroy();
		Copy.GiveTo(Instigator);
		if (Copy.isA('Vortex'))
			Copy.Destroy();

		GotoState('');
		bActive = false;
	}

	function EndState()
	{
		bActive = false;
	}
}

function class<RPGWeapon> GetRandomWeaponModifier(class<Weapon> WeaponType, Pawn Other)
{
	local int x, Chance;

	Chance = Rand(RPGMut.TotalModifierChance);
	for (x = 0; x < RPGMut.WeaponModifiers.Length; x++)
	{
		Chance -= RPGMut.WeaponModifiers[x].Chance;
		if (Chance < 0 && RPGMut.WeaponModifiers[x].WeaponClass.static.AllowedFor(WeaponType, Other))
			return RPGMut.WeaponModifiers[x].WeaponClass;
	}

	return class'RPGWeapon';
}

defaultproperties
{
     CostPerSec=50
     MinActivationTime=1.000000
     PickupClass=class'ArtifactSuperMagicWeaponMakerPickup'
     IconMaterial=Texture'RBTexturesINV.SuperMagicMaker.Icon'
     ItemName="Super Magic Weapon Maker"
}
