class TestTelekInv extends Inventory;

var config int intDamagePerHit;
var config int intTargetRadius;
var config float fltAttackRate;
var int OwnerAbilityLevel;
var float DamagePerHit;
var float TargetRadius;
var Class<xEmitter> HitEmitterClass;

function PostBeginPlay()
{
	SetTimer(fltAttackRate, true);

	Super.PostBeginPlay();
}

function Timer()
{
    local Controller C, NextC;
    local int Targets,ADJDamage;
    local xEmitter HitEmitter;

	if(VSize(Instigator.Velocity) ~= 0)
	{
		return;
	}

	DamagePerHit = OwnerAbilityLevel * intDamagePerHit;
	TargetRadius = OwnerAbilityLevel * intTargetRadius;
    ADJDamage = DamagePerHit;

    C = Level.ControllerList;
    while (C != None)
    {
        // get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
        NextC = C.NextController;
        if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller)
                && VSize(C.Pawn.Location - Instigator.Location) < TargetRadius && FastTrace(C.Pawn.Location, Instigator.Location) )
        {
            if(DamagePerHit > C.Pawn.Health)
            {
                ADJDamage = Clamp(C.Pawn.Health-DamagePerHit, C.Pawn.Health - 1, DamagePerHit);
                if(ADJDamage <= 0)
                {
                    return;
                }
            }
            HitEmitter = spawn(HitEmitterClass,,, Instigator.Location, rotator(C.Pawn.Location - Instigator.Location));
            if (HitEmitter != None)
                HitEmitter.mSpawnVecA = C.Pawn.Location;

            C.Pawn.TakeDamage(ADJDamage, Instigator, C.Pawn.Location, vect(0,0,0), class'DamTypeTeleK');
            Targets++;
        }
        C = NextC;
    }
}

defaultproperties
{
    intDamagePerHit=10

    intTargetRadius=200

    fltAttackRate=1.00

    HitEmitterClass=Class'TestTeleEffect'

}