/*******************************************************************************
 * NewNet_RocketFire generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_RocketFire extends WeaponFire_Rocket
    dependson(WeaponFire_Rocket);

const PROJ_TIMESTEP = 0.0201;
const MAX_PROJECTILE_FUDGE = 0.075;
const SLACK = 0.035;

var float PingDT;
var bool bUseEnhancedNetCode;
var bool bUseReplicatedInfo;
var Rotator SavedRot;
var Vector savedVec;
var Vector OldInstigatorLocation;
var Vector OldInstigatorEyePosition;
var Vector OldXAxis;
var Vector OldYAxis;
var Vector OldZAxis;
var Rotator OldAim;
var class<Projectile> FakeProjectileClass;
var NewNet_FakeProjectileManager FPM;
var TAM_Mutator MNN;
var bool bSkipNextEffect;

function PlayFiring()
{
    super(RocketFire).PlayFiring();
    // End:0x37
    if((Level.NetMode != NM_Client) || !class'Misc_Player'.static.UseNewNet())
    {
        return;
    }
    // End:0x4B
    if(!bSkipNextEffect)
    {
        CheckFireEffect();
    }
    // End:0x63
    else
    {
        bSkipNextEffect = false;
        Weapon.ClientStopFire(0);
    }
    //return;    
}

function CheckFireEffect()
{
    // End:0xDC
    if((Level.NetMode == NM_Client) && Instigator.IsLocallyControlled())
    {
        // End:0xD6
        if((class'NewNet_PRI'.default.PredictedPing - 0.0350) > 0.0750)
        {
            OldInstigatorLocation = Instigator.Location;
            OldInstigatorEyePosition = Instigator.EyePosition();
            Weapon.GetViewAxes(OldXAxis, OldYAxis, OldZAxis);
            OldAim = AdjustAim(OldInstigatorLocation + OldInstigatorEyePosition, aimerror);
            SetTimer((class'NewNet_PRI'.default.PredictedPing - 0.0350) - 0.0750, false);
        }
        // End:0xDC
        else
        {
            DoClientFireEffect();
        }
    }
    //return;    
}

function Timer()
{
    DoTimedClientFireEffect();
    //return;    
}

function DoInstantFireEffect()
{
    CheckFireEffect();
    bSkipNextEffect = true;
    //return;    
}

simulated function DoTimedClientFireEffect()
{
    local Vector StartProj, StartTrace, X, Y, Z;

    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int P, SpawnCount;
    local float theta;

    Instigator.MakeNoise(1.0);
    X = OldXAxis;
    Y = OldXAxis;
    Z = OldXAxis;
    StartTrace = OldInstigatorLocation + OldInstigatorEyePosition;
    StartProj = StartTrace + (X * ProjSpawnOffset.X);
    // End:0xB7
    if(!Weapon.WeaponCentered())
    {
        StartProj = (StartProj + ((Weapon.hand * Y) * ProjSpawnOffset.Y)) + (Z * ProjSpawnOffset.Z);
    }
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    // End:0xF4
    if(Other != none)
    {
        StartProj = HitLocation;
    }
    Aim = OldAim;
    SpawnCount = Max(1, ProjPerFire * int(load));
    switch(SpreadStyle)
    {
        // End:0x216
        case 1:
            X = vector(Aim);
            P = 0;
            J0x136:
            // End:0x213 [Loop If]
            if(P < SpawnCount)
            {
                R.Yaw = int(Spread * (FRand() - 0.50));
                R.Pitch = int(Spread * (FRand() - 0.50));
                R.Roll = int(Spread * (FRand() - 0.50));
                // End:0x1BA
                if(FPM == none)
                {
                    FindFPM();
                    // End:0x1BA
                    if(FPM == none)
                    {
                        return;
                    }
                }
                // End:0x209
                if(FPM.AllowFakeProjectile(FakeProjectileClass, P))
                {
                    FPM.RegisterFakeProjectile(FlakChunk(SpawnFakeProjectile(StartProj, rotator(X >> R))), P);
                }
                ++ P;
                // [Loop Continue]
                goto J0x136;
            }
            // End:0x2D6
            break;
        // End:0x2C3
        case 2:
            P = 0;
            J0x222:
            // End:0x2C0 [Loop If]
            if(P < SpawnCount)
            {
                theta = ((Spread * 3.1415930) / float(32768)) * (float(P) - (float(SpawnCount - 1) / 2.0));
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                SpawnFakeProjectile(StartProj, rotator(X >> Aim));
                ++ P;
                // [Loop Continue]
                goto J0x222;
            }
            // End:0x2D6
            break;
        // End:0xFFFF
        default:
            SpawnFakeProjectile(StartProj, Aim);
            //return;
    }    
}

simulated function DoClientFireEffect()
{
    local Vector StartProj, StartTrace, X, Y, Z;

    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int P, SpawnCount;
    local float theta;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X, Y, Z);
    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + (X * ProjSpawnOffset.X);
    // End:0xC7
    if(!Weapon.WeaponCentered())
    {
        StartProj = (StartProj + ((Weapon.hand * Y) * ProjSpawnOffset.Y)) + (Z * ProjSpawnOffset.Z);
    }
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    // End:0x104
    if(Other != none)
    {
        StartProj = HitLocation;
    }
    Aim = AdjustAim(StartProj, aimerror);
    SpawnCount = Max(1, ProjPerFire * int(load));
    switch(SpreadStyle)
    {
        // End:0x1DE
        case 1:
            X = vector(Aim);
            P = 0;
            J0x151:
            // End:0x1DB [Loop If]
            if(P < SpawnCount)
            {
                R.Yaw = int(Spread * (FRand() - 0.50));
                R.Pitch = int(Spread * (FRand() - 0.50));
                R.Roll = int(Spread * (FRand() - 0.50));
                SpawnFakeProjectile(StartProj, rotator(X >> R));
                ++ P;
                // [Loop Continue]
                goto J0x151;
            }
            // End:0x29E
            break;
        // End:0x28B
        case 2:
            P = 0;
            J0x1EA:
            // End:0x288 [Loop If]
            if(P < SpawnCount)
            {
                theta = ((Spread * 3.1415930) / float(32768)) * (float(P) - (float(SpawnCount - 1) / 2.0));
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                SpawnFakeProjectile(StartProj, rotator(X >> Aim));
                ++ P;
                // [Loop Continue]
                goto J0x1EA;
            }
            // End:0x29E
            break;
        // End:0xFFFF
        default:
            SpawnFakeProjectile(StartProj, Aim);
            //return;
    }    
}

simulated function Projectile SpawnFakeProjectile(Vector Start, Rotator Dir)
{
    local Projectile P;

    // End:0x1E
    if(FPM == none)
    {
        FindFPM();
        // End:0x1E
        if(FPM == none)
        {
            return none;
        }
    }
    P = FakeSuperSpawnProjectile(Start, Dir);
    FPM.RegisterFakeProjectile(P);
    return P;
    //return;    
}

simulated function Projectile FakeSuperSpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile P;

    // End:0x2E
    if(ProjectileClass != none)
    {
        P = Weapon.Spawn(FakeProjectileClass,,, Start, Dir);
    }
    // End:0x3B
    if(P == none)
    {
        return none;
    }
    P.Damage *= DamageAtten;
    return P;
    //return;    
}

simulated function FindFPM()
{
    // End:0x1D
    foreach Weapon.DynamicActors(class'NewNet_FakeProjectileManager', FPM)
    {
        // End:0x1D
        break;        
    }    
    //return;    
}

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X, Y, Z;

    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int P, SpawnCount;
    local float theta;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X, Y, Z);
    // End:0x46
    if(bUseReplicatedInfo)
    {
        StartTrace = savedVec;
    }
    // End:0x6B
    else
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
    }
    StartProj = StartTrace + (X * ProjSpawnOffset.X);
    // End:0xDE
    if(!Weapon.WeaponCentered())
    {
        StartProj = (StartProj + ((Weapon.hand * Y) * ProjSpawnOffset.Y)) + (Z * ProjSpawnOffset.Z);
    }
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    // End:0x11B
    if(Other != none)
    {
        StartProj = HitLocation;
    }
    // End:0x13A
    if(bUseReplicatedInfo)
    {
        Aim = SavedRot;
        bUseReplicatedInfo = false;
    }
    // End:0x150
    else
    {
        Aim = AdjustAim(StartProj, aimerror);
    }
    SpawnCount = Max(1, ProjPerFire * int(load));
    switch(SpreadStyle)
    {
        // End:0x214
        case 1:
            X = vector(Aim);
            P = 0;
            J0x187:
            // End:0x211 [Loop If]
            if(P < SpawnCount)
            {
                R.Yaw = int(Spread * (FRand() - 0.50));
                R.Pitch = int(Spread * (FRand() - 0.50));
                R.Roll = int(Spread * (FRand() - 0.50));
                SpawnProjectile(StartProj, rotator(X >> R));
                ++ P;
                // [Loop Continue]
                goto J0x187;
            }
            // End:0x2D4
            break;
        // End:0x2C1
        case 2:
            P = 0;
            J0x220:
            // End:0x2BE [Loop If]
            if(P < SpawnCount)
            {
                theta = ((Spread * 3.1415930) / float(32768)) * (float(P) - (float(SpawnCount - 1) / 2.0));
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                SpawnProjectile(StartProj, rotator(X >> Aim));
                ++ P;
                // [Loop Continue]
                goto J0x220;
            }
            // End:0x2D4
            break;
        // End:0xFFFF
        default:
            SpawnProjectile(StartProj, Aim);
            //return;
    }    
}

defaultproperties
{
    FakeProjectileClass=class'NewNet_Fake_RocketProj'
}