/*******************************************************************************
 * NewNet_LinkAltFire generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_LinkAltFire extends WeaponFire_LinkAlt
    dependson(WeaponFire_LinkAlt)
    dependson(NewNet_LinkProjectile);

const PROJ_TIMESTEP = 0.0201;
const MAX_PROJECTILE_FUDGE = 0.075;
const SLACK = 0.025;

var float PingDT;
var bool bUseEnhancedNetCode;
var class<Projectile> FakeProjectileClass;
var NewNet_FakeProjectileManager FPM;
var Vector OldInstigatorLocation;
var Vector OldInstigatorEyePosition;
var Vector OldXAxis;
var Vector OldYAxis;
var Vector OldZAxis;
var Rotator OldAim;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local LinkProjectile proj;
    local Vector HitLocation, HitNormal, End;
    local Actor Other;
    local float F, G;

    // End:0x3E
    if((Level.NetMode == NM_Client) && class'Misc_Player'.static.UseNewNet())
    {
        return SpawnFakeProjectile(Start, Dir);
    }
    // End:0x5A
    if(!bUseEnhancedNetCode)
    {
        return super(LinkAltFire).SpawnProjectile(Start, Dir);
    }
    Start += ((vector(Dir) * 10.0) * float(LinkGun(Weapon).Links));
    // End:0x278
    if((PingDT > 0.0) && Weapon.Owner != none)
    {
        Start -= (1.0 * vector(Dir));
        F = 0.0;
        J0xCB:
        // End:0x16A [Loop If]
        if(F < (PingDT + 0.02010))
        {
            G = FMin(PingDT, F);
            End = Start + (Extrapolate(Dir, 0.02010));
            TimeTravel(PingDT - G);
            Other = DoTimeTravelTrace(HitLocation, HitNormal, End, Start);
            // End:0x150
            if(Other != none)
            {
                // [Explicit Break]
                goto J0x16A;
            }
            Start = End;
            F += 0.02010;
            J0x16A:
            // [Loop Continue]
            goto J0xCB;
        }
        UnTimeTravel();
        // End:0x1E3
        if((Other != none) && Other.UnresolvedNativeFunction_97('NewNet_PawnCollisionCopy'))
        {
            HitLocation = (HitLocation + NewNet_PawnCollisionCopy(Other).CopiedPawn.Location) - Other.Location;
            Other = NewNet_PawnCollisionCopy(Other).CopiedPawn;
        }
        // End:0x214
        if(Other == none)
        {
            proj = Weapon.UnresolvedNativeFunction_97(class'NewNet_LinkProjectile',,, End, Dir);
        }
        // End:0x275
        else
        {
            proj = Weapon.UnresolvedNativeFunction_97(class'NewNet_LinkProjectile',,, HitLocation - (vector(Dir) * 20.0), Dir);
            NewNet_LinkGun(Weapon).DispatchClientEffect(HitLocation - (vector(Dir) * 20.0), Dir);
        }
    }
    // End:0x29B
    else
    {
        proj = Weapon.UnresolvedNativeFunction_97(class'NewNet_LinkProjectile',,, Start, Dir);
    }
    // End:0x2D7
    if(proj != none)
    {
        proj.Links = LinkGun(Weapon).Links;
        proj.LinkAdjust();
    }
    // End:0x323
    if(NewNet_LinkProjectile(proj) != none)
    {
        NewNet_LinkProjectile(proj).Index = NewNet_LinkGun(Weapon).CurIndex;
        ++ NewNet_LinkGun(Weapon).CurIndex;
    }
    return proj;
    //return;    
}

function Vector Extrapolate(out Rotator Dir, float dF)
{
    return (vector(Dir) * ProjectileClass.default.Speed) * dF;
    //return;    
}

function Actor DoTimeTravelTrace(out Vector HitLocation, out Vector HitNormal, Vector End, Vector Start)
{
    local Actor Other;
    local bool bFoundPCC;
    local Vector NewEnd, WorldHitNormal, WorldHitLocation, PCCHitNormal, PCCHitLocation;

    local NewNet_PawnCollisionCopy PCC, returnPCC;

    // End:0x8D
    foreach Weapon.TraceActors(class'Actor', Other, WorldHitLocation, WorldHitNormal, End, Start)
    {
        // End:0x85
        if(((Other.bBlockActors || Other.bProjTarget) || Other.bWorldGeometry) && !class'TAM_Mutator'.static.IsPredicted(Other))
        {
            // End:0x8D
            break;
        }
        Other = none;        
    }    
    // End:0xA7
    if(Other != none)
    {
        NewEnd = WorldHitLocation;
    }
    // End:0xB2
    else
    {
        NewEnd = End;
    }
    // End:0x131
    foreach Weapon.TraceActors(class'NewNet_PawnCollisionCopy', PCC, PCCHitLocation, PCCHitNormal, NewEnd, Start)
    {
        // End:0x130
        if(((PCC != none) && PCC.CopiedPawn != none) && PCC.CopiedPawn != Instigator)
        {
            bFoundPCC = true;
            returnPCC = PCC;
            // End:0x131
            break;
        }        
    }    
    // End:0x15A
    if(bFoundPCC)
    {
        HitLocation = PCCHitLocation;
        HitNormal = PCCHitNormal;
        return returnPCC;
    }
    // End:0x176
    else
    {
        HitLocation = WorldHitLocation;
        HitNormal = WorldHitNormal;
        return Other;
    }
    //return;    
}

function TimeTravel(float Delta)
{
    local NewNet_PawnCollisionCopy PCC;

    // End:0x45
    if(NewNet_LinkGun(Weapon).M == none)
    {
        // End:0x44
        foreach Weapon.DynamicActors(class'TAM_Mutator', NewNet_FlakCannon(Weapon).M)
        {
            // End:0x44
            break;            
        }        
    }
    PCC = NewNet_LinkGun(Weapon).M.PCC;
    J0x67:
    // End:0x9D [Loop If]
    if(PCC != none)
    {
        PCC.TimeTravelPawn(Delta);
        PCC = PCC.Next;
        // [Loop Continue]
        goto J0x67;
    }
    //return;    
}

function UnTimeTravel()
{
    local NewNet_PawnCollisionCopy PCC;

    PCC = NewNet_LinkGun(Weapon).M.PCC;
    J0x22:
    // End:0x53 [Loop If]
    if(PCC != none)
    {
        PCC.TurnOffCollision();
        PCC = PCC.Next;
        // [Loop Continue]
        goto J0x22;
    }
    //return;    
}

function CheckFireEffect()
{
    // End:0xDC
    if((Level.NetMode == NM_Client) && Instigator.IsLocallyControlled())
    {
        // End:0xD6
        if((class'NewNet_PRI'.default.PredictedPing - 0.0250) > 0.0750)
        {
            OldInstigatorLocation = Instigator.Location;
            OldInstigatorEyePosition = Instigator.EyePosition();
            Weapon.GetViewAxes(OldXAxis, OldYAxis, OldZAxis);
            OldAim = AdjustAim(OldInstigatorLocation + OldInstigatorEyePosition, aimerror);
            SetTimer((class'NewNet_PRI'.default.PredictedPing - 0.0250) - 0.0750, false);
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

function PlayFiring()
{
    super(LinkAltFire).PlayFiring();
    // End:0x37
    if((Level.NetMode != NM_Client) || !class'Misc_Player'.static.UseNewNet())
    {
        return;
    }
    CheckFireEffect();
    //return;    
}

function DoClientFireEffect()
{
    DoFireEffect();
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
        // End:0x1C3
        case 1:
            X = vector(Aim);
            P = 0;
            J0x136:
            // End:0x1C0 [Loop If]
            if(P < SpawnCount)
            {
                R.Yaw = int(Spread * (FRand() - 0.50));
                R.Pitch = int(Spread * (FRand() - 0.50));
                R.Roll = int(Spread * (FRand() - 0.50));
                SpawnFakeProjectile(StartProj, rotator(X >> R));
                ++ P;
                // [Loop Continue]
                goto J0x136;
            }
            // End:0x283
            break;
        // End:0x270
        case 2:
            P = 0;
            J0x1CF:
            // End:0x26D [Loop If]
            if(P < SpawnCount)
            {
                theta = ((Spread * 3.1415930) / float(32768)) * (float(P) - (float(SpawnCount - 1) / 2.0));
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                SpawnFakeProjectile(StartProj, rotator(X >> Aim));
                ++ P;
                // [Loop Continue]
                goto J0x1CF;
            }
            // End:0x283
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
    // End:0x8C
    if(FPM.AllowFakeProjectile(FakeProjectileClass, NewNet_LinkGun(Weapon).CurIndex) && class'NewNet_PRI'.default.PredictedPing >= 0.050)
    {
        P = Spawn(FakeProjectileClass, Weapon.Owner,, Start, Dir);
    }
    // End:0x99
    if(P == none)
    {
        return none;
    }
    FPM.RegisterFakeProjectile(P, NewNet_LinkGun(Weapon).CurIndex);
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

defaultproperties
{
    FakeProjectileClass=class'NewNet_Fake_LinkProjectile'
    ProjectileClass=class'NewNet_LinkProjectile'
}