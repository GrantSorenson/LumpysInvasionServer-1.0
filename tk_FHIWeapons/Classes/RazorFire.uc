class RazorFire extends tk_FlakFire;

function InitEffects()
{
}

defaultproperties
{
     ProjPerFire=3
     TransientSoundVolume=1.000000
     FireSound=Sound'tk_FHIWeapons.FHISnd.RazorBomb_Fire'
     FireRate=0.275000
     AmmoClass=Class'tk_FHIWeapons.RazorBombAmmo'
     ProjectileClass=Class'tk_FHIWeapons.Razor'
     BotRefireRate=0.850000
     Spread=1200.000000
}
