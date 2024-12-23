class FireDragon extends Dragon;

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
				Health = MyDRI.FireDragonHealth;
			}
		}
	}

	Super.PostBeginPlay();
}

defaultproperties
{
	 MonsterName="Fire Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.FireWing'
     ExplodeClass=Class'tk_2009Dragonv2.FireDragonExplode'
     ProjectileClass=Class'tk_2009Dragonv2.FireProjectile'
}
