/*******************************************************************************
 * Freon_Player generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class Freon_Player extends Misc_Player
    dependson(Freon_Trigger)
    config(User);

var Freon_Pawn FrozenPawn;

replication
{
    // Pos:0xFFFF
    unreliable if(/* An exception occurred while decompiling condition (System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at UELib.Core.UClass.FormatReplication()) */)
        ServerViewNextPlayer, ServerViewSelf

    // Pos:0x000
    reliable if(Role == ROLE_Authority)
        ClientListBestFreon, ClientSendStatsFreon

    // Pos:0xFFFF
    reliable if())
        BecomeSpectator, ServerDoCombo, 
        ServerUpdateStatArrays
}

exec function SwitchTeam()
{
    super(PlayerController).SwitchTeam();
    // End:0x5F
    if((FrozenPawn != none) && FrozenPawn.MyTrigger != none)
    {
        FrozenPawn.MyTrigger.Team = GetTeamNum();
        FrozenPawn.MyTrigger.Toucher.Length = 0;
    }
    //return;    
}

exec function ChangeTeam(int N)
{
    super(PlayerController).ChangeTeam(N);
    // End:0x64
    if((FrozenPawn != none) && FrozenPawn.MyTrigger != none)
    {
        FrozenPawn.MyTrigger.Team = GetTeamNum();
        FrozenPawn.MyTrigger.Toucher.Length = 0;
    }
    //return;    
}

function ServerUpdateStatArrays(TeamPlayerReplicationInfo PRI)
{
    local Freon_PRI P;

    // End:0x16
    if(PRI != none)
    {
        super.ServerUpdateStatArrays(PRI);
    }
    P = Freon_PRI(PRI);
    // End:0x33
    if(P == none)
    {
        return;
    }
    ClientSendStatsFreon(P, P.Thaws, P.Git);
    //return;    
}

function ClientSendStatsFreon(Freon_PRI P, int Thaws, int Git)
{
    P.Thaws = Thaws;
    P.Git = Git;
    //return;    
}

function ClientListBestFreon(string acc, string Dam, string HS, string th, string gt)
{
    ClientListBest(acc, Dam, HS);
    // End:0x29
    if(class'Misc_Player'.default.bDisableAnnouncement)
    {
        return;
    }
    // End:0x40
    if(th != "")
    {
        ClientMessage(th);
    }
    // End:0x57
    if(gt != "")
    {
        ClientMessage(gt);
    }
    //return;    
}

function AwardAdrenaline(float Amount)
{
    Amount *= 0.80;
    super.AwardAdrenaline(Amount);
    //return;    
}

simulated event Destroyed()
{
    // End:0x2E
    if(FrozenPawn != none)
    {
        FrozenPawn.Died(self, class'Suicided', FrozenPawn.Location);
    }
    super(PlayerController).Destroyed();
    //return;    
}

function BecomeSpectator()
{
    // End:0x2E
    if(FrozenPawn != none)
    {
        FrozenPawn.Died(self, class'DamageType', FrozenPawn.Location);
    }
    super.BecomeSpectator();
    //return;    
}

function ServerDoCombo(class<Combo> ComboClass)
{
    // End:0x44
    if(class<ComboSpeed>(ComboClass) != none)
    {
        ComboClass = class<Combo>(DynamicLoadObject("3SPNv3210CW.Freon_ComboSpeed", class'Class'));
    }
    super.ServerDoCombo(ComboClass);
    //return;    
}

function Reset()
{
    super.Reset();
    FrozenPawn = none;
    //return;    
}

function Freeze()
{
    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    FrozenPawn = Freon_Pawn(Pawn);
    bBehindView = true;
    LastKillTime = -5.0;
    EndZoom();
    Pawn.RemoteRole = ROLE_SimulatedProxy;
    Pawn = none;
    PendingMover = none;
    NextRezTime = Level.TimeSeconds + float(1);
    // End:0x97
    if(!IsInState('GameEnded') && !IsInState('RoundEnded'))
    {
        ServerViewSelf();
        GotoState('Frozen');
    }
    //return;    
}

function ServerViewNextPlayer()
{
    local Controller C, pick;
    local bool bFound, bRealSpec, bWasSpec;
    local TeamInfo RealTeam;

    bRealSpec = PlayerReplicationInfo.bOnlySpectator;
    bWasSpec = ((ViewTarget != FrozenPawn) && ViewTarget != Pawn) && ViewTarget != self;
    PlayerReplicationInfo.bOnlySpectator = true;
    RealTeam = PlayerReplicationInfo.Team;
    C = Level.ControllerList;
    J0x80:
    // End:0x162 [Loop If]
    if(C != none)
    {
        // End:0xD0
        if(bRealSpec && C.PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.Team = C.PlayerReplicationInfo.Team;
        }
        // End:0x14B
        if(Level.Game.CanSpectate(self, bRealSpec, C))
        {
            // End:0x10D
            if(pick == none)
            {
                pick = C;
            }
            // End:0x127
            if(bFound)
            {
                pick = C;
                // [Explicit Break]
                goto J0x162;
            }
            // End:0x14B
            else
            {
                bFound = (RealViewTarget == C) || ViewTarget == C;
            }
        }
        C = C.nextController;
        J0x162:
        // [Loop Continue]
        goto J0x80;
    }
    PlayerReplicationInfo.Team = RealTeam;
    SetViewTarget(pick);
    ClientSetViewTarget(pick);
    // End:0x19F
    if(!bWasSpec)
    {
        bBehindView = false;
    }
    ClientSetBehindView(bBehindView);
    PlayerReplicationInfo.bOnlySpectator = bRealSpec;
    //return;    
}

function ServerViewSelf()
{
    // End:0x98
    if(PlayerReplicationInfo != none)
    {
        // End:0x26
        if(PlayerReplicationInfo.bOnlySpectator)
        {
            super(PlayerController).ServerViewSelf();
        }
        // End:0x98
        else
        {
            // End:0x69
            if(FrozenPawn != none)
            {
                SetViewTarget(FrozenPawn);
                ClientSetViewTarget(FrozenPawn);
                bBehindView = true;
                ClientSetBehindView(true);
                ClientMessage(OwnCamera, 'Event');
            }
            // End:0x98
            else
            {
                // End:0x7D
                if(ViewTarget == none)
                {
                    Fire();
                }
                // End:0x98
                else
                {
                    bBehindView = !bBehindView;
                    ClientSetBehindView(bBehindView);
                }
            }
        }
    }
    //return;    
}

function TakeShot()
{
    ConsoleCommand((((((((("shot Freon-" $ Left(string(Level), InStr(string(Level), "."))) $ "-") $ string(Level.Month)) $ "-") $ string(Level.Day)) $ "-") $ string(Level.Hour)) $ "-") $ string(Level.Minute));
    bShotTaken = true;
    //return;    
}

state Frozen extends Spectating
{
    exec function AltFire(optional float F)
    {
        ServerViewSelf();
        //return;        
    }
    stop;    
}

defaultproperties
{
    SoundHitVolume=1.0261640
    SoundAloneVolume=1.30
    PlayerReplicationInfoClass=class'Freon_PRI'
}