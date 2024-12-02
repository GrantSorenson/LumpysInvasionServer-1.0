class EnergyModifierArtifact extends WeaponModifierArtifact;

defaultproperties
{
    ModifierClass=Class'EnergyModifier'
    Description="Earn adrenaline by attacking monsters or players on opposing teams. For each level 2% of the damage dealt is given back in adrenaline.||Note that you will not receive adrenaline for self damage or team damage."
    PickupClass=Class'EnergyModifierPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.EnergyIcon'
    ItemName="Energy Power Up"
}
