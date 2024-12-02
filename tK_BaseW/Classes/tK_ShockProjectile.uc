class tK_ShockProjectile extends ShockProjectile;

State WaitForCombo
{
    function Tick(float DeltaTime)
    {
        if ( (ComboTarget == None) || ComboTarget.bDeleteMe
            || (Instigator == None) || (tK_ShockRifle(Instigator.Weapon) == None) )
        {
            GotoState('');
            return;
        }

        if ( (VSize(ComboTarget.Location - Location) <= 0.5 * ComboRadius + ComboTarget.CollisionRadius)
            || ((Velocity Dot (ComboTarget.Location - Location)) <= 0) )
        {
            tK_ShockRifle(Instigator.Weapon).DoCombo();
            GotoState('');
            return;
        }
    }
}

defaultproperties
{
}
