class MedicDrone extends LumpyDrone;

#exec obj load file="LumpysTextures.utx"

simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer && !bTrailActive)
    {
        Trail = Spawn(class'ColoredTrail', self,, Location, Rotation);
        Trail.SetSkin(1);
        Trail.SetBase(self);
        Trail.LifeSpan = 9999;
        bTrailActive = true;
    }

    Super.PostBeginPlay();
}

simulated function Tick(float dt)
{
    Super.Tick(dt);
    if (healBeam != None)
        healBeam.Skins[0] = FinalBlend'XEffectMat.Link.LinkBeamBlueFB';
}

// Medic drone: heals only, no targeting or shooting.
function Timer()
{
    local float dist;

    if (protPawn == None)
        protPawn = Pawn(Owner);

    if (protPawn == None || protPawn.Health <= 0)
    {
        Destroy();
        return;
    }

    dist = VSize(protPawn.Location - Location);

    if (dist < HealDist && Level.NetMode != NM_DedicatedServer)
    {
        if (healBeam == None && protPawn.Health < protPawn.HealthMax && protPawn.Health > 0)
        {
            healBeam = Spawn(class'DroneHealBeam', self,, Location, rotator(protPawn.Location - Location));
            if (healBeam != None)
                healBeam.SetBase(self);
        }
    }
    if (healBeam != None && (dist > HealDist + 16 || protPawn.Health >= protPawn.HealthMax))
        healBeam.Destroy();

    healCounter++;
    if (healCounter == 2)
    {
        if (dist < HealDist && protPawn.Health > 0)
            protPawn.GiveHealth(HealPerSec / 5, protPawn.HealthMax);
        healCounter = 0;
    }
}

defaultproperties
{
    Skins[0]=Texture'DroneTexBlue'
}
