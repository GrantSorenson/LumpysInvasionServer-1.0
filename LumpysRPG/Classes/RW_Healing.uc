class RW_Healing extends RPGWeapon
	HideDropDown
	CacheExempt;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	return true;//We wnat every weapon to be able to heal regardless of its fireing status
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local int BestDamage;

	BestDamage = Max(Damage, OriginalDamage);
	if (BestDamage > 0)
	{
		P = Pawn(Victim);
		if (P != None && ( P == Instigator
					|| (P.Controller.IsA('FriendlyMonsterController') && FriendlyMonsterController(P.Controller).Master == Instigator.Controller)
					|| (P.GetTeam() == Instigator.GetTeam() && Instigator.GetTeam() != None) ) )
		{
			if (!bIdentified)
			{
				Identify();
			}
			P.GiveHealth(Max(1, BestDamage * (0.05 * Modifier)), P.HealthMax + 50);
			P.SetOverlayMaterial(ModifierOverlay, 1.0, false);
			Damage = 0;
			//I'd like to give EXP here, but some people would exploit it :(
		}
	}

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     ModifierOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
     MinModifier=1
     MaxModifier=10
     AIRatingBonus=0.020000
     PrefixPos="Healing "
}
