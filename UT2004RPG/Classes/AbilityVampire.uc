class AbilityVampire extends RPGAbility
	abstract;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (Data.Attack < 50)
		return 0;
	else
		return Super.Cost(Data, CurrentLevel);
}

static function VampireMarker GetMarkerFor(Controller Player, MutUT2004RPG RPGMut)
{
	local int i;

	for (i = 0; i < RPGMut.VampireMarkers.length; i++)
	{
		if (RPGMut.VampireMarkers[i] == None)
		{
			RPGMut.VampireMarkers.Remove(i, 1);
			i--;
		}
		else if (RPGMut.VampireMarkers[i].PlayerOwner == Player)
		{
			return RPGMut.VampireMarkers[i];
		}
	}

	return None;
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local VampireMarker Marker;
	local MutUT2004RPG RPGMut;

	// spawn the marker for this player that we'll use later for vampire effects (if necessary)
	if (Other.Role == ROLE_Authority && Other.Controller != None)
	{
		RPGMut = class'MutUT2004RPG'.static.GetRPGMutator(Other.Level.Game);
		Marker = GetMarkerFor(Other.Controller, RPGMut);
		if (Marker == None)
		{
			Marker = Other.spawn(class'VampireMarker', Other.Controller);
			Marker.PlayerOwner = Other.Controller;
			RPGMut.VampireMarkers[RPGMut.VampireMarkers.length] = Marker;
		}
	}
}

static function HandleDamage(int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local int Health;
	local VampireMarker Marker;

	if (!bOwnedByInstigator || DamageType == class'DamTypeRetaliation' || Injured == Instigator || Instigator == None)
		return;

	Health = int(float(Damage) * 0.05 * float(AbilityLevel));
	if (Health == 0 && Damage > 0)
	{
		Health = 1;
	}
	if (Instigator.Controller != None)
	{
		Marker = GetMarkerFor(Instigator.Controller, class'MutUT2004RPG'.static.GetRPGMutator(Instigator.Level.Game));
		if (Marker == None)
		{
			Warn("Failed to find VampireMarker for" @ Instigator.Controller.GetHumanReadableName());
		}
	}
	if (Marker != None)
	{
		// give the pawn the health outright and let the marker cap it in its Tick()
		Instigator.Health += Health;
		Marker.HealthRestored += Health;
	}
	else
	{
		// fall back to old way
		Instigator.GiveHealth(Health, Instigator.HealthMax + 50);
	}
}

defaultproperties
{
	AbilityName="Vampirism"
	Description="Whenever you damage another player, you are healed for 5% of the damage per level (up to your starting health amount + 50). You can't gain health from self-damage and you can't gain health from damage caused by the Retaliation ability. You must have a Damage Bonus of at least 50 to purchase this ability. (Max Level: 10)"
	StartingCost=10
	CostAddPerLevel=5
	MaxLevel=10
}
