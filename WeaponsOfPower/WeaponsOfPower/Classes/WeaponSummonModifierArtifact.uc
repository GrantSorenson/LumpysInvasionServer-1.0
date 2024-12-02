class WeaponSummonModifierArtifact extends WeaponModifierArtifact;

defaultproperties
{
    ModifierClass=Class'WeaponSummonModifier'
    Description="Provides a way to summon a new weapon, even those that are not normally available in a level. Simply apply and then wait three waves. Alternatively, if you die and respawn you immediately reap the benefit.||At level one you spawn a random positive RPG weapon.|At level two you may spawn a super weapon."
    PickupClass=Class'WeaponSummonModifierPickup'
    IconMaterial=Texture'WeaponsOfPowerTextures.Icons.WeaponSummonIcon'
    ItemName="Weapon Summon Power Up"
}
