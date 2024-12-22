class IonWing extends DragonWing;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter1
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         DistanceThreshold=10.000000
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorMultiplierRange=(X=(Min=0.600000),Y=(Min=0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=1.500000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'AW-2004Particles.Energy.AngryBeam'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=TrailEmitter'tk_2009Dragonv2.IonWing.TrailEmitter1'

}
