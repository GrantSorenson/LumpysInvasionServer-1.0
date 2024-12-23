class NatureDragon extends Dragon;

var int NatureAmountMax;

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
				Health = MyDRI.NatureDragonHealth;
			}
			NatureAmountMax = MyDRI.NatureAmountMax;
		}
	}

	Super.PostBeginPlay();
}

event GainedChild(Actor Other)
{
	if(Other.Class == class'NatureProjectile')
	{
	  	NatureProjectile(Other).NatureAmountMax = NatureAmountMax;
	}

  Super.GainedChild(Other);
}

defaultproperties
{
	 MonsterName="Nature Dragon"
     NatureAmountMax=5
     TrailEffectClass=Class'tk_2009Dragonv2.NatureWing'
     ExplodeClass=Class'tk_2009Dragonv2.NatureDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.NatureBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.NatureProjectile'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.NatureDragonRoar01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.NatureDragonRoar01'
     Skins(0)=Shader'tk_2009Dragonv2.Skins.GreenBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.GreenHead'
}
