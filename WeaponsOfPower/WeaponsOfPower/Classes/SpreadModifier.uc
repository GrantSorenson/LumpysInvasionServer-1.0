class SpreadModifier extends FireModeWeaponModifier;

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    FireModeEntries(0)=(WeaponType=Class'XWeapons.LinkGun',FireMode=Class'SpreadLinkFireMode',modeNum=0,)
    FireModeEntries(1)=(WeaponType=Class'UT2004RPG.RPGLinkGun',FireMode=Class'SpreadLinkFireMode',modeNum=0,)
    FireModeEntries(2)=(WeaponType=Class'XWeapons.BioRifle',FireMode=Class'SpreadBioFireMode',modeNum=0,)
    ModifierEffect=Shader'WeaponsOfPowerTextures.Weapons.SpreadWeaponShader'
    ModifierColor=(R=128,G=255,B=128,A=0),
    configuration=Class'SpreadModifierConfiguration'
    Artifact=Class'SpreadModifierArtifact'
}
