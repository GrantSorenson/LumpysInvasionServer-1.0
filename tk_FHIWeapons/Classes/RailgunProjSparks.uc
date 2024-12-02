class RailgunProjSparks extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter35
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
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.RailgunProjSparks.SpriteEmitter35'

     bNoDelete=False
     Physics=PHYS_Trailer
     DrawScale=0.500000
}