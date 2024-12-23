class WindDragon extends Dragon;

var float WindStrength;

Simulated function PostBeginPlay()
{
	if(Role == Role_Authority)
	{
		foreach DynamicActors(class'DragonGameReplicationInfo', DRI)
		{
			MyDRI = DRI;
		}

		if(MyDRI != None)
		{
			if(MyDRI.UseConfigs)
			{
				Health = MyDRI.WindDragonHealth;
			}

			WindStrength = MyDRI.WindStrength;
		}
	}

	Super.PostBeginPlay();
}

function FireBreath()
{
	local coords BoneLocation;
	local Actor A;

	local vector dir;
	local float dist;

	BoneLocation = GetBoneCoords('ProjBone');

	foreach VisibleCollidingActors ( class'Actor', A, 150, BoneLocation.Origin )
	{
		if(A != None && A != Self)
		{
			dir = A.Location - Location;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;

			A.TakeDamage(FireBreathDamage,Self,A.Location - 0.5 * (A.CollisionHeight + A.CollisionRadius) * dir,(1 * WindStrength * dir),ProjectileClass.default.MyDamageType);
		}
	}

	return;

	Super.FireBreath();
}

event GainedChild(Actor Other)
{
	if(Other.Class == class'WindProjectile')
	{
	  	WindProjectile(Other).MomentumTransfer = WindStrength;
	}

  Super.GainedChild(Other);
}

defaultproperties
{
	 MonsterName="Wind Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.WindWing'
     ExplodeClass=Class'tk_2009Dragonv2.WindDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.WindBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.WindProjectile'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.WindDragonRoar01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.WindDragonRoar01'
     Skins(0)=Shader'tk_2009Dragonv2.Skins.WhiteBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.WhiteHead'
}
