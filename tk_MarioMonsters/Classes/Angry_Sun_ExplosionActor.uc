class Angry_Sun_ExplosionActor extends MM_Projectile placeable;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();
    SetTimer(1, true);
}

simulated event PhysicsVolumeChange( PhysicsVolume NewVolume )
{
	if (NewVolume.bWaterVolume)
	{
		Destroy();
	}
	Super.PhysicsVolumeChange(NewVolume);
}

simulated function Landed( vector HitNormal )
{}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    SetCollisionSize(0.0, 0.0);
    Destroy();
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{}

simulated function HitWall( vector HitNormal, actor Wall )
{}

simulated function Timer()
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
		SetTimer(0,false);
	}
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local Pawn Victims;
    local float damageScale, dist;
    local vector dir;

    if ( bHurtEntry )
        return;

    bHurtEntry = true;
    foreach VisibleCollidingActors( class 'Pawn', Victims, DamageRadius, HitLocation )
    {
        if( (Victims != Instigator) && (Victims.Role == ROLE_Authority) &&
        (Monster(Victims) == None || ( MonsterController(Monster(Victims).Controller) == None || Monster(Victims).Controller.IsA('FriendlyMonsterController'))) )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if ( Victims == LastTouched )
                LastTouched = None;
            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
                (damageScale * Momentum * dir),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        }
    }

    bHurtEntry = false;
}

defaultproperties
{
     MaxSpeed=0.000000
     Damage=10.000000
     DamageRadius=150.000000
     MomentumTransfer=100000.000000
     MyDamageType=Class'tk_MarioMonsters.DamType_Angry_Sun'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
     CullDistance=4000.000000
     Physics=PHYS_None
     LifeSpan=1.200000
     DrawScale=0.020000
     Skins(0)=Texture'tk_MarioMonsters.MarioMonsters.MM_Invis'
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
