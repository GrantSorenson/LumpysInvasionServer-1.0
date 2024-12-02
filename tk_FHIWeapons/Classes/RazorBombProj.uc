class RazorBombProj extends rGrenade;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
	PlaySound(Sound'tk_FHIWeapons.FHISnd.Explode_Generic02',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'NewExplosionB',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
    Destroy();
}

defaultproperties
{
     ExplodeTimer=1.000000
     Speed=1200.000000
     MaxSpeed=16000.000000
     Damage=150.000000
     DamageRadius=350.000000
     MomentumTransfer=95000.000000
     MyDamageType=Class'tk_FHIWeapons.DamTypeRazorBomb'
     StaticMesh=StaticMesh'XGame_rc.BallMesh'
     DrawScale=0.750000
}
