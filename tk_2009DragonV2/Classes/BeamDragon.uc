class BeamDragon extends Dragon;

var Name BeamBones[3];
var int BeamAmount;

simulated function PostBeginPlay()
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
				Health = MyDRI.BeamDragonHealth;
			}

			BeamAmount = MyDRI.BeamAmount;
		}
	}

	Super.PostBeginPlay();
}

function FireDragonBall()
{
	local vector FireStart,X,Y,Z;
	local coords BoneLocation;
	local int i;

	if ( Controller != None )
	{
		FireStart = GetFireStart(X,Y,Z);

		for(i=0;i<BeamAmount;i++)
		{
			BoneLocation = GetBoneCoords(BeamBones[Rand(3)]);
			Spawn(ProjectileClass,self,,BoneLocation.Origin,Controller.AdjustAim(SavedFireProperties,FireStart,AimError));
		}

		PlaySound(DragonProjectileSounds[Rand(2)],SLOT_Interact,255);
	}

	return;

	Super.FireDragonBall();
}

defaultproperties
{
     BeamBones(0)="ProjBone"
     BeamBones(1)="BeamBone01"
     BeamBones(2)="BeamBone02"
     BeamAmount=3
     TrailEffectClass=Class'tk_2009Dragonv2.BeamWing'
     ExplodeClass=Class'tk_2009Dragonv2.BeamDragonExplode'
     FireBreathClass=Class'tk_2009Dragonv2.BeamBreathTrail'
     ProjectileClass=Class'tk_2009Dragonv2.BeamProjectile'
     DragonProjectileSounds(0)=Sound'tk_2009Dragonv2.BeamDragonRoar01'
     DragonProjectileSounds(1)=Sound'tk_2009Dragonv2.BeamDragonRoar01'
     Skins(0)=Shader'tk_2009Dragonv2.Skins.YellowBodyShader'
     Skins(1)=Texture'tk_2009Dragonv2.Skins.YellowHead'
}
