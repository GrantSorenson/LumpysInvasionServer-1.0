class LumpyDrone extends Actor;

//#EXEC TEXTURE IMPORT NAME=DroneTex FILE=Textures\DroneTex.dds MIPS=ON FLAGS=2
//#EXEC NEW StaticMesh FILE=Models\Drone.ase NAME=DroneMesh

#exec obj load file="Drones.u"
#exec obj load file="LumpysTextures.utx"

var float Speed;

var Pawn protPawn;
var int OrbitDist;

var ColoredTrail Trail;
var bool bTrailActive;
var DroneHealBeam healBeam;

var int healCounter;
var int HealDist;

var float curOsc;       // Z oscillation phase — randomized per drone, replicated bNetInitial
var float OrbitPhase;   // XY orbit starting angle — randomized per drone, replicated bNetInitial

var int CircleSpeed;
var int OscHeight;
var float OscInc;

var int shootCounter;
var int targetCounter;
var Pawn targetPawn;
var int TargetRadius;

var int HealPerSec, ShotDelay, TargetDelay, ProjDamage;

var DroneReplicationInfo dri;
var int MaxDrones;

var bool bActive;
var int orbitHeight;

var float ResetPawnDistance, ResetTime, LastResetCheckTime, LostTime;
var vector OrbitCenter; // smoothed orbit center — lags behind player for a "following" feel

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        protPawn, HealPerSec, ShotDelay, TargetDelay, ProjDamage,
        curOsc, OrbitPhase, shootCounter, targetCounter, orbitHeight;
    unreliable if (Role == ROLE_Authority)
        bActive, dri;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        curOsc        = FRand() * 6.28318;
        OrbitPhase    = FRand() * 6.28318;
        shootCounter  = FRand() * ShotDelay;
        targetCounter = FRand() * TargetDelay;
        orbitHeight   = FRand() * 95 - 40;
        LastResetCheckTime = Level.TimeSeconds;

        SetTimer(0.1, true);
    }

    bActive = true;

    if (Level.NetMode != NM_DedicatedServer && !bTrailActive)
    {
        Trail = Spawn(class'ColoredTrail', self,, Location, Rotation);
        Trail.SetSkin(0);
        Trail.SetBase(self);
        Trail.LifeSpan = 9999;
        bTrailActive = true;
    }
}

// Every frame: compute orbit position in world space and SetLocation directly.
// Owner.Location is frame-accurate on the client for the owning player (local prediction).
// No replication of position needed — both sides compute the same result from TimeSeconds.
simulated function Tick(float dt)
{
    local float angle, osc, dist;
    local vector offset;

    if (protPawn == None)
        protPawn = Pawn(Owner);
    if (protPawn == None)
        return;

    // Smoothly chase the player — OrbitCenter lags behind protPawn.Location.
    // This makes the drone feel like it's flying to keep up rather than rigidly attached.
    if (OrbitCenter == vect(0,0,0))
        OrbitCenter = protPawn.Location;
    OrbitCenter += (protPawn.Location - OrbitCenter) * FMin(dt * 4.0, 1.0);

    // Time-based angle — same formula on server and client, stays in sync automatically.
    angle = Level.TimeSeconds * (float(CircleSpeed) / (3.0 * float(OrbitDist))) + OrbitPhase;
    osc   = Level.TimeSeconds * OscInc + curOsc;

    offset.X = OrbitCenter.X + cos(angle) * OrbitDist;
    offset.Y = OrbitCenter.Y + sin(angle) * OrbitDist;
    offset.Z = OrbitCenter.Z + orbitHeight + 36 + cos(osc) * (OscHeight * 0.04);

    SetLocation(offset);

    // Match player's rotation.
    SetRotation(protPawn.Rotation);

    // Heal beam — spawned and tracked on client.
    if (Level.NetMode != NM_DedicatedServer)
    {
        dist = VSize(protPawn.Location - Location);
        if (dist < HealDist && healBeam == None && protPawn.Health < protPawn.HealthMax && protPawn.Health > 0)
        {
            healBeam = Spawn(class'DroneHealBeam', self,, Location, rotator(protPawn.Location - Location));
            if (healBeam != None)
                healBeam.SetBase(self);
        }
        if (healBeam != None)
        {
            if (dist > HealDist + 16 || protPawn.Health >= protPawn.HealthMax)
                healBeam.Destroy();
            else
            {
                healBeam.mSpawnVecA = protPawn.Location;
                healBeam.SetRotation(rotator(protPawn.Location + vect(0,0,48) - Location));
            }
        }
    }
}

// Server only — gameplay logic.
function Timer()
{
    local Pawn cTarget;
    local int protTeam;
    local float dist;
    local DroneProj dp;
    local vector dronePos;
    local float angle, osc;

    if (protPawn == None)
        protPawn = Pawn(Owner);

    if (protPawn == None || protPawn.Health <= 0)
    {
        Destroy();
        return;
    }

    // Compute the same orbit position the client is displaying.
    angle = Level.TimeSeconds * (float(CircleSpeed) / (3.0 * float(OrbitDist))) + OrbitPhase;
    osc   = Level.TimeSeconds * OscInc + curOsc;
    dronePos.X = protPawn.Location.X + cos(angle) * OrbitDist;
    dronePos.Y = protPawn.Location.Y + sin(angle) * OrbitDist;
    dronePos.Z = protPawn.Location.Z + orbitHeight + 36 + cos(osc) * (OscHeight * 0.04);

    dist = VSize(protPawn.Location - dronePos);

    // Heal beam (listen server only).
    if (dist < HealDist && Level.NetMode != NM_DedicatedServer)
    {
        if (healBeam == None && protPawn.Health < protPawn.HealthMax && protPawn.Health > 0 && targetPawn == None)
        {
            healBeam = Spawn(class'DroneHealBeam', self,, dronePos, rotator(protPawn.Location - dronePos));
            if (healBeam != None)
                healBeam.SetBase(self);
        }
    }
    if (healBeam != None && (dist > HealDist + 16 || protPawn.Health >= protPawn.HealthMax))
        healBeam.Destroy();

    healCounter++;
    if (healCounter == 2)
    {
        if (dist < HealDist && protPawn.Health > 0 && targetPawn == None)
            protPawn.GiveHealth(HealPerSec / 5, protPawn.HealthMax);
        healCounter = 0;
    }

    // Targeting.
    if (targetCounter >= TargetDelay && protPawn.Health > 0)
    {
        protTeam = protPawn.GetTeamNum();
        targetPawn = None;
        foreach VisibleCollidingActors(class'Pawn', cTarget, TargetRadius)
        {
            if (cTarget != protPawn && (!Level.Game.bTeamGame || cTarget.GetTeamNum() != protTeam) && cTarget.Health > 0)
            {
                if (targetPawn == None)
                    targetPawn = cTarget;
                else if (VSize(targetPawn.Location - protPawn.Location) > VSize(cTarget.Location - protPawn.Location))
                    targetPawn = cTarget;
            }
        }
        targetCounter = 0;
    }
    targetCounter++;

    // Shooting.
    if (shootCounter >= ShotDelay)
    {
        if (targetPawn != None)
        {
            dp = Spawn(class'DroneProj', protPawn,, dronePos + Normal(targetPawn.Location - dronePos) * 32, rotator(targetPawn.Location - dronePos));
            if (dp != None)
            {
                dp.Instigator = protPawn;
                dp.Damage = ProjDamage;
                PlaySound(Sound'WeaponSounds.LinkGun.BLinkedFire');
                if (healBeam != None)
                    healBeam.Destroy();
            }
        }
        shootCounter = 0;
    }
    shootCounter++;
}

simulated singular function Touch(Actor Other)
{
    if (Projectile(Other) != None && protPawn != None)
    {
        if (Other.Instigator != protPawn)
            Projectile(Other).Explode(Other.Location, -Other.Velocity);
        Log("Drone Killed", 'LumpysInvasion');
    }
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
}

simulated function DroneReplicationInfo getDroneInfo(PlayerReplicationInfo PlayRepInf)
{
    local DroneReplicationInfo dronerepinf;
    foreach DynamicActors(class'DroneReplicationInfo', dronerepinf)
    {
        if (dronerepinf.PRI == PlayRepInf)
            return dronerepinf;
    }
    return None;
}

simulated function Destroyed()
{
    if (Trail != None)
        Trail.Destroy();
    bTrailActive = false;
    if (healBeam != None)
        healBeam.Destroy();
    if (dri != None)
        dri.Destroy();
}

defaultproperties
{
    Speed=600.00
    OrbitDist=64
    HealDist=400
    CircleSpeed=420
    OscHeight=240
    OscInc=1.50
    TargetRadius=2000
    HealPerSec=10
    ShotDelay=6
    TargetDelay=15
    ProjDamage=9
    MaxDrones=3
    ResetPawnDistance=1000.00
    ResetTime=3.00
    bActive=True
    bTrailActive=false
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DroneMesh'
    bAlwaysRelevant=True
    bReplicateInstigator=True
    bReplicateMovement=False
    Physics=PHYS_None
    RemoteRole=ROLE_SimulatedProxy
    Role=ROLE_Authority
    NetUpdateFrequency=10
    AmbientSound=Sound'WeaponSounds.LinkGun.LinkGunProjectile'
    LifeSpan=9999.00
    DrawScale=2.50
    Skins[0]=Texture'DroneTex'
    bUnlit=True
    bDisturbFluidSurface=True
    SoundVolume=255
    SoundRadius=50.00
    CollisionRadius=20.00
    CollisionHeight=20.00
    bCollideActors=True
    bCollideWorld=False
    bUseCylinderCollision=True
    bBounce=False
    bFixedRotationDir=False
    bTrailerSameRotation=False
    bNetNotify=True
}
