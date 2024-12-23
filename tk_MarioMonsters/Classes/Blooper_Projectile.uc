class Blooper_Projectile extends MM_Projectile placeable;

var() bool bCanBlindPlayers;
var() float InkDuration;

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	local PlayerController PC;
	local int i;
	local bool bHasInteraction;

	if(bCanBlindPlayers && Pawn(Other) != None && Pawn(Other).Controller != None && PlayerController(Pawn(Other).Controller) != None)
	{
		PC = Level.GetLocalPlayerController();
		if(PC != None && PC == PlayerController(Pawn(Other).Controller) && PC.Player != None)
		{
			//does the player already have the interaction
			for ( i = 0; i < PC.Player.LocalInteractions.Length; i++ )
			{
					if ( BlooperInteraction(PC.Player.LocalInteractions[i]) != None )
					{
						BlooperInteraction(PC.Player.LocalInteractions[i]).InkStartTime = Level.TimeSeconds;
						bHasInteraction=true;
					}
			}

			if(!bHasInteraction)
			{
				PC.Player.InteractionMaster.AddInteraction("tk_MarioMonsters.BlooperInteraction", PC.Player);
			}
		}
	}

	Super.ProcessTouch(Other, HitLocation);
}

defaultproperties
{
     bCanBlindPlayers=True
     Inkduration=5.000000
     TrailClass=Class'tk_MarioMonsters.Blooper_ProjectileTrail'
     ExplosionClass=Class'tk_MarioMonsters.Blooper_ProjectileExplosion'
     Speed=1000.000000
     MaxSpeed=1500.000000
     TossZ=0.000000
     Damage=30.000000
     DamageRadius=150.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'tk_MarioMonsters.DamType_Blooper_Projectile'
     ImpactSound=Sound'GeneralImpacts.Water.ImpactSplash1'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     CullDistance=4000.000000
     bDynamicLight=True
     LifeSpan=10.000000
     DrawScale3D=(X=2.550000,Y=1.700000,Z=1.700000)
     PrePivot=(X=10.000000)
     Skins(0)=FinalBlend'tk_MarioMonsters.MarioMonsters.Blooper_proj_fb'
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=5.000000
}
