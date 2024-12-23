class LurveDragon extends Dragon;

var bool LurveDragonLoveMonsters;
var int LurveHealthMax;
var int LurveHealthAmount;
var float LurveRange;

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
				Health = MyDRI.LurveDragonHealth;
			}

			LurveDragonLoveMonsters = MyDRI.LurveDragonLoveMonsters;
			LurveHealthMax = MyDRI.LurveHealthMax;
			LurveHealthAmount = MyDRI.LurveHealthAmount;
			LurveRange = MyDRI.LurveRange;

			if(LurveDragonLoveMonsters)
			{
				SetTimer(RandRange(3.00,10.00),false);
			}
		}
	}

	Super.PostBeginPlay();
}

function Timer()
{
 	local Monster M ;

	if(LurveDragonLoveMonsters)
	{
		foreach VisibleCollidingActors(class'Monster',M,LurveRange,Location)
		{
			if(M != None && M.Health != 0 && M.Health < LurveHealthMax)
			{
				M.Health = Min( M.Health + LurveHealthAmount, LurveHealthMax );
				Spawn(class'LurveEmitter',self,,M.Location);
			}
		}

		SetTimer(RandRange(3.00,10.00),false);
	}

	Super.Timer();
}

defaultproperties
{
	 MonsterName="Love Dragon"
     TrailEffectClass=Class'tk_2009Dragonv2.LurveWing'
     ExplodeClass=Class'tk_2009Dragonv2.LurveDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.LurveBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.LurveProjectile'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.LurveDragonRoar01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.LurveDragonRoar01'
     Skins(0)=Shader'tk_2009Dragonv2.Skins.PinkBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.PinkHead'
}
