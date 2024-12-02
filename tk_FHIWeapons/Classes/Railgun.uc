class Railgun extends tk_Weapon
    config(TKWeaponsClient);

simulated function bool WeaponCentered()
{
	return ( bSpectated || (Hand > 1) || (Hand == 0) );
}

/* BestMode()
choose between regular or alt-fire
*/
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
	if ( EnemyDist > 1125 )
	{
		return 0;
	}
	else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return 1;
	else if ( (EnemyDist < 500) )
		return 1;
	else if ( FRand() < 0.65 )
		return 0;
	return 0;
}

function float SuggestAttackStyle()
{
	if ( (AIController(Instigator.Controller) != None)
		&& (AIController(Instigator.Controller).Skill < 3) )
		return 0.4;
    return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.1;
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.RailgunProjFire'
     FireModeClass(1)=Class'tk_FHIWeapons.RailgunAltFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'tk_FHIWeapons.FHISnd.Generic_Pickup01'
     SelectForce="SwitchToLinkGun"
     AIRating=0.720000
     CurrentRating=0.690000
     Description="ICE-Tech Systems' deluxe model Gauss Particle Gun is the industry standard in magnetic weaponry. There has not been a single report of a malfunction or breakdown in one of these weapons since they were first commissioned, due to the total lack of any moving parts. The Gauss Particle Gun uses magnetic energy to propel it's projectiles at hyper velocity and with incredible accuracy, and has become one of the more favoured weapons in the Tournament of late."
     EffectOffset=(X=65.000000,Y=14.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=17
     HudColor=(B=255,G=0,R=128)
     SmallViewOffset=(X=2.000000,Z=-1.500000)
     CenteredOffsetY=-5.000000
     CenteredRoll=3000
     CenteredYaw=-1000
     CustomCrossHairColor=(B=128,R=128)
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Bracket1"
     InventoryGroup=5
     GroupOffset=23
     PickupClass=Class'tk_FHIWeapons.RailgunPickup'
     PlayerViewOffset=(X=-5.000000,Y=-3.000000)
     PlayerViewPivot=(Yaw=500)
     BobDamping=3.000000
     AttachmentClass=Class'tk_FHIWeapons.RailgunAttachment'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=169,Y1=78,X2=244,Y2=124)
     ItemName="Particle Gun"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=170
     LightSaturation=235
     LightBrightness=150.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.FatLinkGun'
     Skins(0)=Shader'tk_FHIWeapons.FHIShaders.RailgunShader'
     Skins(1)=Shader'UT2004Weapons.Shaders.PurpleShockShader'
     Skins(2)=Shader'UT2004Weapons.Shaders.LinkGlassShader'
}
