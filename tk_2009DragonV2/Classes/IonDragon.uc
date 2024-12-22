class IonDragon extends Dragon;

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
				Health = MyDRI.IonDragonHealth;
			}
		}
	}

	Super.PostBeginPlay();
}

defaultproperties
{
	 MonsterName="Ion Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.IonWing'
     ExplodeClass=Class'tk_2009Dragonv2.IonDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.IonBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.IonProjectile'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.IonDragonRoar01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.IonDragonRoar01'
     aimerror=200
     Skins(0)=Shader'tk_2009Dragonv2.Skins.PurpleBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.PurpleHead'
}
