/*******************************************************************************
 * WeaponFire_Link generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class WeaponFire_Link extends LinkFire;

event ModeDoFire()
{
    // End:0x4F
    if(!LinkGun(Weapon).Linking)
    {
        ++ Misc_PRI(xPawn(Weapon.Owner).PlayerReplicationInfo).Link.primary.Fired;
    }
    super.ModeDoFire();
    //return;    
}
