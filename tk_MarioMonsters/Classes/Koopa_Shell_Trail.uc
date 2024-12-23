class Koopa_Shell_Trail extends MM_Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailLocation=PTTL_FollowEmitter
         PointLifeTime=50.000000
         UseColorScale=True
         FadeOut=True
         ColorScale(0)=(Color=(B=48,G=191))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=10.000000)
         StartSizeRange=(X=(Min=1.000000,Max=3.000000))
         Texture=Texture'AW-2004Particles.Weapons.SoftFade'
         LifetimeRange=(Min=0.200000,Max=0.500000)
     End Object
     Emitters(0)=TrailEmitter'tk_MarioMonsters.Koopa_Shell_Trail.TrailEmitter0'

}
