class WeaponFire_ShockAlt extends ShockProjFire;

event ModeDoFire()
{
    Misc_PRI(xPawn(Weapon.Owner).PlayerReplicationInfo).Shock.Secondary.Fired += load;
    Super.ModeDoFire();
}

defaultproperties
{
     ProjectileClass=Class'3SPNv3300CW.WeaponFire_ShockCombo'
}
