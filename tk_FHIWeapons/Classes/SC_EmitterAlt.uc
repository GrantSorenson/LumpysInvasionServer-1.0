//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SC_EmitterAlt extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=BlackHole
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=96,G=255,R=64,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=255,R=64,A=255))
         CoordinateSystem=PTCS_Relative
         StartLocationPolarRange=(Z=(Max=100.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=160.000000,Max=160.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'XEffects.Skins.ExplosionFlashTex'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'tk_FHIWeapons.SC_EmitterAlt.BlackHole'

     Begin Object Class=SpriteEmitter Name=Particles
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         UseRevolution=True
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=16,G=128,R=16,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=16,G=128,R=16))
         CoordinateSystem=PTCS_Relative
         MaxParticles=80
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=400.000000,Max=400.000000)
         StartLocationPolarRange=(Y=(Min=-5000.000000,Max=5000.000000),Z=(Min=200.000000,Max=200.000000))
         RevolutionsPerSecondRange=(X=(Min=0.400000,Max=0.400000))
         SpinCCWorCW=(X=0.000000)
         StartSpinRange=(X=(Min=0.250000,Max=0.250000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=60.000000,Max=60.000000),Y=(Min=60.000000,Max=60.000000),Z=(Min=60.000000,Max=60.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         SubdivisionEnd=1
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRadialRange=(Min=-700.000000,Max=-700.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(1)=SpriteEmitter'tk_FHIWeapons.SC_EmitterAlt.Particles'

     bNoDelete=False
}
