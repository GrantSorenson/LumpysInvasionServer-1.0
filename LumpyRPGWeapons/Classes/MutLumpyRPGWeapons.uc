class MutLumpyRPGWeapons extends Mutator config(LumpyRPGWeaponsConfig);

#EXEC OBJ LOAD FILE=ZenWIcons.utx
#EXEC OBJ LOAD FILE=RainbowShockRifleTex.utx

var string NewWeaponClassName;
var() config string WeaponClassName;

var class<Weapon> NewWeaponClass;
var class<Weapon> WeaponClass;

var bool bInitialized;

function PostBeginPlay()
{
  //Add custom Game Rules Here


  Super.PostBeginPlay();
}

function prebeginplay()
{
	super.prebeginplay();
	saveconfig();
}

function Initialize()
{
  bInitialized = true;

  NewWeaponClass = class<Weapon>(DynamicLoadObject(NewWeaponClassName,class'Class'));
  WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassName,class'Class'));
  NewWeaponClass.default.InventoryGroup= WeaponClass.default.InventoryGroup;

  class'LumpyRPGWeapons.MP5Ammo'.static.StaticSaveConfig();
  class'LumpyRPGWeapons.MP5GrenadeAmmo'.static.StaticSaveConfig();
  NewWeaponClass.static.StaticSaveConfig();
}

function bool AlwaysKeep(Actor Other)
{

	if (Other.class ==  NewWeaponClass)
		return true;
	else if (NewWeaponClass != None && Other.class == NewWeaponClass.default.FireModeClass[0].default.Ammoclass.default.PickupClass)
		return true;

	if ( NextMutator != None )
		return ( NextMutator.AlwaysKeep(Other) );
	return false;
}

defaultproperties
{
    NewWeaponClassName="LumpyRPGWeapons.MP5Gun"
    WeaponClassName="XWeapons.AssaultRifle"
    bAddToServerPackages=True
    FriendlyName="Lumpys RPG Weapons"
    Description="A Collection of weapons brought togther or made by Lumpy, attributions can be found in the credits."
    bAlwaysRelevant=True
}
