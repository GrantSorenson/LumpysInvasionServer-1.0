class DragonRagTest extends KActor placeable;

defaultproperties
{
     DrawType=DT_Mesh
     Physics=PHYS_KarmaRagDoll
     Mesh=SkeletalMesh'tk_2009Dragonv2.DragonMesh'
     DrawScale=0.200000
     CollisionRadius=85.000000
     CollisionHeight=85.000000
     bCollideWorld=True
     bBlockActors=False
     Begin Object Class=KarmaParamsSkel Name=Squibble0
         KSkeleton="2009DragonRagdollv2"
         KFriction=0.100000
     End Object
     KParams=KarmaParamsSkel'tk_2009Dragonv2.DragonRagTest.Squibble0'

}
