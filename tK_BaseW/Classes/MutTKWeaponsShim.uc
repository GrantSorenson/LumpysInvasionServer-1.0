class MutTKWeaponsShim extends Mutator;

var float OldTimeDilation;
var float OldResetCountdown;

static final function ShimDamageTypes()
{
    class'DamTypeAssaultBullet'.default.WeaponClass = class'tK_AssaultRifle';
    class'DamTypeAssaultGrenade'.default.WeaponClass = class'tK_AssaultRifle';
    class'DamTypeBioGlob'.default.WeaponClass = class'tK_BioRifle';
    class'DamTypeFlakChunk'.default.WeaponClass = class'tK_FlakCannon';
    class'DamTypeFlakShell'.default.WeaponClass = class'tK_FlakCannon';
    class'DamTypeIonBlast'.default.WeaponClass = class'tK_Painter';
    class'DamTypeLinkPlasma'.default.WeaponClass = class'tK_LinkGun';
    class'DamTypeLinkShaft'.default.WeaponClass = class'tK_LinkGun';
    class'DamTypeMinigunAlt'.default.WeaponClass = class'tK_Minigun';
    class'DamTypeMinigunBullet'.default.WeaponClass = class'tK_Minigun';
    class'DamTypeRedeemer'.default.WeaponClass = class'tK_Redeemer';
    class'DamTypeRocketHoming'.default.WeaponClass = class'tK_RocketLauncher';
    class'DamTypeRocket'.default.WeaponClass = class'tK_RocketLauncher';
    class'DamTypeShieldImpact'.default.WeaponClass = class'tK_ShieldGun';
    class'DamTypeShockBall'.default.WeaponClass = class'tK_ShockRifle';
    class'DamTypeShockBeam'.default.WeaponClass = class'tK_ShockRifle';
    class'DamTypeShockCombo'.default.WeaponClass = class'tK_ShockRifle';
    class'DamTypeSniperHeadShot'.default.WeaponClass = class'tK_SniperRifle';
    class'DamTypeSniperShot'.default.WeaponClass = class'tK_SniperRifle';
    class'DamTypeSuperShockBeam'.default.WeaponClass = class'tK_SuperShockRifle';
    class'DamTypeTelefrag'.default.WeaponClass = class'tK_Translauncher';
    class'DamTypeONSAVRiLRocket'.default.WeaponClass = class'tK_AVRiL';
    class'DamTypeONSGrenade'.default.WeaponClass = class'tK_GrenadeLauncher';
    class'DamTypeONSMine'.default.WeaponClass = class'tK_MineLayer';
    //target painter bombs use the redeemer damage type
    class'DamTypeClassicHeadshot'.default.WeaponClass = class'tK_ClassicSniperRifle';
    class'DamTypeClassicSniper'.default.WeaponClass = class'tK_ClassicSniperRifle';
}
static final function ResetDamageTypes()
{
    class'DamTypeAssaultBullet'.default.WeaponClass = class'AssaultRifle';
    class'DamTypeAssaultGrenade'.default.WeaponClass = class'AssaultRifle';
    class'DamTypeBioGlob'.default.WeaponClass = class'BioRifle';
    class'DamTypeFlakChunk'.default.WeaponClass = class'FlakCannon';
    class'DamTypeFlakShell'.default.WeaponClass = class'FlakCannon';
    class'DamTypeIonBlast'.default.WeaponClass = class'Painter';
    class'DamTypeLinkPlasma'.default.WeaponClass = class'LinkGun';
    class'DamTypeLinkShaft'.default.WeaponClass = class'LinkGun';
    class'DamTypeMinigunAlt'.default.WeaponClass = class'Minigun';
    class'DamTypeMinigunBullet'.default.WeaponClass = class'Minigun';
    class'DamTypeRedeemer'.default.WeaponClass = class'Redeemer';
    class'DamTypeRocketHoming'.default.WeaponClass = class'RocketLauncher';
    class'DamTypeRocket'.default.WeaponClass = class'RocketLauncher';
    class'DamTypeShieldImpact'.default.WeaponClass = class'ShieldGun';
    class'DamTypeShockBall'.default.WeaponClass = class'ShockRifle';
    class'DamTypeShockBeam'.default.WeaponClass = class'ShockRifle';
    class'DamTypeShockCombo'.default.WeaponClass = class'ShockRifle';
    class'DamTypeSniperHeadShot'.default.WeaponClass = class'SniperRifle';
    class'DamTypeSniperShot'.default.WeaponClass = class'SniperRifle';
    class'DamTypeSuperShockBeam'.default.WeaponClass = class'SuperShockRifle';
    class'DamTypeTelefrag'.default.WeaponClass = class'Translauncher';
    class'DamTypeONSAVRiLRocket'.default.WeaponClass = class'ONSAVRiL';
    class'DamTypeONSGrenade'.default.WeaponClass = class'ONSGrenadeLauncher';
    class'DamTypeONSMine'.default.WeaponClass = class'ONSMineLayer';
    //target painter bombs use the redeemer damage type
    class'DamTypeClassicHeadshot'.default.WeaponClass = class'ClassicSniperRifle';
    class'DamTypeClassicSniper'.default.WeaponClass = class'ClassicSniperRifle';
}

static final function class<Weapon> GetReplacementWeaponClass(class<Weapon> OriginalWeapon)
{
    switch(OriginalWeapon)
    {
        case class'ShieldGun':
            return class'tK_ShieldGun';
        case class'AssaultRifle':
            return class'tK_AssaultRifle';
        case class'BioRifle':
            return class'tK_BioRifle';
        case class'ShockRifle':
            return class'tK_ShockRifle';
        case class'LinkGun':
            return class'tK_LinkGun';
        case class'Minigun':
            return class'tK_Minigun';
        case class'FlakCannon':
            return class'tK_FlakCannon';
        case class'RocketLauncher':
            return class'tK_RocketLauncher';
        case class'SniperRifle':
            return class'tK_SniperRifle';
        case class'Painter':
            return class'tK_Painter';
        case class'Redeemer':
            return class'tK_Redeemer';
        case class'ClassicSniperRifle':
            return class'tK_ClassicSniperRifle';
        case class'ONSMineLayer':
            return class'tK_MineLayer';
        case class'ONSGrenadeLauncher':
            return class'tK_GrenadeLauncher';
        case class'ONSAVRiL':
            return class'tK_AVRiL';
        case class'ONSPainter':
            return class'tK_TargetPainter';
        case class'SuperShockRifle':
            return class'tK_SuperShockRifle';
        case class'ZoomSuperShockRifle':
            return class'tK_ZoomSuperShockRifle';
        default:
            return OriginalWeapon;
    }
}

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
    local int i;

    if(xWeaponBase(Other) != None)
        xWeaponBase(Other).WeaponType = static.GetReplacementWeaponClass(xWeaponBase(Other).WeaponType);
    else if(WeaponPickup(Other) != None)
        WeaponPickup(Other).InventoryType = static.GetReplacementWeaponClass(class<Weapon>(WeaponPickup(Other).InventoryType));
    else if(WeaponLocker(Other) != None)
    {
        for(i = 0; i < WeaponLocker(Other).Weapons.Length; i++)
            WeaponLocker(Other).Weapons[i].WeaponClass = static.GetReplacementWeaponClass(WeaponLocker(Other).Weapons[i].WeaponClass);
    }
    return true;
}

function PostBeginPlay()
{
    SetTimer(Level.TimeDilation, true);
}

simulated function Tick(float dt)
{
    local PlayerController PC;

    if(Level.NetMode != NM_Client)
    {
        // shim resetting translocator ammo on round resets in bombing run
        if(xBombingRun(Level.Game) != None)
        {
            if(OldTimeDilation != Level.TimeDilation)
                SetTimer(Level.TimeDilation, true);
        }
        else
            Disable('Tick');
        return;
    }

    PC = Level.GetLocalPlayerController();
    if(PC != None && PC.Player != None && PC.Player.InteractionMaster != None)
    {
        PC.Player.InteractionMaster.AddInteraction(string(class'MutTKWeaponsShim_Interaction'), PC.Player);
        Disable('Tick');
    }
}

function Timer()
{
    local Controller C;
    local Inventory Inv;

    if(OldResetCountdown == 1 && Level.Game.ResetCountdown == 0)
    {
        for(C = Level.ControllerList; C != None; C = C.NextController)
        {
            if(C.Pawn != None)
            {
                for(Inv = C.Pawn.Inventory; Inv != None; Inv = Inv.Inventory)
                {
                    if(tK_Translauncher(Inv) != None)
                        tK_Translauncher(Inv).GiveAmmo(0, None, false);
                }
            }
        }
    }
}

defaultproperties
{
     FriendlyName="TK Weapons Shim"
     Description="Compatibility shim for TK Weapons."
     bNetTemporary=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
