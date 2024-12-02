//=============================================================================
// MP5grenade.
//=============================================================================
class MP5Gungrenade extends Grenade;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'shockcombocore',,, HitLocation, rotator(vect(0,0,1)));
		 Spawn(class'shockexplosion',,, HitLocation, rotator(vect(0,0,1)));
 		Spawn(class'smallredeemerExplosion',,, HitLocation, rotator(vect(0,0,1)));

		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
    Destroy();
}

defaultproperties
{
    Damage=90.00
    DamageRadius=300.00
    MyDamageType=Class'DamTypeMP5Grenade'
    Skins=
}
