class Lakitu_Projectile extends MM_Projectile placeable;

var() float SpinRate;
var() M_Lakitu PawnMaster;
var() bool bSpawnMonster;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer && TrailClass != None )
    {
        Trail = Spawn(TrailClass, self);
        Trail.SetBase(self);
    }

    Velocity = Vector(Rotation) * Speed;
    Velocity.Z += TossZ;
    initialDir = Velocity;
    RotationRate.Pitch = SpinRate;

    if(Role == Role_Authority)
    {
		PlaySound(Sound'tk_MarioMonsters.Lakitu.LakituThrow',SLOT_Interact);
	}

}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    PlaySound(ImpactSound, SLOT_Misc);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(ExplosionClass,,, Location);
	}
    SetCollisionSize(0.0, 0.0);
    SpawnSpiny();
    Destroy();
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	Landed( HitNormal );
}

simulated function Landed( vector HitNormal )
{
	Explode(Location, HitNormal);
}

function SpawnSpiny()
{
	local Monster Summoned;
	local class<Monster> MonsterClass;
	local Inventory Inv;
	local class<Inventory> InvClass;


	if(Role == Role_Authority && PawnMaster != None)
	{
		if(PawnMaster.CanSpawnSpiny())
		{
			//change sound
			PlaySound(ImpactSound,SLOT_Interact);
			MonsterClass = class<Monster>(DynamicLoadObject("tk_MarioMonsters.Spiny", class'class',true));
			if(MonsterClass != None)
			{
				Summoned = Spawn(MonsterClass,self,, Location + vect(0,0,20));
				if(Summoned != None)
				{
					if(Invasion(Level.Game) != None)
					{
						Invasion(Level.Game).NumMonsters++;
					}

					InvClass = class<Inventory>(DynamicLoadObject("tk_MarioMonsters.Lakitu_Inv",class'class',true));
					if(Summoned.FindInventoryType(InvClass) == None)
					{
						Inv = Spawn(InvClass, Summoned,,,);
						if(Lakitu_Inv(Inv) != None)
						{
							Lakitu_Inv(Inv).PawnMaster = PawnMaster;
							Inv.GiveTo(Summoned);
						}
					}
				}
			}
		}
	}
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector RefNormal;

    if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        Explode(HitLocation, RefNormal);
    }
    else if ( Other.bProjTarget )
    {
        if ( Role == ROLE_Authority )
            Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
        Explode(HitLocation, vect(0,0,1));
    }
}

defaultproperties
{
     spinRate=-150000.000000
     bSpawnMonster=True
     TrailClass=Class'tk_MarioMonsters.Lakitu_ProjectileTrail'
     ExplosionClass=Class'tk_MarioMonsters.Lakitu_ProjectileExplosion'
     Speed=800.000000
     MaxSpeed=800.000000
     Damage=30.000000
     DamageRadius=0.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_MarioMonsters.DamType_Lakitu_Projectile'
     LightRadius=4.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_MarioMonsters.MarioMonsters.Spiny_shell'
     CullDistance=4000.000000
     bNetTemporary=False
     Physics=PHYS_Falling
     LifeSpan=5.000000
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.Koopa_skin'
     Skins(1)=Texture'tk_MarioMonsters.MarioMonsters.Spiny_skin'
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bProjTarget=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000)
}
