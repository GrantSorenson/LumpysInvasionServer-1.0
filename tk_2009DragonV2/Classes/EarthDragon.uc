class EarthDragon extends Dragon;

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
				Health = MyDRI.EarthDragonHealth;
			}
		}
	}

	Super.PostBeginPlay();
}

defaultproperties
{
	 MonsterName="Earth Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.EarthWing'
     ExplodeClass=Class'tk_2009Dragonv2.EarthDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.EarthBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.EarthProjectile'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.EarthDragonRoar01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.EarthDragonRoar01'
     Skins(0)=Shader'tk_2009Dragonv2.Skins.BrownBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.BrownHead'
}
