class ElectricDragon extends Dragon;

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
				Health = MyDRI.ElectricDragonHealth;
			}
		}
	}

	Super.PostBeginPlay();
}

defaultproperties
{
	 MonsterName="Electric Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.ElectricWing'
     ExplodeClass=Class'tk_2009Dragonv2.ElectricDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.ElectricBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.ElectricProjectile'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.ElectricDragonRoar01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.ElectricDragonRoar01'
     Skins(0)=Shader'tk_2009Dragonv2.Skins.BlackBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.BlackHead'
}
