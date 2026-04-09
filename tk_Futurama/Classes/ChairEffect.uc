class ChairEffect extends Emitter
	placeable;

function PostBeginPlay()
{
	SetTimer(0.5, true);
}

simulated function SetDefaultColor()
{
	Emitters[0].ColorScale[0].Color = class'Canvas'.static.MakeColor(255, 180, 63);
	Emitters[0].ColorScale[1].Color = class'Canvas'.static.MakeColor(255, 180, 63);
	Emitters[1].ColorScale[0].Color = class'Canvas'.static.MakeColor(255, 180, 63);
	Emitters[1].ColorScale[1].Color = class'Canvas'.static.MakeColor(255, 180, 63);
}

// function Timer()
// {
// 	if( Owner == none || (Pawn(Owner) != None && Pawn(Owner).Health <= 0 ))
//     {
//        Destroy();
//        return;
//     }

// 	if ( Owner != none && Owner.PhysicsVolume != None && Owner.PhysicsVolume.bWaterVolume && Pawn(Owner).DrivenVehicle == None )
// 	{
// 		Emitters[2].Disabled = false;
// 		Emitters[1].Disabled = true;
// 		Emitters[0].Disabled = true;
// 	}

// 	else if(Owner != none && Pawn(Owner).DrivenVehicle != None)
// 	{
// 		Emitters[2].Disabled = true;
// 		Emitters[1].Disabled = true;
// 		Emitters[0].Disabled = true;
// 	}

// 	else
// 	{
// 		Emitters[2].Disabled = true;
// 		Emitters[1].Disabled = false;
// 		Emitters[0].Disabled = false;
// 	}
// }

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Forward
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(X=110.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         FadeOutStartTime=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         StartLocationOffset=(X=2.000000)
         StartLocationRange=(Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         SpinsPerSecondRange=(X=(Min=0.450000,Max=0.500000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=7.000000,Max=7.000000))
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=0.700000,Max=0.900000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Futurama.ChairEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         FadeOutStartTime=0.150000
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         StartLocationOffset=(X=2.500000)
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.100000)
         StartSizeRange=(X=(Min=3.000000,Max=6.000000),Y=(Min=25.000000,Max=30.000000))
         Texture=Texture'EmitterTextures.Flares.EFlaredim2'
         LifetimeRange=(Min=0.400000,Max=0.500000)
         StartVelocityRange=(X=(Min=120.000000,Max=120.000000),Y=(Min=-55.000000,Max=55.000000),Z=(Min=-55.000000,Max=55.000000))
     End Object
     Emitters(1)=SpriteEmitter'tk_Futurama.ChairEffect.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         Disabled=True
         Backup_Disabled=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(X=300.000000)
         FadeOutStartTime=0.300000
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         StartLocationOffset=(X=2.000000)
         StartLocationRange=(Y=(Min=-4.000000,Max=4.000000),Z=(Min=-4.000000,Max=4.000000))
         SpinsPerSecondRange=(X=(Min=0.450000,Max=0.500000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=1.000000,Max=2.500000))
         Texture=Texture'EmitterTextures.SingleFrame.Bubble'
         LifetimeRange=(Min=0.500000,Max=0.650000)
     End Object
     Emitters(2)=SpriteEmitter'tk_Futurama.ChairEffect.SpriteEmitter2'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bHardAttach=True
}
