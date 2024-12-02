class RW_MedicHealing extends RPGWeapon
	HideDropDown
	CacheExempt;

	static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
	{
		if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
		          && class'MutLumpysRPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
			return false;

		return true;
	}

//Infinity
simulated function WeaponTick(float dt)
{
	MaxOutAmmo();

	Super.WeaponTick(dt);
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local int BestDamage, HealAmount;

	BestDamage = Max(Damage, OriginalDamage);
	if (BestDamage > 0)
	{
		P = Pawn(Victim);
		if (P != None && ( P == Instigator
					|| (P.Controller.IsA('FriendlyMonsterController') && FriendlyMonsterController(P.Controller).Master == Instigator.Controller)
					|| (P.GetTeam() == Instigator.GetTeam() && Instigator.GetTeam() != None) ) )
		{

			HealAmount = 100 * Modifier;
			P.GiveHealth(HealAmount, P.HealthMax + 100 * Modifier);
// 			function bool GiveHealth(int HealAmount, int HealMax)
// {
//     if (Health < HealMax)
//     {
//         Health = Min(HealMax, Health + HealAmount);
//         return true;
//     }
//     return false;
// }
			P.SetOverlayMaterial(ModifierOverlay, 1.0, false);
			Damage = 0;
			//I'd like to give EXP here, but some people would exploit it :(
		}
	}
	//Give the player a message letting them know we healed them
	if (HealAmount > 0 && P != None && PlayerController(P.Controller) != None)
    {
        PlayerController(P.Controller).ReceiveLocalizedMessage(class'HealedConditionMessage', 0, Instigator.PlayerReplicationInfo);

        P.PlaySound(sound'PickupSounds.HealthPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
    }

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     ModifierOverlay=Shader'XGameTextures.SuperPickups.MHInnerS'//SuperHealthPC alteranative Origin DOMabBs
     MinModifier=1
     MaxModifier=10
     AIRatingBonus=0.020000
     PrefixPos="Medic Infinity Healing "
}
