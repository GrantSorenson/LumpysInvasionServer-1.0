class SC_MuzFlash extends Emitter
	notplaceable;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter79
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=255,G=64,R=128))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=255,G=64,R=128))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Y=(Max=2.000000),Z=(Min=0.670000))
         Opacity=0.670000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationRange=(X=(Max=16.000000))
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=3.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=7.000000)
         StartSizeRange=(X=(Min=33.000000,Max=67.000000))
         InitialParticlesPerSecond=20.000000
         Texture=Texture'AW-2004Particles.Energy.EclipseCircle'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.600000,Max=0.600000)
     End Object
     Emitters(0)=SpriteEmitter'UT2k4AssaultFull.FX_NewIonPlasmaBeam.SpriteEmitter79'

     bNoDelete=False
     bHardAttach=True
}
