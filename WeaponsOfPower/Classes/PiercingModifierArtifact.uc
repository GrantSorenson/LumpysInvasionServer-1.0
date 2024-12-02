class PiercingModifierArtifact extends WeaponModifierArtifact;

defaultproperties
{
    ModifierClass=Class'PiercingModifier'
    Description="Allows the weapon to directly attack a target's life, bypassing their shields.||Note that this does not work against all monsters, only monsters that use player shields. (Satore's does not work with this.)"
    PickupClass=Class'PiercingModifierPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.PiercingIcon'
    ItemName="Piercing Power Up"
}
