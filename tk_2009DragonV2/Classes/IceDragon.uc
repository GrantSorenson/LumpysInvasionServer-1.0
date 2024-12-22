class IceDragon extends Dragon;

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
				Health = MyDRI.IceDragonHealth;
			}
		}
	}

	Super.PostBeginPlay();
}

defaultproperties
{
	 MonsterName="Ice Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.IceWing'
     ExplodeClass=Class'tk_2009Dragonv2.IceDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.IceBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.IceProjectile'
     Skins(0)=Shader'tk_2009Dragonv2.Skins.BlueBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.BlueHead'
}
