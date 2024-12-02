class LaserRifle extends tk_SniperRifle
	config(TKWeaponsClient);

state TickEffects
{
	simulated function Tick( float t )
	{
		if (chargeEmitter == None)
		{
			chargeEmitter = Spawn(class'LaserRifleCharge',self);
			AttachToBone(chargeEmitter, 'tip' );
		}
		chargeEmitter.mRegenPause = (FireMode[0].NextFireTime > Level.TimeSeconds || Ammo[0] == None || Ammo[0].AmmoAmount == 0);
	}
}

defaultproperties
{
     FireModeClass(0)=Class'tk_FHIWeapons.LaserRifleFire'
     FireModeClass(1)=Class'tk_FHIWeapons.LaserRifleZoom'
     Description="The standard issue lightning gun was considered to be too weak to stand up to the Radiant-Technologies arsenal of weapons, so they decided to manufacture a high-powered laser rifle to take its place."
     Priority=31
     GroupOffset=27
     PickupClass=Class'tk_FHIWeapons.LaserRiflePickup'
     BobDamping=2.900000
     AttachmentClass=Class'tk_FHIWeapons.LaserRifleAttachment'
     IconMaterial=Texture'tk_FHIWeapons.FHIHud.HUDIcons'
     IconCoords=(X1=38,Y1=369,X2=135,Y2=405)
     ItemName="Laser Rifle"
     LightHue=85
     LightSaturation=0
     LightBrightness=175.000000
     LightRadius=4.000000
     Skins(0)=Texture'tk_FHIWeapons.FHITex.LaserRifleTex'
}