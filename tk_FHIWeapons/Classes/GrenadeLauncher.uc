class GrenadeLauncher extends tk_Weapon
      config(TKWeaponsClient);

function float SuggestAttackStyle()
{
	local float EnemyDist;

	EnemyDist = VSize(Instigator.Controller.Enemy.Location - Owner.Location);
	if (EnemyDist < 750)
	{
		if (EnemyDist < 500)
			return -1.3;
		else
			return -0.5;
	}
	else if (EnemyDist > 1000)
	{
		return 1.5;
	}
	else
	{
		return 0.1;
	}
}

function float GetAIRating()
{
	local Bot B;
	local float EnemyDist, Rating, ZDiff;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ((B == None) || (B.Enemy == None))
		return AIRating;

	if ((Instigator.Base != None) && (Instigator.Base.Velocity != vect(0,0,0)) && !B.CheckFutureSight(0.1))
		return 0.1;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	Rating = AIRating;

	if (EnemyDist < 460)
	{
		if (Instigator.Weapon == self)
		{
			if ((EnemyDist > 250) || ((Instigator.Health < 50) && (Instigator.Health < B.Enemy.Health - 30)))
				return Rating;
		}
		return 0.05 + EnemyDist * 0.001;
	}

	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if (ZDiff > 60)
		Rating += 0.25;
	else if (ZDiff < -160)
		Rating -= 0.35;
	else if (ZDiff < -80)
		Rating -= 0.05;

	return Rating;
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
	if (EnemyDist > 950)
	{
		if (EnemyDir.Z < -0.5 * EnemyDist)
			return 1;
		return 0;
	}
	else if ((B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon)
	{
		return 0;
	}
	else if ((EnemyDist < 600) || (EnemyDir.Z > 30))
	{
		return 0;
	}
	else if (FRand() < 0.75)
	{
		return 1;
	}

	return 0;
}

simulated function float ChargeBar()
{
	return FMin(1, FireMode[0].HoldTime / GrenadePrimaryFire(FireMode[0]).mHoldClampMax);
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.GrenadePrimaryFire'
     FireModeClass(1)=Class'tk_FHIWeapons.GrenadeSecondaryFire'
     PutDownAnim="PutDown"
     IdleAnimRate=0.200000
     SelectSound=Sound'tk_FHIWeapons.FHISnd.GrenadeLauncher_Select'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.750000
     CurrentRating=0.750000
     bShowChargingBar=True
     Description="The MkI concussion grenade launcher was originally intended for use in a light support role, but quickly fell out of favour due to the lack of any real punch. Shortly after the MkI was exiled to the scrap heap, the MkII was manufactured, featuring an upgraded concussion grenade delivery system, and was quickly incorporated into the NEG heavy assault arsenal. Soon after this, the secondary PPG (plasma pulse grenade) was also added, giving a basic foot trooper the firepower to go toe to toe with even a heavy assault vehicle."
     EffectOffset=(X=100.000000,Y=32.000000,Z=-20.000000)
     DisplayFOV=60.000000
     Priority=25
     HudColor=(B=255,G=0,R=0)
     SmallViewOffset=(X=166.000000,Y=48.000000,Z=-54.000000)
     InventoryGroup=7
     GroupOffset=25
     PickupClass=Class'tk_FHIWeapons.GrenadeLauncherPickup'
     PlayerViewOffset=(X=150.000000,Y=40.000000,Z=-46.000000)
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.GrenadeLauncherAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=434,Y1=253,X2=506,Y2=292)
     ItemName="Plasma Grenade Launcher"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=150.000000
     LightRadius=4.000000
     Mesh=SkeletalMesh'ONSWeapons-A.GrenadeLauncher_1st'
}