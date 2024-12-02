class RW_Adrenal extends RPGWeapon
	HideDropDown
	CacheExempt;

#EXEC OBJ LOAD FILE=RBTexturesINV.utx

var localized string AdrenMsg;
var int TargetAdrenaline,TargetAdrenalineMax;
var bool bReChargingSomeone;
var float TimeToFlipBack;

replication
{
	unreliable if( Role==ROLE_Authority && bReChargingSomeone)
		TargetAdrenaline,TargetAdrenalineMax;
	reliable if( Role == Role_Authority && bNetDirty)
		bReChargingSomeone;
}
static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{

	if (ClassIsChildOf(Weapon, class'Minigun'))
		return true;
  else if(ClassIsChildOf(Weapon, class'FlakCannon'))
    return true;

	return false;
}

simulated event RenderOverlays( Canvas Canvas )
{
	local float XL,YL;
	local string text;
	Super.RenderOverlays(Canvas);
	if (TargetAdrenaline != 0 && TargetAdrenalineMax != 0 && bReChargingSomeone)
	{
		text = TargetAdrenaline$"/"$TargetAdrenalineMax@AdrenMsg;
		Canvas.Font=Canvas.TinyFont;
		Canvas.SetDrawColor(255,69,0,255);
		Canvas.TextSize(text, XL, YL);
		Canvas.SetPos(Canvas.ClipX * 0.5 - XL/2, Canvas.ClipY * 0.75 - YL * 1.25);
		Canvas.DrawText(text);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.Font = Canvas.Default.Font;
	}

}


function bool HasActiveArtifact(Pawn Other)
{
	local Inventory Inv;

	for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		if (Inv.IsA('RPGArtifact') && RPGArtifact(Inv).bActive)
		{
			return true;
		}
	}

	return false;
}


function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;

	if (!bIdentified)
		Identify();
	if((DamageType == class'DamTypeMinigunBullet' || DamageType == class'DamTypeFlakChunk' || DamageType == class'DamTypeFlakShell') && !HasActiveArtifact(Instigator) )
	{

		Momentum = vect(0,0,0);

		P = Pawn(Victim);
		if (P != None && ( P == Instigator || (P.GetTeam() == Instigator.GetTeam() && Instigator.GetTeam() != None) )  && !HasActiveArtifact(P))
		{
			if (!bIdentified)
			{
				Identify();
			}
			if(Instigator != None && Instigator.PlayerReplicationInfo != None && P != None && PlayerController(P.Controller) != None && (P.GetTeam() == Instigator.GetTeam() && Instigator.GetTeam() != None) )
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'AdrenalConditionMessage', 0, Instigator.PlayerReplicationInfo);
			Instigator.Controller.AwardAdrenaline(Modifier*7);
			P.Controller.AwardAdrenaline(Modifier*7);
			P.SetOverlayMaterial(ModifierOverlay, 1.0, false);
			TargetAdrenaline = P.Controller.Adrenaline;
			TargetAdrenalineMax = P.Controller.AdrenalineMax;
			if(!bReChargingSomeone)
			{
				bReChargingSomeone = True;
				TimeToFlipBack = Level.TimeSeconds + 1.f;
			}
			Damage = 0;
		}

	}

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

simulated function bool StartFire(int Mode)
{
	if (!bIdentified && Role == ROLE_Authority)
		Identify();

	return Super.StartFire(Mode);
}

function bool ConsumeAmmo(int Mode, float Load, bool bAmountNeededIsMax)
{
	if (!bIdentified)
		Identify();

	return true;
}

simulated function WeaponTick(float dt)
{
	MaxOutAmmo();

	Super.WeaponTick(dt);
	if(Role == Role_Authority)
	{
		if(Level.TimeSeconds > TimeToFlipBack && bReChargingSomeone)
			bReChargingSomeone = False;
	}
}

defaultproperties
{
     AdrenMsg="Adrenaline"
     ModifierOverlay=Shader'RBTexturesINV.WeaponModifiers.OrangeShad'
     MinModifier=1
     MaxModifier=50
     AIRatingBonus=0.020000
     PrefixPos="Infinite Adrenalage "
}
