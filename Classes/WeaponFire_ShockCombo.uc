/*******************************************************************************
 * WeaponFire_ShockCombo generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class WeaponFire_ShockCombo extends ShockProjectile;

function SuperExplosion()
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal;

    HurtRadius(ComboDamage, ComboRadius, class'DamType_ShockCombo', ComboMomentumTransfer, Location);
    Spawn(class'ShockCombo');
    // End:0xA7
    if((Level.NetMode != NM_DedicatedServer) && EffectIsRelevant(Location, false))
    {
        HitActor = Trace(HitLocation, HitNormal, Location - vect(0.0, 0.0, 120.0), Location, false);
        // End:0xA7
        if(HitActor != none)
        {
            Spawn(class'ComboDecal', self,, HitLocation, rotator(vect(0.0, 0.0, -1.0)));
        }
    }
    PlaySound(ComboSound, 0, 1.0,, 800.0);
    DestroyTrails();
    Destroy();
    //return;    
}

event TakeDamage(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType)
{
    local Misc_PRI PRI;

    // End:0x0D
    if(EventInstigator == none)
    {
        return;
    }
    PRI = Misc_PRI(EventInstigator.PlayerReplicationInfo);
    // End:0xEA
    if(DamageType == ComboDamageType)
    {
        Instigator = EventInstigator;
        SuperExplosion();
        // End:0x9D
        if(PRI != none)
        {
            PRI.Combo.Fired += 1;
            PRI.Shock.primary.Fired -= 1;
            PRI.Shock.Secondary.Fired -= 1;
        }
        // End:0xEA
        if((EventInstigator != none) && EventInstigator.Weapon != none)
        {
            EventInstigator.Weapon.ConsumeAmmo(0, float(ComboAmmoCost), true);
            Instigator = EventInstigator;
        }
    }
    //return;    
}

defaultproperties
{
    ComboAmmoCost=2
}