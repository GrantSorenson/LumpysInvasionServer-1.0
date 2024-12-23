class ArtifactSuperMedicWeaponMaker extends ArtifactMedicWeaponMaker;


//Var RPGWeapon OldWeapon;
//var float AdrenalineUsed;

function DoEffect();

state Activated
{
	function BeginState()
	{
		if(Instigator.Controller.Adrenaline < 300)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		AdrenalineUsed = 300;
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
				if(RPGWeapon(OldWeapon).ModifiedWeapon == StatsInv.OldRPGWeapons[x].Weapon)
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

		RPGWeapon(Copy).Generate(None);
		RPGWeapon(Copy).Modifier = RPGWeapon(Copy).MaxModifier;
		RPGWeapon(Copy).SetModifiedWeapon(spawn(OldWeaponClass, Instigator,,, rot(0,0,0)), true);

		//stupid hack for speedy weapons since I can't seem to get them to work with DetachFromPawn correctly. :P
		//if(OldWeapon.isA('RW_Speedy'))
		//	(RW_Speedy(OldWeapon)).deactivate();

		OldWeapon.DetachFromPawn(Instigator);
		RPGWeapon(OldWeapon).ModifiedWeapon.Destroy();
		RPGWeapon(OldWeapon).ModifiedWeapon = None;

		OldWeapon.Destroy();
		Copy.GiveTo(Instigator);

		GotoState('');
		bActive = false;
	}
}

function class<RPGWeapon> GetRandomWeaponModifier(class<Weapon> WeaponType, Pawn Other)
{
    return RPGMut.WeaponModifiers[3].WeaponClass;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2)
		return "Unable to modify magic weapon - LMB Cheater.";
	if (Switch == 3)
		return "300 Adrenaline is required to generate a magic weapon";
	if (Switch == 4)
		return "Already constructing magic weapon";

	return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}


defaultproperties
{
    CostPerSec=20
    MinActivationTime=0.50000
    IconMaterial=Texture'LumpysTextures.ArtifactIcons.tex_SuperMedicWeaponMaker'
    ItemName="Super Medic Weapon Maker"
}
