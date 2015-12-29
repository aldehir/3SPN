/*******************************************************************************
 * NewNet_BioGlob generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_BioGlob extends BioGlob
    hidedropdown
    cacheexempt;

const INTERP_TIME = 0.50;

var PlayerController PC;
var Vector DesiredDeltaFake;
var float CurrentDeltaFakeTime;
var bool bInterpFake;
var bool bOwned;
var NewNet_FakeProjectileManager FPM;
var int Index;

replication
{
    // Pos:0x000
    unreliable if(bDemoRecording)
        DoMove, DoSetLoc

    // Pos:0x006
    reliable if((Role == ROLE_Authority) && bNetInitial)
        Index
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

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
    // End:0x21
    if(Level.NetMode != NM_Client)
    {
        return;
    }
    PC = Level.GetLocalPlayerController();
    // End:0x45
    if(CheckOwned())
    {
        CheckForFakeProj();
    }
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

    // End:0x1E
    if(FPM == none)
    {
        FindFPM();
        // End:0x1E
        if(FPM == none)
        {
            return false;
        }
    }
    FP = FPM.GetFP(class'NewNet_Fake_BioGlob', Index);
    // End:0x9D
    if(FP != none)
    {
        bInterpFake = true;
        DesiredDeltaFake = Location - FP.Location;
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
    // End:0x3D
    if(bInterpFake)
    {
        FakeInterp(DeltaTime);
    }
    // End:0x4C
    else
    {
        // End:0x4C
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

    V = (DesiredDeltaFake * dt) / 0.50;
    OldDeltaFakeTime = CurrentDeltaFakeTime;
    CurrentDeltaFakeTime += dt;
    // End:0x4D
    if(CurrentDeltaFakeTime < 0.50)
    {
        DoMove(V);
    }
    // End:0x75
    else
    {
        DoMove(((0.50 - OldDeltaFakeTime) / dt) * V);
        bInterpFake = false;
    }
    //return;    
}
