//RPGWeapons are wrappers for normal weapons which pass all functions to the weapon it controls,
//possibly modifying things first. This allows for weapon modifiers in a way that's
//compatible with almost any weapon, as long as no part of that weapon tries to cast Pawn.Weapon (which will always fail)
class RPGWeapon extends Weapon
	DependsOn(RPGStatsInv)
	config(UT2004RPG)
	HideDropDown
	CacheExempt;

var Weapon ModifiedWeapon;
var Material ModifierOverlay;
var int Modifier, MinModifier, MaxModifier; // +1, +2, -1, -2, etc
var float AIRatingBonus;
var localized string PrefixPos, PostfixPos, PrefixNeg, PostfixNeg;
var bool bCanHaveZeroModifier;
var bool bIdentified;
var int References; //number of UT2004RPG actors referencing this actor
var int SniperZoomMode; //sniper zoom hack
var RPGStatsInv HolderStatsInv;
var int LastAmmoChargePrimary; //used to sync up AmmoCharge between multiple RPGWeapons modifying the same class of weapon

//see GiveTo() for the miracle that goes with this
struct ChaosAmmoTypeStructClone
{
	var class<Ammunition> AmmoClass;
	var class<WeaponAttachment> Attachment;
	var class<Pickup> Pickup;
	var bool bSuperAmmoLimit;
};
var array<ChaosAmmoTypeStructClone> ChaosAmmoTypes;

replication
{
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		ModifiedWeapon, Modifier, bIdentified;
	reliable if (Role < ROLE_Authority)
		ChangeAmmo, ChaosWeaponOption, ReloadMeNow, FinishReloading, ServerForceUpdate;
}

//RPG functions

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	return true;
}

function Generate(RPGWeapon ForcedWeapon)
{
	local int Count;

	if (ForcedWeapon != None)
		Modifier = ForcedWeapon.Modifier;
	else if (MaxModifier != 0 || MinModifier != 0)
	{
		do
		{
			Modifier = Rand(MaxModifier+1-MinModifier) + MinModifier;
			Count++;
		} until (Modifier != 0 || bCanHaveZeroModifier || Count > 1000)
	}
}

function SetModifiedWeapon(Weapon w, bool bIdentify)
{
	if (w == None)
	{
		Destroy();
		return;
	}
	ModifiedWeapon = w;
	SetWeaponInfo();
	if (bIdentify)
	{
		Instigator = None; //don't want to send an identify message to anyone here
		Identify();
	}
}

simulated function SetWeaponInfo()
{
	local int x;

	ModifiedWeapon.Instigator = Instigator;
	ModifiedWeapon.SetOwner(Owner);
	ItemName = ModifiedWeapon.ItemName;
	AIRating = ModifiedWeapon.AIRating;
	InventoryGroup = ModifiedWeapon.InventoryGroup;
	GroupOffset = ModifiedWeapon.GroupOffset;
	IconMaterial = ModifiedWeapon.IconMaterial;
	IconCoords = ModifiedWeapon.IconCoords;
	Priority = ModifiedWeapon.Priority;
	PlayerViewOffset = ModifiedWeapon.PlayerViewOffset;
	DisplayFOV = ModifiedWeapon.DisplayFOV;
	EffectOffset = ModifiedWeapon.EffectOffset;
	bMatchWeapons = ModifiedWeapon.bMatchWeapons;
	bShowChargingBar = ModifiedWeapon.bShowChargingBar;
	bCanThrow = ModifiedWeapon.bCanThrow;
	ExchangeFireModes = ModifiedWeapon.ExchangeFireModes;
	bNoAmmoInstances = ModifiedWeapon.bNoAmmoInstances;
	HudColor = ModifiedWeapon.HudColor;
	CustomCrossHairColor = ModifiedWeapon.CustomCrossHairColor;
	CustomCrossHairScale = ModifiedWeapon.CustomCrossHairScale;
	CustomCrossHairTextureName = ModifiedWeapon.CustomCrossHairTextureName;
	SniperZoomMode = -1;
	for (x = 0; x < NUM_FIRE_MODES; x++)
	{
		FireMode[x] = ModifiedWeapon.FireMode[x];
		Ammo[x] = ModifiedWeapon.Ammo[x];
		AmmoClass[x] = ModifiedWeapon.AmmoClass[x];
		//someone explain to me why people had to create their own versions of the dummy WeaponFire for zooming
		if ( FireMode[x].IsA('SniperZoom') || FireMode[x].IsA('PainterZoom') || FireMode[x].IsA('CUTSRZoom')
		     || FireMode[x].IsA('HeliosZoom') || FireMode[x].IsA('LongrifleZoom') || FireMode[x].IsA('PICZoom') )
			SniperZoomMode = x;
	}
}

function Identify()
{
	if (Modifier == 0 && !bCanHaveZeroModifier)
		return;

	bIdentified = true;
	ConstructItemName();
	if (Instigator != None && PlayerController(Instigator.Controller) != None)
		PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'IdentifyMessage', 0,,, self);
	if (ModifiedWeapon.OverlayMaterial == None)
		SetOverlayMaterial(ModifierOverlay, -1, true);
}

simulated function ConstructItemName()
{
	if (Modifier > 0)
		ItemName = PrefixPos$ModifiedWeapon.ItemName$PostfixPos@"+"$Modifier;
	else if (Modifier < 0)
		ItemName = PrefixNeg$ModifiedWeapon.ItemName$PostfixNeg@Modifier;
	else
		ItemName = PrefixPos$ModifiedWeapon.ItemName$PostfixPos;
}

//return true to allow player to have w
function bool AllowRPGWeapon(RPGWeapon w)
{
	if (Class == w.Class && ModifiedWeapon.Class == w.ModifiedWeapon.Class && Modifier >= w.Modifier)
		return false;

	return true;
}

//adjust damage to the enemies of the wielder of this weapon
function AdjustTargetDamage(out int Damage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType);

//FIXME compatibility hack
function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);
}

//This is used to prevent the RPGWeapon from getting destroyed until nothing needs it
function RemoveReference()
{
	References--;
	if (References <= 0)
		Destroy();
}

//Weapon functions

simulated function float ChargeBar()
{
	return ModifiedWeapon.ChargeBar();
}

simulated function GetAmmoCount(out float MaxAmmoPrimary, out float CurAmmoPrimary)
{
	ModifiedWeapon.GetAmmoCount(MaxAmmoPrimary, CurAmmoPrimary);
	if (AmmoClass[0] != None)
		MaxAmmoPrimary = MaxAmmo(0);
}

simulated function DrawWeaponInfo(Canvas C)
{
	ModifiedWeapon.DrawWeaponInfo(C);
}

simulated function NewDrawWeaponInfo(Canvas C, float YPos)
{
	ModifiedWeapon.NewDrawWeaponInfo(C, YPos);
}

function OwnerEvent(name EventName)
{
	if (EventName == 'ChangedWeapon' && Instigator.Weapon == self && ModifierOverlay != None && bIdentified)
	{
		ModifiedWeapon.SetOverlayMaterial(ModifierOverlay, 1000000, false);
		if (WeaponAttachment(ThirdPersonActor) != None)
			ThirdPersonActor.SetOverlayMaterial(ModifierOverlay, 1000000, false);
	}

	Super.OwnerEvent(EventName);
}

function float RangedAttackTime()
{
	return ModifiedWeapon.RangedAttackTime();
}

function bool RecommendRangedAttack()
{
	return ModifiedWeapon.RecommendRangedAttack();
}

function bool RecommendLongRangedAttack()
{
	return ModifiedWeapon.RecommendLongRangedAttack();
}

function bool FocusOnLeader(bool bLeaderFiring)
{
	return ModifiedWeapon.FocusOnLeader(bLeaderFiring);
}

function FireHack(byte Mode)
{
	ModifiedWeapon.FireHack(Mode);
}

function bool SplashDamage()
{
	return ModifiedWeapon.SplashDamage();
}

function bool RecommendSplashDamage()
{
	return ModifiedWeapon.RecommendSplashDamage();
}

function float GetDamageRadius()
{
	return ModifiedWeapon.GetDamageRadius();
}

function float RefireRate()
{
	return ModifiedWeapon.RefireRate();
}

function bool FireOnRelease()
{
	return ModifiedWeapon.FireOnRelease();
}

simulated function Loaded()
{
	ModifiedWeapon.Loaded();
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	Canvas.SetDrawColor(255,255,255);

	Canvas.DrawText("RPGWEAPON");
	YPos += YL;
	Canvas.SetPos(4,YPos);

	Canvas.DrawText("ModifiedWeapon: "$ModifiedWeapon);
	YPos += YL;
	Canvas.SetPos(4,YPos);

	ModifiedWeapon.DisplayDebug(Canvas, YL, YPos);
}

simulated function Weapon RecommendWeapon( out float rating )
{
    local Weapon Recommended;
    local float oldRating;

    if ( (Instigator == None) || (Instigator.Controller == None) )
        rating = -2;
    else
        rating = RateSelf() + Instigator.Controller.WeaponPreference(ModifiedWeapon);

    if ( inventory != None )
    {
        Recommended = inventory.RecommendWeapon(oldRating);
        if ( (Recommended != None) && (oldRating > rating) )
        {
            rating = oldRating;
            return Recommended;
        }
    }
    return self;
}

function SetAITarget(Actor T)
{
	ModifiedWeapon.SetAITarget(T);
}

function byte BestMode()
{
	return ModifiedWeapon.BestMode();
}

function bool BotFire(bool bFinished, optional name FiringMode)
{
	local bool bResult;

	bResult = ModifiedWeapon.BotFire(bFinished, FiringMode);
	BotMode = ModifiedWeapon.BotMode;
	return bResult;
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
	return ModifiedWeapon.GetFireStart(X, Y, Z);
}

simulated function float AmmoStatus(optional int Mode)
{
	if (bNoAmmoInstances)
	{
		if (AmmoClass[Mode] == None)
			return 0;
		if (AmmoClass[0] == AmmoClass[mode])
			mode = 0;

		return float(ModifiedWeapon.AmmoCharge[Mode])/float(MaxAmmo(Mode));
	}
	if (Ammo[Mode] == None)
		return 0.0;
	else
		return float(Ammo[Mode].AmmoAmount) / float(Ammo[Mode].MaxAmmo);
}

simulated function float RateSelf()
{
	if ( !HasAmmo() )
	        CurrentRating = -2;
	else if ( Instigator.Controller == None )
		return 0;
	else
		CurrentRating = Instigator.Controller.RateWeapon(ModifiedWeapon);
	return CurrentRating;
}

function float GetAIRating()
{
	if (!bIdentified)
		return ModifiedWeapon.GetAIRating();
	else if (MaxModifier == 0)
		return ModifiedWeapon.GetAIRating() + AIRatingBonus;
	else
		return ModifiedWeapon.GetAIRating() + AIRatingBonus * Modifier;
}

function float SuggestAttackStyle()
{
	return ModifiedWeapon.SuggestAttackStyle();
}

function float SuggestDefenseStyle()
{
	return ModifiedWeapon.SuggestDefenseStyle();
}

function bool SplashJump()
{
	return ModifiedWeapon.SplashJump();
}

function bool CanAttack(Actor Other)
{
	return ModifiedWeapon.CanAttack(Other);
}

simulated function Destroyed()
{
	DestroyModifiedWeapon();

	Super.Destroyed();
}

simulated function DestroyModifiedWeapon()
{
	local int i;

	//after ModifiedWeapon gets destroyed, the FireMode array will become bogus pointers since they're not actors
	//so have to manually set to None
	for (i = 0; i < NUM_FIRE_MODES; i++)
		FireMode[i] = None;

	if (ModifiedWeapon != None)
		ModifiedWeapon.Destroy();
}

simulated function Reselect()
{
	ModifiedWeapon.Reselect();
}

simulated function bool WeaponCentered()
{
	return ModifiedWeapon.WeaponCentered();
}

simulated event RenderOverlays(Canvas Canvas)
{

	ModifiedWeapon.RenderOverlays(Canvas);
}

simulated function PreDrawFPWeapon()
{
	ModifiedWeapon.PreDrawFPWeapon();
}

simulated function SetHand(float InHand)
{
	Hand = InHand;
	ModifiedWeapon.SetHand(Hand);
}

simulated function GetViewAxes(out vector xaxis, out vector yaxis, out vector zaxis)
{
	ModifiedWeapon.GetViewAxes(xaxis, yaxis, zaxis);
}

simulated function vector CenteredEffectStart()
{
	return ModifiedWeapon.CenteredEffectStart();
}

simulated function vector GetEffectStart()
{
	return ModifiedWeapon.GetEffectStart();
}

simulated function IncrementFlashCount(int Mode)
{
	ModifiedWeapon.IncrementFlashCount(Mode);
}

simulated function ZeroFlashCount(int Mode)
{
	ModifiedWeapon.ZeroFlashCount(Mode);
}

function HolderDied()
{
	ModifiedWeapon.HolderDied();

	// set the controller's last pawn weapon to modified weapon so stats work properly
	if (Instigator.Controller != None)
		Instigator.Controller.LastPawnWeapon = ModifiedWeapon.Class;
}

simulated function bool CanThrow()
{
	if (Modifier < 0)
		return false; //can't throw cursed weapons

	return ModifiedWeapon.CanThrow();
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local int m;
    local weapon w;
    local bool bPossiblySwitch, bJustSpawned;
    local Inventory Inv;

    Instigator = Other;
    ModifiedWeapon.Instigator = Other;
    for (Inv = Instigator.Inventory; true; Inv = Inv.Inventory)
    {
    	if (Inv.Class == ModifiedWeapon.Class || (RPGWeapon(Inv) != None && !RPGWeapon(Inv).AllowRPGWeapon(Self)))
    	{
		W = Weapon(Inv);
		break;
    	}
    	m++;
    	if (m > 1000)
    		break;
    	if (Inv.Inventory == None) //hack to keep Inv at last item in Instigator's inventory
    		break;
    }

    if ( W == None )
    {
	//hack - manually add to Instigator's inventory because pawn won't usually allow duplicates
	Inv.Inventory = self;
	Inventory = None;
	SetOwner(Instigator);
	if (Instigator.Controller != None)
		Instigator.Controller.NotifyAddInventory(self);

	bJustSpawned = true;
        ModifiedWeapon.SetOwner(Owner);
        bPossiblySwitch = true;
        W = self;
    }
    else if ( !W.HasAmmo() )
	    bPossiblySwitch = true;

    if ( Pickup == None )
        bPossiblySwitch = true;

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if ( ModifiedWeapon.FireMode[m] != None )
        {
            ModifiedWeapon.FireMode[m].Instigator = Instigator;
            W.GiveAmmo(m,WeaponPickup(Pickup),bJustSpawned);
        }
    }

	if ( (Instigator.Weapon != None) && Instigator.Weapon.IsFiring() )
		bPossiblySwitch = false;

	if ( Instigator.Weapon != W )
		W.ClientWeaponSet(bPossiblySwitch);

    if (Instigator.Controller == Level.GetLocalPlayerController()) //can only do this on listen/standalone
    {
       	if (bIdentified)
		PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'IdentifyMessage', 1,,, self);
	else if (ModifiedWeapon.PickupClass != None)
	    	PlayerController(Instigator.Controller).ReceiveLocalizedMessage(ModifiedWeapon.PickupClass.default.MessageClass, 0,,,ModifiedWeapon.PickupClass);
    }

	SetHolderStatsInv();

    if ( !bJustSpawned )
    {
        for (m = 0; m < NUM_FIRE_MODES; m++)
        {
            Ammo[m] = None;
            ModifiedWeapon.Ammo[m] = None;
        }
	Destroy();
    }
    else
    {
    	//Hack for ChaosUT: spawn ChaosWeapon's ammo and make sure it sets up its firemode for the type of chaos ammo owner has
    	if (ModifiedWeapon.IsA('ChaosWeapon'))
    	{
    		ModifiedWeapon.SetPropertyText("OldCount", "-1");
    		ModifiedWeapon.Tick(0.f);
    		if (!ModifiedWeapon.bNoAmmoInstances)
    		{
    			//add initial ammo, if we haven't already via the GiveAmmo() call above
    			if (ModifiedWeapon.FireMode[0].default.AmmoClass == None)
    			{
	    			if (ModifiedWeapon.Ammo[0] == None)
	    			{
	    				ModifiedWeapon.Ammo[0] = spawn(ModifiedWeapon.AmmoClass[0]);
	    				ModifiedWeapon.Ammo[0].GiveTo(Other);
	    			}
	    			if (WeaponPickup(Pickup) != None && WeaponPickup(Pickup).AmmoAmount[0] > 0)
					ModifiedWeapon.Ammo[0].AddAmmo(WeaponPickup(Pickup).AmmoAmount[0]);
			    	else
					ModifiedWeapon.Ammo[0].AddAmmo(ModifiedWeapon.Ammo[0].InitialAmount);
			}

	    		//Spawn empty ammo for the other types, if necessary
	    		if (!Level.Game.IsA('ChaosDuel') || int(Level.Game.GetPropertyText("WeaponOption")) != 3)
	    		{
		    		//fill our clone ammo array with a copy of the contents from the weapon's array
		    		//can you believe this actually works?!
		    		//I've written a lot of hacks... it's part of being a mod author
				//But this... wow. Just wow.
		    		SetPropertyText("ChaosAmmoTypes", ModifiedWeapon.GetPropertyText("AmmoType"));

		    		for (m = 0; m < ChaosAmmoTypes.length; m++)
		    		{
		    			Inv = Instigator.FindInventoryType(ChaosAmmoTypes[m].AmmoClass);
		    			if (Inv == None)
		    			{
		    				Inv = spawn(ChaosAmmoTypes[m].AmmoClass);
		    				Inv.GiveTo(Instigator);
		    			}
		    		}
		    	}
		}
    	}

	for (m = 0; m < NUM_FIRE_MODES; m++)
		Ammo[m] = ModifiedWeapon.Ammo[m];
    }
}

function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
	local Inventory Inv;
	local RPGWeapon W;

	ModifiedWeapon.GiveAmmo(m, WP, bJustSpawned);
	if (bNoAmmoInstances && FireMode[m].AmmoClass != None && (m == 0 || FireMode[m].AmmoClass != FireMode[0].AmmoClass))
	{
		if (bJustSpawned)
		{
			for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
			{
				W = RPGWeapon(Inv);
				if (W != None && W != self && W.bNoAmmoInstances && W.ModifiedWeapon.Class == ModifiedWeapon.Class)
				{
					W.AddAmmo(ModifiedWeapon.AmmoCharge[m], m);
					W.SyncUpAmmoCharges();
					break;
				}
			}
		}
		else
			SyncUpAmmoCharges();
	}
}

simulated function SetHolderStatsInv()
{
	local Inventory Inv;

	for (Inv = Instigator.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		HolderStatsInv = RPGStatsInv(Inv);
		if (HolderStatsInv != None)
			return;
	}

	//fallback
	HolderStatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
	if (HolderStatsInv == None)
		Warn("Couldn't find RPGStatsInv for "$Instigator.GetHumanReadableName());
}

simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    local int Mode;

    Instigator = Pawn(Owner);

    bPendingSwitch = bPossiblySwitch;

    if( Instigator == None || ModifiedWeapon == None )
    {
        GotoState('PendingClientWeaponSet');
        return;
    }

    SetWeaponInfo();
    SetHolderStatsInv();

    for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
    {
        if( ModifiedWeapon.FireModeClass[Mode] != None )
        {
            if (FireMode[Mode] == None || FireMode[Mode].AmmoClass != None && !bNoAmmoInstances && Ammo[Mode] == None && FireMode[Mode].AmmoPerFire > 0)
            {
                GotoState('PendingClientWeaponSet');
                return;
            }
        }

        FireMode[Mode].Instigator = Instigator;
        FireMode[Mode].Level = Level;
    }

    ClientState = WS_Hidden;
    ModifiedWeapon.ClientState = ClientState;
    GotoState('Hidden');

    if( Level.NetMode == NM_DedicatedServer || !Instigator.IsHumanControlled() )
        return;

    if( Instigator.Weapon == self || Instigator.PendingWeapon == self ) // this weapon was switched to while waiting for replication, switch to it now
    {
        if (Instigator.PendingWeapon != None)
            Instigator.ChangedWeapon();
        else
            BringUp();
        return;
    }

    if( Instigator.PendingWeapon != None && Instigator.PendingWeapon.bForceSwitch )
        return;

    if( Instigator.Weapon == None )
    {
        Instigator.PendingWeapon = self;
        Instigator.ChangedWeapon();
    }
    else if ( bPossiblySwitch )
    {
		if ( PlayerController(Instigator.Controller) != None && PlayerController(Instigator.Controller).bNeverSwitchOnPickup )
			return;
        if ( Instigator.PendingWeapon != None )
        {
            if ( RateSelf() > Instigator.PendingWeapon.RateSelf() )
            {
                Instigator.PendingWeapon = self;
                Instigator.Weapon.PutDown();
            }
        }
        else if ( RateSelf() > Instigator.Weapon.RateSelf() )
        {
            Instigator.PendingWeapon = self;
            Instigator.Weapon.PutDown();
        }
    }
}

/*simulated function BringUp(optional Weapon PrevWeapon)
{
   local int Mode;

    if (ClientState == WS_Hidden)
    {
        PlayOwnedSound(ModifiedWeapon.SelectSound, SLOT_Interact,,,,, false);
		ClientPlayForceFeedback(SelectForce);  // jdf

        if (Instigator.IsLocallyControlled())
        {
            if (ModifiedWeapon.HasAnim(ModifiedWeapon.SelectAnim))
                ModifiedWeapon.PlayAnim(ModifiedWeapon.SelectAnim, ModifiedWeapon.SelectAnimRate, 0.0);
        }

        ClientState = WS_BringUp;
        ModifiedWeapon.ClientState = ClientState;
        SetTimer(WeaponSwitchDelay, false);
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		ModifiedWeapon.FireMode[Mode].bIsFiring = false;
		ModifiedWeapon.FireMode[Mode].HoldTime = 0.0;
		ModifiedWeapon.FireMode[Mode].bServerDelayStartFire = false;
		ModifiedWeapon.FireMode[Mode].bServerDelayStopFire = false;
		ModifiedWeapon.FireMode[Mode].bInstantStop = false;
	}
	   if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else
		OldWeapon = None;

}

simulated function bool PutDown()
{
    local int Mode;

    if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
    {
        if (!Instigator.PendingWeapon.bForceSwitch)
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                if (ModifiedWeapon.FireMode[Mode].bFireOnRelease && ModifiedWeapon.FireMode[Mode].bIsFiring)
                    return false;
            }
        }

        if (Instigator.IsLocallyControlled())
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                if (ModifiedWeapon.FireMode[Mode].bIsFiring)
                    ClientStopFire(Mode);
            }

            if (ClientState != WS_BringUp && ModifiedWeapon.HasAnim(ModifiedWeapon.PutDownAnim))
                ModifiedWeapon.PlayAnim(ModifiedWeapon.PutDownAnim, ModifiedWeapon.PutDownAnimRate, 0.0);
        }
        ClientState = WS_PutDown;
        ModifiedWeapon.ClientState = ClientState;

        SetTimer(WeaponSwitchDelay, false);
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
    {
		ModifiedWeapon.FireMode[Mode].bServerDelayStartFire = false;
		ModifiedWeapon.FireMode[Mode].bServerDelayStopFire = false;
    }
    Instigator.AmbientSound = None;
    OldWeapon = None;
    return true; // return false if preventing weapon switch
}*/

simulated function BringUp(optional Weapon PrevWeapon)
{
	ModifiedWeapon.BringUp(PrevWeapon);
	if (ModifiedWeapon.TimerRate > 0)
	{
		SetTimer(ModifiedWeapon.TimerRate, false);
		ModifiedWeapon.SetTimer(0, false);
	}
	ClientState = ModifiedWeapon.ClientState;
}

simulated function bool PutDown()
{
	local bool bResult;

	bResult = ModifiedWeapon.PutDown();
	if (ModifiedWeapon.TimerRate > 0)
	{
		SetTimer(ModifiedWeapon.TimerRate, false);
		ModifiedWeapon.SetTimer(0, false);
	}
	ClientState = ModifiedWeapon.ClientState;
	return bResult;
}

simulated function Fire(float F)
{
	ModifiedWeapon.Fire(F);
}

simulated function AltFire(float F)
{
	ModifiedWeapon.AltFire(F);
}

simulated event WeaponTick(float dt)
{
	local int x;

	//Failsafe to prevent losing sync with ModifiedWeapon
	if (AmmoClass[0] != ModifiedWeapon.AmmoClass[0])
	{
		for (x = 0; x < NUM_FIRE_MODES; x++)
		{
			FireMode[x] = ModifiedWeapon.FireMode[x];
			Ammo[x] = ModifiedWeapon.Ammo[x];
			AmmoClass[x] = ModifiedWeapon.AmmoClass[x];
		}
		ThirdPersonActor = ModifiedWeapon.ThirdPersonActor;
	}

	//sync up ammocharge with other RPGWeapons player has that are modifying the same class of weapon
	if (Role == ROLE_Authority && bNoAmmoInstances && LastAmmoChargePrimary != ModifiedWeapon.AmmoCharge[0])
	{
		SyncUpAmmoCharges();

		//isn't it ironic that my code in Weapon.uc for the latest patch that prevents erroneous switching to
		//best weapon screwed my own mod?
		//so now I need this hack to work around it
		if (!HasAmmo())
		{
			if (Instigator.IsLocallyControlled())
			{
				OutOfAmmo();
			}
			else
			{
				//force net update because client checks ammo in PostNetReceive()
				bClientTrigger = !bClientTrigger;
			}
		}
	}

	//Rocket launcher homing hack
	if (ModifiedWeapon.IsA('RocketLauncher'))
	{
		Instigator.Weapon = ModifiedWeapon;
		ModifiedWeapon.Tick(dt);
		Instigator.Weapon = self;
	}

	ModifiedWeapon.WeaponTick(dt);
}

function SyncUpAmmoCharges()
{
	local Inventory Inv;
	local RPGWeapon W;

	LastAmmoChargePrimary = ModifiedWeapon.AmmoCharge[0];

	for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		W = RPGWeapon(Inv);
		if (W != None && W != self && W.bNoAmmoInstances && W.ModifiedWeapon != None && W.ModifiedWeapon.Class == ModifiedWeapon.Class)
		{
			W.ModifiedWeapon.AmmoCharge[0] = ModifiedWeapon.AmmoCharge[0];
			W.ModifiedWeapon.AmmoCharge[1] = ModifiedWeapon.AmmoCharge[1];
			W.LastAmmoChargePrimary = LastAmmoChargePrimary;
			W.ModifiedWeapon.NetUpdateTime = Level.TimeSeconds - 1;
		}
	}
}

simulated function OutOfAmmo()
{
	local int i;

	ModifiedWeapon.OutOfAmmo();

	//weapons with many ammo types, like ChaosUT weapons, might have switched firemodes/ammotypes here
	for (i = 0; i < NUM_FIRE_MODES; i++)
	{
		FireMode[i] = ModifiedWeapon.FireMode[i];
		Ammo[i] = ModifiedWeapon.Ammo[i];
		AmmoClass[i] = ModifiedWeapon.AmmoClass[i];
	}
	ThirdPersonActor = ModifiedWeapon.ThirdPersonActor;
}

simulated function ClientStartFire(int Mode)
{
	//HACK - sniper zoom
	if (Mode == SniperZoomMode)
	{
		FireMode[mode].bIsFiring = true;
		if( Instigator.Controller.IsA( 'PlayerController' ) )
			PlayerController(Instigator.Controller).ToggleZoom();
		return;
	}
	else if (RocketLauncher(ModifiedWeapon) != None) //HACK - rocket launcher spread
	{
		if ( Mode == 1 )
		{
			RocketLauncher(ModifiedWeapon).bTightSpread = false;
		}
		else if ( FireMode[1].bIsFiring || (FireMode[1].NextFireTime > Level.TimeSeconds) )
		{
			if ( (FireMode[1].Load > 0) && !RocketLauncher(ModifiedWeapon).bTightSpread )
			{
				RocketLauncher(ModifiedWeapon).bTightSpread = true;
				RocketLauncher(ModifiedWeapon).ServerSetTightSpread();
			}
			return;
		}
	}

	Super.ClientStartFire(Mode);
}

simulated function bool StartFire(int Mode)
{
	return ModifiedWeapon.StartFire(Mode);
}

simulated event ClientStopFire(int Mode)
{
	ModifiedWeapon.ClientStopFire(Mode);
}

simulated function bool ReadyToFire(int Mode)
{
	return ModifiedWeapon.ReadyToFire(Mode);
}

simulated function Timer()
{
	local int Mode;

	if (ModifiedWeapon == None)
		return;

	ModifiedWeapon.Timer();

	// if the ModifiedWeapon thinks it should be hidden, verify that a weapon change actually occurred
	// (it would have checked Instigator.Weapon != self which always fails)
	if (ModifiedWeapon.ClientState == WS_Hidden && Instigator.Weapon == self)
	{
		// we didn't actually switch, so reset the ModifiedWeapon's state
		ModifiedWeapon.ClientState = WS_ReadyToFire;
		for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
		{
			FireMode[Mode].InitEffects();
		}
		PlayIdle();
	}

	ClientState = ModifiedWeapon.ClientState;
	if (ModifiedWeapon.TimerRate > 0)
	{
		SetTimer(ModifiedWeapon.TimerRate, false);
		ModifiedWeapon.SetTimer(0, false);
	}

/*    if (ClientState == WS_BringUp)
    {
	for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
	       ModifiedWeapon.FireMode[Mode].InitEffects();
        PlayIdle();
        ClientState = WS_ReadyToFire;
	ModifiedWeapon.ClientState = ClientState;
    }
    else if (ClientState == WS_PutDown)
    {
		if ( Instigator.PendingWeapon == None )
		{
			PlayIdle();
			ClientState = WS_ReadyToFire;
			ModifiedWeapon.ClientState = ClientState;
		}
		else
		{
			ClientState = WS_Hidden;
			ModifiedWeapon.ClientState = ClientState;
			Instigator.ChangedWeapon();
			for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
				ModifiedWeapon.FireMode[Mode].DestroyEffects();
		}
    }*/
}

simulated function bool IsFiring()
{
	return ModifiedWeapon.IsFiring();
}

function bool IsRapidFire()
{
	return ModifiedWeapon.IsRapidFire();
}

function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
	return ModifiedWeapon.ConsumeAmmo(Mode, load, bAmountNeededIsMax);
}

simulated function bool HasAmmo()
{
	if (ModifiedWeapon != None)
		return ModifiedWeapon.HasAmmo();

	return false;
}

function AdjustPlayerDamage( out int Damage, Pawn InstigatedBy, Vector HitLocation,
                             out Vector Momentum, class<DamageType> DamageType)
{
	ModifiedWeapon.AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

simulated function StartBerserk()
{
	ModifiedWeapon.StartBerserk();
}

simulated function StopBerserk()
{
	ModifiedWeapon.StopBerserk();
}

simulated function AnimEnd(int channel)
{
	ModifiedWeapon.AnimEnd(channel);
}

simulated function PlayIdle()
{
	ModifiedWeapon.PlayIdle();
}

function bool CheckReflect(Vector HitLocation, out Vector RefNormal, int AmmoDrain)
{
	return ModifiedWeapon.CheckReflect(HitLocation, RefNormal, AmmoDrain);
}

function DoReflectEffect(int Drain)
{
	ModifiedWeapon.DoReflectEffect(Drain);
}

function bool HandlePickupQuery(pickup Item)
{
	//local WeaponPickup wpu;
	local int i;

	if (bNoAmmoInstances)
	{
		// handle ammo pickups
		for (i = 0; i < 2; i++)
		{
			if (Item.inventorytype == AmmoClass[i] && AmmoClass[i] != None)
			{
				if (ModifiedWeapon.AmmoCharge[i] >= MaxAmmo(i))
					return true;
				Item.AnnouncePickup(Pawn(Owner));
				AddAmmo(Ammo(Item).AmmoAmount, i);
				Item.SetRespawn();
				return true;
			}
		}
	}

	if (ModifiedWeapon.Class == Item.InventoryType)
	{
		/*wpu = WeaponPickup(Item);
		if (wpu != None)
		    return !wpu.AllowRepeatPickup();
		else
		    return false;*/
		return ModifiedWeapon.HandlePickupQuery(Item);
	}

	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

function AttachToPawn(Pawn P)
{
	ModifiedWeapon.AttachToPawn(P);
	ThirdPersonActor = ModifiedWeapon.ThirdPersonActor;
}

function DetachFromPawn(Pawn P)
{
	ModifiedWeapon.DetachFromPawn(P);
}

simulated function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
	if (ModifierOverlay != None && bIdentified && mat != ModifierOverlay && time > 0)
	{
		ModifiedWeapon.SetOverlayMaterial(mat, time, true);
		if (WeaponAttachment(ThirdPersonActor) != None)
			ThirdPersonActor.SetOverlayMaterial(mat, time, true);
	}
	else if (ModifierOverlay == None || !bIdentified || time > 0)
		ModifiedWeapon.SetOverlayMaterial(mat, time, bOverride);
	else
	{
		if (time < 0)
			bOverride = true;
		ModifiedWeapon.SetOverlayMaterial(ModifierOverlay, 1000000, bOverride);
		if (WeaponAttachment(ThirdPersonActor) != None)
			ThirdPersonActor.SetOverlayMaterial(ModifierOverlay, 1000000, bOverride);
	}
}

function DropFrom(vector StartLocation)
{
    local int m;
    local Pickup Pickup;
    local Inventory Inv;
    local RPGWeapon W;
    local RPGStatsInv StatsInv;
    local RPGStatsInv.OldRPGWeaponInfo MyInfo;
    local bool bFoundAnother;

    if (!bCanThrow)
    {
    	// hack for default weapons so Controller.GetLastWeapon() will return the modified weapon's class
    	if (Instigator.Health <= 0)
    		Destroy();
        return;
    }
    if (!HasAmmo())
    {
    	return;
    }

    ClientWeaponThrown();

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
            StopFire(m);
    }

	Pickup = Spawn(PickupClass,,, StartLocation);
	if ( Pickup != None )
	{
		Pickup.InitDroppedPickupFor(self);
		Pickup.Velocity = Velocity;
		References++;
        	if (Instigator.Health > 0)
        	{
			WeaponPickup(Pickup).bThrown = true;

			//only toss 1 ammo if have another weapon of the same class
			for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
			{
				W = RPGWeapon(Inv);
				if (W != None && W != self && W.ModifiedWeapon.Class == ModifiedWeapon.Class)
				{
					bFoundAnother = true;
					if (W.bNoAmmoInstances)
					{
						if (AmmoClass[0] != None)
							W.ModifiedWeapon.AmmoCharge[0] -= 1;
						if (AmmoClass[1] != None && AmmoClass[0] != AmmoClass[1])
							W.ModifiedWeapon.AmmoCharge[1] -= 1;
					}
				}
			}
			if (bFoundAnother)
			{
				if (AmmoClass[0] != None)
				{
					WeaponPickup(Pickup).AmmoAmount[0] = 1;
					if (!bNoAmmoInstances)
						Ammo[0].AmmoAmount -= 1;
				}
				if (AmmoClass[1] != None && AmmoClass[0] != AmmoClass[1])
				{
					WeaponPickup(Pickup).AmmoAmount[1] = 1;
					if (!bNoAmmoInstances)
						Ammo[1].AmmoAmount -= 1;
				}
				if (!bNoAmmoInstances)
				{
					Ammo[0] = None;
					Ammo[1] = None;
					ModifiedWeapon.Ammo[0] = None;
					ModifiedWeapon.Ammo[1] = None;
				}
			}
		}
	}

    SetTimer(0, false);
    if (Instigator != None)
    {
	if (ModifiedWeapon != None)
        	StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
       	DetachFromPawn(Instigator);
        Instigator.DeleteInventory(self);
    }
    if (StatsInv != None)
    {
        MyInfo.ModifiedClass = ModifiedWeapon.Class;
        MyInfo.Weapon = self;
    	StatsInv.OldRPGWeapons[StatsInv.OldRPGWeapons.length] = MyInfo;
    	References++;
	DestroyModifiedWeapon();
    }
    else if (Pickup == None)
    	Destroy();
}

simulated function ClientWeaponThrown()
{
	Super.ClientWeaponThrown();

	if (Level.NetMode == NM_Client)
	{
		DestroyModifiedWeapon();
	}
}

function bool AddAmmo(int AmmoToAdd, int Mode)
{
	if (bNoAmmoInstances)
	{
		if (AmmoClass[0] == AmmoClass[mode])
			mode = 0;
		if (Level.GRI.WeaponBerserk > 1.0)
			ModifiedWeapon.AmmoCharge[mode] = MaxAmmo(Mode);
		else if (ModifiedWeapon.AmmoCharge[mode] < MaxAmmo(mode))
			ModifiedWeapon.AmmoCharge[mode] = Min(MaxAmmo(mode), ModifiedWeapon.AmmoCharge[mode]+AmmoToAdd);
		ModifiedWeapon.NetUpdateTime = Level.TimeSeconds - 1;
		SyncUpAmmoCharges();
		return true;
	}

	if (Ammo[Mode] != None)
		return Ammo[Mode].AddAmmo(AmmoToAdd);

	return false;
}

simulated function MaxOutAmmo()
{
	if (bNoAmmoInstances)
	{
		if (AmmoClass[0] != None)
			ModifiedWeapon.AmmoCharge[0] = MaxAmmo(0);
		if (AmmoClass[1] != None && AmmoClass[0] != AmmoClass[1])
			ModifiedWeapon.AmmoCharge[1] = MaxAmmo(1);
		SyncUpAmmoCharges();
		return;
	}
	if (Ammo[0] != None)
		Ammo[0].AmmoAmount = Ammo[0].MaxAmmo;
	if (Ammo[1] != None)
		Ammo[1].AmmoAmount = Ammo[1].MaxAmmo;
}

simulated function SuperMaxOutAmmo()
{
	ModifiedWeapon.SuperMaxOutAmmo();
}

simulated function int MaxAmmo(int mode)
{
	if (bNoAmmoInstances)
		return (ModifiedWeapon.MaxAmmo(mode) * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));

	return ModifiedWeapon.MaxAmmo(mode);
}

simulated function FillToInitialAmmo()
{
	if (!class'MutUT2004RPG'.static.IsSuperWeaponAmmo(AmmoClass[0]))
	{
		ModifiedWeapon.FillToInitialAmmo();

		if (bNoAmmoInstances)
		{
			if (AmmoClass[0] != None)
				ModifiedWeapon.AmmoCharge[0] = Max(ModifiedWeapon.AmmoCharge[0], AmmoClass[0].Default.InitialAmount * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));
			if (AmmoClass[1] != None && AmmoClass[0] != AmmoClass[1])
				ModifiedWeapon.AmmoCharge[1] = Max(ModifiedWeapon.AmmoCharge[1], AmmoClass[1].Default.InitialAmount * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));
			SyncUpAmmoCharges();
		}
		else
		{
			if (Ammo[0] != None)
				Ammo[0].AmmoAmount = Max(Ammo[0].AmmoAmount,Ammo[0].default.InitialAmount * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));
			if (Ammo[1] != None)
				Ammo[1].AmmoAmount = Max(Ammo[1].AmmoAmount,Ammo[1].default.InitialAmount * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));
		}
	}
	else if (HolderStatsInv.RPGMut.bAllowMagicSuperWeaponReplenish)
	{
		ModifiedWeapon.FillToInitialAmmo();
		if (bNoAmmoInstances)
		{
			SyncUpAmmoCharges();
		}
	}
}

simulated function int AmmoAmount(int mode)
{
	return ModifiedWeapon.AmmoAmount(mode);
}

simulated function bool AmmoMaxed(int mode)
{
	return ModifiedWeapon.AmmoMaxed(mode);
}

simulated function bool NeedAmmo(int mode)
{
	if (bNoAmmoInstances)
	{
		if (AmmoClass[0] == AmmoClass[mode])
			mode = 0;
		if (AmmoClass[mode] == None)
			return false;

		return (ModifiedWeapon.AmmoCharge[Mode] < AmmoClass[mode].default.InitialAmount * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));
	}
	if (Ammo[mode] != None)
		 return (Ammo[mode].AmmoAmount < Ammo[mode].InitialAmount * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));

	return false;
}

simulated function CheckOutOfAmmo()
{
	if (Instigator != None && Instigator.Weapon == self && ModifiedWeapon != None)
	{
		if (bNoAmmoInstances)
		{
			if (ModifiedWeapon.AmmoCharge[0] <= 0 && ModifiedWeapon.AmmoCharge[1] <= 0)
				OutOfAmmo();
			return;
		}

		if (Ammo[0] != None)
			Ammo[0].CheckOutOfAmmo();
		if (Ammo[1] != None)
			Ammo[1].CheckOutOfAmmo();
	}
}

function class<DamageType> GetDamageType()
{
	return ModifiedWeapon.GetDamageType();
}

simulated function bool WantsZoomFade()
{
	return ModifiedWeapon.WantsZoomFade();
}

function bool CanHeal(Actor Other)
{
	return ModifiedWeapon.CanHeal(Other);
}

function bool ShouldFireWithoutTarget()
{
	return ModifiedWeapon.ShouldFireWithoutTarget();
}

simulated function PawnUnpossessed()
{
	ModifiedWeapon.PawnUnpossessed();
}

//I'm sure I don't need to explain the magnitude of this awful hack
exec function ChangeAmmo()
{
	if (PlayerController(Instigator.Controller) != None)
	{
		Instigator.Weapon = ModifiedWeapon;
		PlayerController(Instigator.Controller).ConsoleCommand("ChangeAmmo");
		Instigator.Weapon = self;
		FireMode[0] = ModifiedWeapon.FireMode[0];
		FireMode[1] = ModifiedWeapon.FireMode[1];
		Ammo[0] = ModifiedWeapon.Ammo[0];
		Ammo[1] = ModifiedWeapon.Ammo[1];
		AmmoClass[0] = ModifiedWeapon.AmmoClass[0];
		AmmoClass[1] = ModifiedWeapon.AmmoClass[1];
		ThirdPersonActor = ModifiedWeapon.ThirdPersonActor;
	}
}

//Yet more ugly hacking... but at least it's for a good cause
exec function ChaosWeaponOption()
{
	if (PlayerController(Instigator.Controller) != None)
	{
		Instigator.Weapon = ModifiedWeapon;
		PlayerController(Instigator.Controller).ConsoleCommand("ChaosWeaponOption");
		Instigator.Weapon = self;
	}
}

//the next two are for Remote Strike
//why someone would want to play a realism mod with magic weapons is beyond me
exec function ReloadMeNow()
{
	if (PlayerController(Instigator.Controller) != None)
	{
		Instigator.Weapon = ModifiedWeapon;
		PlayerController(Instigator.Controller).ConsoleCommand("ReloadMeNow");
		Instigator.Weapon = self;
	}
}

exec function FinishReloading()
{
	if (PlayerController(Instigator.Controller) != None)
	{
		Instigator.Weapon = ModifiedWeapon;
		PlayerController(Instigator.Controller).ConsoleCommand("FinishReloading");
		Instigator.Weapon = self;
	}
}

function ServerForceUpdate()
{
	NetUpdateTime = Level.TimeSeconds - 1;
}

state PendingClientWeaponSet
{
    simulated function EndState()
    {
	if (Instigator != None && PlayerController(Instigator.Controller) != None)
	{
		if (bIdentified)
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'IdentifyMessage', 1,,, self);
		else if (ModifiedWeapon.PickupClass != None)
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(ModifiedWeapon.PickupClass.default.MessageClass, 0,,,ModifiedWeapon.PickupClass);
	}
    }
}

defaultproperties
{
	bGameRelevant=true
	PickupClass=class'RPGWeaponPickup'
}

