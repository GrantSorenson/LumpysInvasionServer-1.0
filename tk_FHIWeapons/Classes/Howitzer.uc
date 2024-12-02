class Howitzer extends tk_Weapon
	config(TKWeaponsClient);

function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if (B == None)
		return AIRating;
		
	if ((B.Target != None) && (Pawn(B.Target) == None) && (VSize(B.Target.Location - Instigator.Location) < 1250))
		return -0.5;
		
	if (B.Enemy == None)
		return AIRating;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if (EnemyDist > 1950)
	{
		if (EnemyDist > 3000)
		{
			if (EnemyDist > 3900)
				return 0.6;
			return (AIRating - 0.3);
		}

		if (EnemyDir.Z < -0.5 * EnemyDist)
			return (AIRating - 0.3);
	}
	else if ((B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon)
	{
		return (AIRating + 0.35);
	}
	else if (EnemyDist < 1400)
	{
		return (AIRating + 0.2);
	}
	return FMax(AIRating + 0.2 - (EnemyDist - 1400) * 0.0008, 0.2);
}

function byte BestMode()
{
	local vector EnemyDir;
	local float EnemyDist;
	local bot B;

	B = Bot(Instigator.Controller);
	if ((B == None) || (B.Enemy == None))
		return 0;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if (EnemyDist > 1550)
	{
		if (EnemyDir.Z < -0.5 * EnemyDist)
			return 1;
		return 0;
	}
	else if ((B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon)
	{
		return 0;
	}
	else if ((EnemyDist < 700) || (EnemyDir.Z > 30))
	{
		return 0;
	}
	else if (FRand() < 0.65)
	{
		return 1;
	}

	return 0;
}

function float SuggestAttackStyle()
{
	if ((AIController(Instigator.Controller) != None) && (AIController(Instigator.Controller).Skill < 3))
		return -0.4;

	return -0.8;
}

function float SuggestDefenseStyle()
{
	return -1.4;
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.HowitzerFire'
     FireModeClass(1)=Class'tk_FHIWeapons.HowitzerAirBurst'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     SelectSound=Sound'tk_FHIWeapons.FHISnd.GrenadeLauncher_Select'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.750000
     CurrentRating=0.750000
     Description="After the introduction of the new Onslaught tournament arenas, Radiant-Technologies decided that some heavy duty firepower was needed to combat the new vehicles. Looking back through Earth's history records, they came across numberous references to heavy artillery vehicles used during the twentieth century, and came to the conclusion that a smaller version of this artillery would suit a modern tournament contestant very well indeed. So was born the HA-26 Personal Artillery Weapon (PAW)."
     EffectOffset=(X=200.000000,Y=32.000000,Z=-25.000000)
     DisplayFOV=50.000000
     Priority=35
     HudColor=(G=128)
     SmallViewOffset=(X=8.500000,Y=3.000000,Z=-3.500000)
     CenteredOffsetY=0.000000
     CenteredRoll=500
     CenteredYaw=-300
     CustomCrosshair=16
     CustomCrossHairColor=(B=0,G=128)
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Triad3"
     InventoryGroup=7
     PickupClass=Class'tk_FHIWeapons.HowitzerPickup'
     PlayerViewOffset=(X=6.000000,Y=2.000000,Z=-2.500000)
     BobDamping=2.000000
     AttachmentClass=Class'tk_FHIWeapons.HowitzerAttachment'
     IconMaterial=Texture'tk_FHIWeapons.FHIHud.HUDIcons'
     IconCoords=(X1=44,Y1=242,X2=134,Y2=277)
     ItemName="Howitzer"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=4.000000
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.Howitzer_1st'
     DrawScale=0.150000
}