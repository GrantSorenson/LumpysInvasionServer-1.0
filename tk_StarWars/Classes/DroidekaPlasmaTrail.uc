class DroidekaPlasmaTrail extends Emitter;

simulated event BaseChange()
{
	if(Base == None)
	{
		Kill();
	}
	super.BaseChange();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=4.000000,Max=4.000000))
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=0.800000,Max=0.800000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_StarWars.DroidekaPlasmaTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Normal
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSizeRange=(X=(Min=35.000000,Max=30.000000),Y=(Min=10.000000,Max=10.000000))
         Texture=Texture'AW-2004Particles.Energy.AngryBeam'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'tk_StarWars.DroidekaPlasmaTrail.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bNotOnDedServer=False
}
