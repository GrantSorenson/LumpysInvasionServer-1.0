class MagicWandBeamEffect extends ShockBeamEffect;

simulated function SpawnEffects()
{
	local ShockBeamEffect E;
	
	Super.SpawnEffects();
	E = Spawn(class'ExtraRedBeam');
	if (E != None)
		E.AimAt(mSpawnVecA, HitNormal); 
}
	
simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
	Spawn(class'MagicWandImpactFlare',,, EffectLoc, HitRot);
	Spawn(class'MagicWandImpactRing',,, EffectLoc, HitRot);
	Spawn(class'MagicWandImpactScorch',,, EffectLoc, Rotator(-HitNormal));
	Spawn(class'MagicWandExplosionCoreB',,, EffectLoc, HitRot);
}

defaultproperties
{
     CoilClass=Class'tk_MagicWand.MagicWandCoilB'
     MuzFlashClass=Class'XEffects.ShockMuzFlashB'
     MuzFlash3Class=Class'XEffects.ShockMuzFlashB3rd'
     bNetTemporary=False
     Skins(0)=ColorModifier'tk_MagicWand.MagicWand.MWBeam'
}