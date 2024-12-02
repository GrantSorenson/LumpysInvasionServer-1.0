class PoisonModifierArtifact extends WeaponModifierArtifact;

defaultproperties
{
    ModifierClass=Class'PoisonModifier'
    Description="Poisons an enemy when they are hit by a weapon with this power-up applied. Each level increases the duration of the poison and the damage dealt by it."
    PickupClass=Class'PoisonModifierPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.PoisonIcon'
    ItemName="Poison Power Up"
}
