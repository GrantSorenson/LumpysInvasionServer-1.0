class HVAssaultFire extends tk_InstantFire;

var float LastFireTime, ClickTime;

function InitEffects()
{
	Super.InitEffects();
	if (FlashEmitter != None)
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function FlashMuzzleFlash()
{
	local rotator r;

	r.Roll = (0);
	Weapon.SetBoneRotation('Bone_Flash', r, 0, 1.f);

	Super.FlashMuzzleFlash();
}

event ModeDoFire()
{
	if (Level.TimeSeconds - LastFireTime > 0.5)
		Spread = default.Spread;
	else
		Spread = FMin(Spread + 0.02, 0.12);

	LastFireTime = Level.TimeSeconds;
	Super.ModeDoFire();
}

simulated function bool AllowFire()
{
	if (Super.AllowFire())
	{
		return true;
	}
	else
	{
		if ((PlayerController(Instigator.Controller) != None) && (Level.TimeSeconds > ClickTime))
		{
			Instigator.PlaySound(Sound'WeaponSounds.P1Reload5');
			ClickTime = Level.TimeSeconds + 0.25;
		}
		return false;
	}
}

function StartBerserk()
{
	DamageMin = default.DamageMin * 1.33;
	DamageMax = default.DamageMax * 1.33;
}

function StopBerserk()
{
	DamageMin = default.DamageMin;
	DamageMax = default.DamageMax;
}

function StartSuperBerserk()
{
	FireRate = default.FireRate * 1.5/Level.GRI.WeaponBerserk;
	FireAnimRate = default.FireAnimRate * 0.667 * Level.GRI.WeaponBerserk;
	DamageMin = default.DamageMin * 1.5;
	DamageMax = default.DamageMax * 1.5;
	if (HVAssaultRifle(Weapon) != None && HVAssaultRifle(Weapon).bDualMode)
		FireRate *= 0.55;
}

defaultproperties
{
     DamageType=Class'tk_FHIWeapons.DamTypeHVAssaultBullet'
     DamageMin=11
     DamageMax=14
     Momentum=0.000000
     bPawnRapidFireAnim=True
     bReflective=True
     TransientSoundVolume=1.000000
     FireLoopAnim=
     FireEndAnim=
     FireSound=Sound'tk_FHIWeapons.FHISnd.HVAssaultRifleFire'
     FireForce="AssaultRifleFire"
     FireRate=0.095000
     AmmoClass=Class'tk_FHIWeapons.HVAssaultAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=1.000000,Y=1.000000,Z=1.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'tk_FHIWeapons.HVAssaultMuzFlash'
     aimerror=800.000000
     Spread=0.015000
     SpreadStyle=SS_Random
}