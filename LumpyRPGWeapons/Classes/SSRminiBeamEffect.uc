//============================================================================
// SSRminiBeamEffect
//============================================================================

class SSRminiBeamEffect extends ShockBeamEffect;
#exec obj load file=InstagibEffects.utx

simulated function SpawnEffects()
{

   local ShockBeamEffect E;

   Super.SpawnEffects();
   E = Spawn(class'ExtraRedBeam');
   if ( E != None )
           E.AimAt(mSpawnVecA, HitNormal);
}
   defaultproperties
{
     CoilClass=Class'XEffects.ShockBeamCoilB'
     MuzFlashClass=Class'XEffects.ShockMuzFlashB'
     MuzFlash3Class=Class'XEffects.ShockMuzFlashB3rd'
     bNetTemporary=False
     Skins(0)=ColorModifier'InstagibEffects.Effects.RedSuperShockBeam'
}