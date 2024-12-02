class RailgunProjSparksNEW extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=235,G=128,R=185))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=235,G=128,R=185))
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartSizeRange=(X=(Min=-75.000000,Max=-75.000000),Y=(Min=25.000000,Max=25.000000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'tk_FHIWeapons.FHITex.PlasmaHead_A'
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Max=10.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=2.000000
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.RailgunProjSparksNEW.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=254,G=148,R=225))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=238,G=57,R=143))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         StartLocationOffset=(X=-50.000000)
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=8.500000,Max=13.000000))
         Texture=Texture'AW-2004Particles.Weapons.BoloBlob'
         LifetimeRange=(Min=0.400000,Max=0.400000)
         StartVelocityRange=(X=(Min=600.000000,Max=600.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=2.000000
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.RailgunProjSparksNEW.SpriteEmitter1'

     bNoDelete=False
     Physics=PHYS_Trailer
     DrawScale=0.500000
}