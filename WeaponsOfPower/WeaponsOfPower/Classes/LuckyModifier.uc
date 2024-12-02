class LuckyModifier extends LinearUpgradeWeaponModifier;

#EXEC OBJ LOAD FILE=WeaponsOfPowerTextures.utx

var float NextEffectTime;

////////////////////////////////////////////////////////////////////////////////

static function int GetEnhancedSpawnRate() {
	if (default.Configuration == class'LuckyModifierConfiguration') {
		return class<LuckyModifierConfiguration>(default.Configuration).default.EnhancedLuckySpawnRate;
	}

	return 10;
}

////////////////////////////////////////////////////////////////////////////////

simulated function WeaponTick(
	float deltaTime
) {
	local Pickup        P;
	local class<Pickup> ChosenClass;
	local vector        HitLocation;
	local vector        HitNormal;
	local vector        EndTrace;
	local Actor         A;
	local WeaponOfPower Weapon;

	Weapon = WeaponOfPower(self.Owner);

	if (Role < ROLE_Authority) {
		return;
	}

	NextEffectTime -= deltaTime;

	if (NextEffectTime <= 0) {
		if (CurrentLevel < 0) {
			foreach Instigator.CollidingActors(class'Pickup', P, 300) {
				if ( P.ReadyToPickup(0) && WeaponLocker(P) == None )
				{
					A = spawn(class'RocketExplosion',,, P.Location);

					if (A != None) {
						A.RemoteRole = ROLE_SimulatedProxy;

						A.PlaySound(
							sound'WeaponSounds.BExplosion3',
							,
							2.5 * P.TransientSoundVolume,
							,
							P.TransientSoundRadius
						);
					}

					if (
						(P.bDropped      == false)    &&
						(WeaponPickup(P) != None)     &&
						(WeaponPickup(P).bWeaponStay) &&
						(P.RespawnTime != 0.0)
					) {
						P.GotoState('Sleeping');
					} else {
						P.SetRespawn();
					}

					break;
				}
			}

			NextEffectTime = (1.25 + FRand() * 1.25) / -(CurrentLevel - 1);
		} else {
			ChosenClass = ChoosePickupClass();
			EndTrace    = Instigator.Location + vector(Instigator.Rotation) * Instigator.GroundSpeed;

			if (Instigator.Trace(HitLocation, HitNormal, EndTrace, Instigator.Location) != None) {
				HitLocation -= vector(Instigator.Rotation) * 40;
				P = spawn(ChosenClass,,, HitLocation);
			} else {
				P = spawn(ChosenClass,,, EndTrace);
			}

			if (P == None) {
				return;
			}

			if (MiniHealthPack(P) != None) {
				MiniHealthPack(P).HealingAmount *= 2;
			}	else if (AdrenalinePickup(P) != None) {
				AdrenalinePickup(P).AdrenalineAmount *= 2;
			}

			P.RespawnTime = 0.0;
			P.bDropped = true;
			P.GotoState('Sleeping');

			GenerateNextTime();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function class<Pickup> ChoosePickupClass() {
	local array<class<Pickup> > Potentials;
	local Inventory             Inv;
	local Weapon                W;
	local class<Pickup>         AmmoPickupClass;
	local int                   i;
	local int                   Count;

	if (Instigator.Health < Instigator.HealthMax) {
		Potentials[i++] = class'HealthPack';
		Potentials[i++] = class'MiniHealthPack';
	} else {
		if (Instigator.Health < Instigator.HealthMax + 100) {
			Potentials[i++] = class'MiniHealthPack';
			Potentials[i++] = class'MiniHealthPack';
		}

		if (Instigator.ShieldStrength < Instigator.GetShieldStrengthMax()) {
			Potentials[i++] = class'ShieldPack';
		}
	}

	for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory) {
		W = Weapon(Inv);

		if (W != None) {
			if (W.NeedAmmo(0)) {
				AmmoPickupClass = W.AmmoPickupClass(0);

				if (AmmoPickupClass != None) {
					Potentials[i++] = AmmoPickupClass;
				}
			} else if (W.NeedAmmo(1)) {
				AmmoPickupClass = W.AmmoPickupClass(1);

				if (AmmoPickupClass != None) {
					Potentials[i++] = AmmoPickupClass;
				}
			}
		}

		Count++;

		if (Count > 1000) {
			break;
		}
	}

	if (FRand() < 0.05 * CurrentLevel) {
		Potentials[i++] = class'UDamagePack';
	}

	if (
		(i == 0) ||
		(
			(Instigator.Controller != None) &&
			(Instigator.Controller.Adrenaline < Instigator.Controller.AdrenalineMax)
		)
	) {
		Potentials[i++] = class'AdrenalinePickup';
	}

	// For levels after 5, start inserting power ups to spawn.
	if (CurrentLevel > 5) {
		for (i = 0; i < CurrentLevel - 5; ++i) {
			Potentials[i++] = class'WeaponsOfPower'.default.SelfMutator.ArtifactManager.GetRandomArtifact().default.PickupClass;
		}
	}

	return Potentials[Rand(i)];
}

////////////////////////////////////////////////////////////////////////////////

simulated function BringUp(
	optional Weapon PrevWeapon
) {
	// Prevent dropping and picking the weapon up repeatedly to spawn power-ups.
	GenerateNextTime();
}

////////////////////////////////////////////////////////////////////////////////

function GenerateNextTime() {
	if (CurrentLevel <= 5) {
		NextEffectTime = float(Rand(15) + 25) / (CurrentLevel + 1);
	} else {
		// At levels 6-10 reset to lv 1 timing since now we spawn much better
		// artifacts.
		NextEffectTime = GetEnhancedSpawnRate() + float(Rand(15) + 25) / (CurrentLevel - 4);
	}
}

////////////////////////////////////////////////////////////////////////////////

static function string GetLocalString(
	optional int                   iMessage,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
) {
	switch (iMessage) {
		case 0:
			return "Lucky cannot be upgraded!";
	}

	return Super.GetLocalString(iMessage, RelatedPRI_1, RelatedPRI_2);
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    NextEffectTime=10.00
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.LuckyWeaponShader'
    ModifierColor=(R=0,G=128,B=255,A=0),
    configuration=Class'LuckyModifierConfiguration'
    Artifact=Class'LuckyModifierArtifact'
}
