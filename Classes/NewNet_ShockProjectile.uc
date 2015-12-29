/*******************************************************************************
 * NewNet_ShockProjectile generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_ShockProjectile extends WeaponFire_ShockCombo;

const INTERP_TIME = 0.70;
const PLACEBO_FIX = 0.025;

var PlayerController PC;
var Vector DesiredDeltaFake;
var float CurrentDeltaFakeTime;
var bool bInterpFake;
var bool bOwned;
var bool bMoved;
var float Ping;
var NewNet_FakeProjectileManager FPM;

replication
{
    // Pos:0x000
    unreliable if(bDemoRecording)
        DoMove, DoSetLoc
}

simulated function PostNetBeginPlay()
{
    super(ShockProjectile).PostNetBeginPlay();
    // End:0x21
    if(Level.NetMode != NM_Client)
    {
        return;
    }
    DoPostNet();
    //return;    
}

simulated function DoPostNet()
{
    PC = Level.GetLocalPlayerController();
    // End:0x6A
    if(CheckOwned())
    {
        // End:0x6A
        if(!CheckForFakeProj())
        {
            bMoved = true;
            DoMove(FMax(0.0, class'NewNet_PRI'.default.PredictedPing - (1.50 * class'NewNet_TimeStamp'.default.AverDT)) * Velocity);
        }
    }
    //return;    
}

simulated function DoMove(Vector V)
{
    Move(V);
    //return;    
}

simulated function DoSetLoc(Vector V)
{
    SetLocation(V);
    //return;    
}

simulated function bool CheckOwned()
{
    // End:0x17
    if(class'Misc_Player'.default.bEnableEnhancedNetCode == false)
    {
        return false;
    }
    bOwned = ((PC != none) && PC.Pawn != none) && PC.Pawn == Instigator;
    return bOwned;
    //return;    
}

simulated function bool CheckForFakeProj()
{
    local Projectile FP;

    Ping = FMax(0.0, class'NewNet_PRI'.default.PredictedPing - (1.50 * class'NewNet_TimeStamp'.default.AverDT));
    // End:0x50
    if(FPM == none)
    {
        FindFPM();
        // End:0x50
        if(FPM == none)
        {
            return false;
        }
    }
    FP = FPM.GetFP(class'NewNet_Fake_ShockProjectile');
    // End:0xFF
    if(FP != none)
    {
        bInterpFake = true;
        // End:0xA4
        if(bMoved)
        {
            DesiredDeltaFake = Location - FP.Location;
        }
        // End:0xCD
        else
        {
            DesiredDeltaFake = (Location + (Velocity * Ping)) - FP.Location;
        }
        DoSetLoc(FP.Location);
        FPM.RemoveProjectile(FP);
        bOwned = false;
        return true;
    }
    return false;
    //return;    
}

simulated function FindFPM()
{
    // End:0x14
    foreach DynamicActors(class'NewNet_FakeProjectileManager', FPM)
    {
        // End:0x14
        break;        
    }    
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x26
    if(Level.NetMode != NM_Client)
    {
        return;
    }
    DoTick(DeltaTime);
    //return;    
}

simulated function DoTick(float DeltaTime)
{
    // End:0x17
    if(bInterpFake)
    {
        FakeInterp(DeltaTime);
    }
    // End:0x26
    else
    {
        // End:0x26
        if(bOwned)
        {
            CheckForFakeProj();
        }
    }
    //return;    
}

simulated function FakeInterp(float dt)
{
    local Vector V;
    local float OldDeltaFakeTime;

    V = (DesiredDeltaFake * dt) / 0.70;
    OldDeltaFakeTime = CurrentDeltaFakeTime;
    CurrentDeltaFakeTime += dt;
    // End:0x4D
    if(CurrentDeltaFakeTime < 0.70)
    {
        DoMove(V);
    }
    // End:0x75
    else
    {
        DoMove(((0.70 - OldDeltaFakeTime) / dt) * V);
        bInterpFake = false;
    }
    //return;    
}
