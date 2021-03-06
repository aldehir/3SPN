class Freon_Player extends Misc_Player;

var Freon_Pawn FrozenPawn;

replication
{
    reliable if(Role == ROLE_Authority)
        ClientSendStatsFreon, ClientListBestFreon;
}

exec function SwitchTeam()
{
	super.SwitchTeam();
	if(FrozenPawn != None && FrozenPawn.MyTrigger != None)
	{
		FrozenPawn.MyTrigger.Team = GetTeamNum();
		FrozenPawn.MyTrigger.Toucher.Length = 0;
	}
}

exec function ChangeTeam(int N)
{
	super.ChangeTeam(N);
	if(FrozenPawn != None && FrozenPawn.MyTrigger != None)
	{
		FrozenPawn.MyTrigger.Team = GetTeamNum();
		FrozenPawn.MyTrigger.Toucher.Length = 0;
	}
}

function ServerUpdateStatArrays(TeamPlayerReplicationInfo PRI)
{
    local Freon_PRI P;

	if(PRI!=None)
		Super.ServerUpdateStatArrays(PRI);

    P = Freon_PRI(PRI);
    if(P == None)
        return;

    ClientSendStatsFreon(P, P.Thaws, P.Git);
}

function ClientSendStatsFreon(Freon_PRI P, int thaws, int git)
{
    P.Thaws = thaws;
    P.Git = git;
}

function ClientListBestFreon(string acc, string dam, string hs, string th, string gt)
{
	Super.ClientListBest(acc, dam, hs);

    if(class'Misc_Player'.default.bDisableAnnouncement)
        return;
	
    if(th != "")
        ClientMessage(th);
    if(gt != "")
        ClientMessage(gt);
}

function AwardAdrenaline(float amount)
{
    amount *= 0.8;
    Super.AwardAdrenaline(amount);
}

simulated event Destroyed()
{
    if(FrozenPawn != None)
        FrozenPawn.Died(self, class'Suicided', FrozenPawn.Location);

    Super.Destroyed();
}

function BecomeSpectator()
{
    if(FrozenPawn != None)
        FrozenPawn.Died(self, class'DamageType', FrozenPawn.Location);

    Super.BecomeSpectator();
}

function ServerDoCombo(class<Combo> ComboClass)
{
    if(class<ComboSpeed>(ComboClass) != None)
        ComboClass = class<Combo>(DynamicLoadObject("3SPNv3300CW.Freon_ComboSpeed", class'Class'));

    Super.ServerDoCombo(ComboClass);
}

function Reset()
{
    Super.Reset();
    FrozenPawn = None;
}

function Freeze()
{
    if(Pawn == None)
        return;

    FrozenPawn = Freon_Pawn(Pawn);

    bBehindView = true;
    LastKillTime = -5.0;
    EndZoom();

    Pawn.RemoteRole = ROLE_SimulatedProxy;

    Pawn = None;
    PendingMover = None;
	
	NextRezTime = Level.TimeSeconds+1; // 1 second before can be resurrected

    if(!IsInState('GameEnded') && !IsInState('RoundEnded'))
    {
        ServerViewSelf();
        GotoState('Frozen');
    }
}

function ServerViewNextPlayer()
{
    local Controller C, Pick;
    local bool bFound, bRealSpec, bWasSpec;
	local TeamInfo RealTeam;

    bRealSpec = PlayerReplicationInfo.bOnlySpectator;
    bWasSpec = (ViewTarget != FrozenPawn) && (ViewTarget != Pawn) && (ViewTarget != self);
    PlayerReplicationInfo.bOnlySpectator = true;
    RealTeam = PlayerReplicationInfo.Team;

    // view next player
    for ( C=Level.ControllerList; C!=None; C=C.NextController )
    {
		if ( bRealSpec && (C.PlayerReplicationInfo != None) ) // hack fix for invasion spectating
			PlayerReplicationInfo.Team = C.PlayerReplicationInfo.Team;
        if ( Level.Game.CanSpectate(self,bRealSpec,C) )
        {
            if ( Pick == None )
                Pick = C;
            if ( bFound )
            {
                Pick = C;
                break;
            }
            else
                bFound = ( (RealViewTarget == C) || (ViewTarget == C) );
        }
    }
    PlayerReplicationInfo.Team = RealTeam;
    SetViewTarget(Pick);
    ClientSetViewTarget(Pick);

    if(!bWasSpec)
        bBehindView = false;

    ClientSetBehindView(bBehindView);
    PlayerReplicationInfo.bOnlySpectator = bRealSpec;
}

function ServerViewSelf()
{
    if(PlayerReplicationInfo != None)
    {
        if(PlayerReplicationInfo.bOnlySpectator)
            Super.ServerViewSelf();
        else if(FrozenPawn != None)
        {
            SetViewTarget(FrozenPawn);
            ClientSetViewTarget(FrozenPawn);
            bBehindView = true;
            ClientSetBehindView(true);
            ClientMessage(OwnCamera, 'Event');
        }
        else
        {
            if(ViewTarget == None)
                Fire();
            else
            {
                bBehindView = !bBehindView;
                ClientSetBehindView(bBehindView);
            }
        }
    }
}

state Frozen extends Spectating
{
    exec function AltFire(optional float f)
    {
        ServerViewSelf();
    }
}

function TakeShot()
{
    ConsoleCommand("shot Freon-"$Left(string(Level), InStr(string(Level), "."))$"-"$Level.Month$"-"$Level.Day$"-"$Level.Hour$"-"$Level.Minute);
    bShotTaken = true;
}

defaultproperties
{
     SoundHitVolume=1.026164
     SoundAloneVolume=1.300000
     CurrentSelectedColoredName=0
     colorname(0)=(B=147,G=22,R=155)
     colorname(1)=(B=160,G=41,R=167)
     colorname(2)=(B=173,G=59,R=179)
     colorname(3)=(B=187,G=78,R=190)
     colorname(4)=(B=200,G=96,R=202)
     colorname(5)=(B=213,G=115,R=214)
     colorname(6)=(B=255,G=255,R=255,A=255)
     colorname(7)=(B=255,G=255,R=255,A=255)
     colorname(8)=(B=255,G=255,R=255,A=255)
     colorname(9)=(B=255,G=255,R=255,A=255)
     colorname(10)=(B=255,G=255,R=255,A=255)
     colorname(11)=(B=255,G=255,R=255,A=255)
     colorname(12)=(B=255,G=255,R=255,A=255)
     colorname(13)=(B=255,G=255,R=255,A=255)
     colorname(14)=(B=255,G=255,R=255,A=255)
     colorname(15)=(B=255,G=255,R=255,A=255)
     colorname(16)=(B=255,G=255,R=255,A=255)
     colorname(17)=(B=255,G=255,R=255,A=255)
     colorname(18)=(B=255,G=255,R=255,A=255)
     colorname(19)=(B=255,G=255,R=255,A=255)
     PlayerReplicationInfoClass=Class'3SPNv3300CW.Freon_PRI'
}
