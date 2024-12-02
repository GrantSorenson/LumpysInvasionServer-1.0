class HealingModifierArtifact extends WeaponModifierArtifact;

defaultproperties
{
    ModifierClass=Class'HealingModifier'
    Description="Allows you to heal yourself and teammates. The rate of healing is 5% of the damage per level. Each level after 5 allows you to heal an additional 10 HP. At level 10 you can health to a players max health and additionally give them up to 50 shield."
    PickupClass=Class'HealingModifierPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.HealingIcon'
    ItemName="Healing Power Up"
}
