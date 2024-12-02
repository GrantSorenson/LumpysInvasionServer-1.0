class Shotgun extends tk_Weapon
	config(TKWeaponsClient);

function byte BestMode()
{
	local vector EnemyDir;
	local float EnemyDist;
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 1955 )
	{
		return 0;
	}
	else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return 1;
	else if ( (EnemyDist < 1000) )
		return 1;
	else if ( (EnemyDist < 150) )
		return 0; // Point blank incendiary blast is not good for the bot's health...
	else if ( FRand() < 0.65 )
		return 0;
	return 0;
}

function float SuggestAttackStyle()
{
	local float EnemyDist;

	// recommend backing off if target is too close
	EnemyDist = VSize(Instigator.Controller.Enemy.Location - Owner.Location);
	if ( EnemyDist < 550 )
	{
		if ( EnemyDist < 400 )
			return -1.1;
		else
			return -0.7;
	}
	else if ( EnemyDist > 900 )
		return 0.5;
	else
		return -0.1;
}

function float SuggestDefenseStyle()
{
    return -0.4;
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.ShotgunAltFire'
     FireModeClass(1)=Class'tk_FHIWeapons.ShotgunAltFireNew'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     IdleAnimRate=0.850000
     RunAnimRate=1.150000
     SelectAnimRate=0.500000
     PutDownAnimRate=0.750000
     SelectSound=Sound'tk_FHIWeapons.FHISnd.Shotgun_Select'
     AIRating=0.750000
     CurrentRating=0.750000
     Description="The standard issue Combat Shotgun has been in service in one form or another for more than 150 years, due to its dependability and destructive potential. The latest variants have been modified to carry deadly incendiary shells that explode into flames a short time after being fired."
     EffectOffset=(X=200.000000,Y=32.000000,Z=-25.000000)
     DisplayFOV=45.000000
     Priority=21
     SmallViewOffset=(X=12.000000,Y=3.000000,Z=-3.500000)
     CenteredOffsetY=-0.500000
     CenteredRoll=1000
     CenteredYaw=-200
     InventoryGroup=3
     GroupOffset=20
     PickupClass=Class'tk_FHIWeapons.ShotgunPickup'
     PlayerViewOffset=(X=9.000000,Y=1.250000,Z=-2.750000)
     BobDamping=2.000000
     AttachmentClass=Class'tk_FHIWeapons.ShotgunAttachment'
     IconMaterial=Texture'tk_FHIWeapons.FHIHud.HUDIcons'
     IconCoords=(X1=39,Y1=36,X2=131,Y2=74)
     ItemName="Shotgun"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=4.000000
     Mesh=SkeletalMesh'tk_FHIWeapons.FHIAnim.CombatShotgun_1st'
     DrawScale=0.280000
}
