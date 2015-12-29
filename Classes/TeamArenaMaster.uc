/*******************************************************************************
 * TeamArenaMaster generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class TeamArenaMaster extends Team_GameBase
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force)
    config;

var config bool bDisableTeamCombos;
var config bool bChallengeMode;
var config bool bRandomPickups;
var Misc_PickupBase Bases[3];
var config bool bPureRFF;

function InitGameReplicationInfo()
{
    super.InitGameReplicationInfo();
    // End:0x18
    if(TAM_GRI(GameReplicationInfo) == none)
    {
        return;
    }
    TAM_GRI(GameReplicationInfo).bChallengeMode = bChallengeMode;
    TAM_GRI(GameReplicationInfo).bDisableTeamCombos = bDisableTeamCombos;
    TAM_GRI(GameReplicationInfo).bRandomPickups = bRandomPickups;
    //return;    
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    super.GetServerDetails(ServerState);
    AddServerDetail(ServerState, "Team Combos", string(!bDisableTeamCombos));
    AddServerDetail(ServerState, "Challenge Mode", string(bChallengeMode));
    AddServerDetail(ServerState, "Random Pickups", string(bRandomPickups));
    //return;    
}

static function FillPlayInfo(PlayInfo Pi)
{
    super.FillPlayInfo(Pi);
    Pi.AddSetting("3SPN", "bChallengeMode", "Challenge Mode", 0, 110, "Check");
    Pi.AddSetting("3SPN", "bRandomPickups", "Random Pickups", 0, 176, "Check");
    Pi.AddSetting("3SPN", "bDisableTeamCombos", "No Team Combos", 0, 199, "Check");
    Pi.AddSetting("3SPN", "bPureRFF", "2.57 style RFF", 0, byte(300), "Check");
    //return;    
}

static event string GetDescriptionText(string PropName)
{
    switch(PropName)
    {
        // End:0x47
        case "bChallengeMode":
            return "Round winners take a health/armor penalty.";
        // End:0x95
        case "bDisableTeamCombos":
            return "Turns off team combos. Only the user gets the combo.";
        // End:0x112
        case "bRandomPickups":
            return "Spawns three pickups which give random effect when picked up: Health +10/20, Shield +10/20 or Adren +10";
        // End:0x148
        case "bPureRFF":
            return "All teammate damage is reflected back.";
        // End:0xFFFF
        default:
            return super.GetDescriptionText(PropName);
    }
    //return;    
}

function UnrealTeamInfo GetBlueTeam(int TeamBots)
{
    // End:0x30
    if(BlueTeamName != "")
    {
        BlueTeamName = "3SPNv3210CW.TAM_TeamInfoBlue";
    }
    return super(TeamGame).GetBlueTeam(TeamBots);
    //return;    
}

function UnrealTeamInfo GetRedTeam(int TeamBots)
{
    // End:0x2F
    if(RedTeamName != "")
    {
        RedTeamName = "3SPNv3210CW.TAM_TeamInfoRed";
    }
    return super(TeamGame).GetRedTeam(TeamBots);
    //return;    
}

function ParseOptions(string Options)
{
    local string InOpt;

    super.ParseOptions(Options);
    InOpt = ParseOption(Options, "ChallengeMode");
    // End:0x45
    if(InOpt != "")
    {
        bChallengeMode = bool(InOpt);
    }
    InOpt = ParseOption(Options, "DisableTeamCombos");
    // End:0x83
    if(InOpt != "")
    {
        bDisableTeamCombos = bool(InOpt);
    }
    InOpt = ParseOption(Options, "RandomPickups");
    // End:0xBD
    if(InOpt != "")
    {
        bRandomPickups = bool(InOpt);
    }
    InOpt = ParseOption(Options, "PureRFF");
    // End:0xF1
    if(InOpt != "")
    {
        bPureRFF = bool(InOpt);
    }
    //return;    
}

function SpawnRandomPickupBases()
{
    local int i;
    local float Score[3], Eval;
    local NavigationPoint Best[3], N;

    i = 0;
    J0x07:
    // End:0x1F [Loop If]
    if(i < 100)
    {
        FRand();
        ++ i;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0x26:
    // End:0x1F0 [Loop If]
    if(i < 3)
    {
        N = Level.NavigationPointList;
        J0x46:
        // End:0x1E6 [Loop If]
        if(N != none)
        {
            // End:0x7F
            if((InventorySpot(N) == none) || InventorySpot(N).myPickupBase == none)
            {
            }
            // End:0x1CF
            else
            {
                Eval = 0.0;
                // End:0xA7
                if(i == 0)
                {
                    Eval = FRand() * 5000.0;
                }
                // End:0x143
                else
                {
                    // End:0xEE
                    if(Best[0] != none)
                    {
                        Eval = VSize(Best[0].Location - N.Location) * (0.80 + (FRand() * 1.20));
                    }
                    // End:0x143
                    if((i > 1) && Best[1] != none)
                    {
                        Eval += (VSize(Best[1].Location - N.Location) * (1.50 + (FRand() * 0.50)));
                    }
                }
                // End:0x15F
                if(Best[0] == N)
                {
                    Eval = 0.0;
                }
                // End:0x17B
                if(Best[1] == N)
                {
                    Eval = 0.0;
                }
                // End:0x198
                if(Best[2] == N)
                {
                    Eval = 0.0;
                }
                // End:0x1CF
                if(Score[i] < Eval)
                {
                    Score[i] = Eval;
                    Best[i] = N;
                }
            }
            N = N.nextNavigationPoint;
            // [Loop Continue]
            goto J0x46;
        }
        ++ i;
        // [Loop Continue]
        goto J0x26;
    }
    // End:0x24C
    if(Best[0] != none)
    {
        Bases[0] = Spawn(class'Misc_PickupBase',,, Best[0].Location, Best[0].Rotation);
        Bases[0].myMarker = InventorySpot(Best[0]);
    }
    // End:0x2A8
    if(Best[1] != none)
    {
        Bases[1] = Spawn(class'Misc_PickupBase',,, Best[1].Location, Best[1].Rotation);
        Bases[1].myMarker = InventorySpot(Best[1]);
    }
    // End:0x30A
    if(Best[2] != none)
    {
        Bases[2] = Spawn(class'Misc_PickupBase',,, Best[2].Location, Best[2].Rotation);
        Bases[2].myMarker = InventorySpot(Best[2]);
    }
    //return;    
}

event InitGame(string Options, out string Error)
{
    local Mutator mut;
    local bool bNoAdren;

    bAllowBehindView = true;
    super.InitGame(Options, Error);
    // End:0xA9
    if(bRandomPickups)
    {
        mut = BaseMutator;
        J0x2C:
        // End:0x6D [Loop If]
        if(mut != none)
        {
            // End:0x56
            if(mut.IsA('MutNoAdrenaline'))
            {
                bNoAdren = true;
                // [Explicit Break]
                goto J0x6D;
            }
            mut = mut.NextMutator;
            J0x6D:
            // [Loop Continue]
            goto J0x2C;
        }
        // End:0x8C
        if(bNoAdren)
        {
            class'Misc_PickupBase'.default.PickupClasses[4] = none;
        }
        // End:0xA3
        else
        {
            class'Misc_PickupBase'.default.PickupClasses[4] = class'Misc_PickupAdren';
        }
        SpawnRandomPickupBases();
    }
    AdrenalinePerDamage = 0.750;
    // End:0xC9
    if(bRandomPickups)
    {
        AdrenalinePerDamage -= 0.250;
    }
    // End:0xE0
    if(!bDisableTeamCombos)
    {
        AdrenalinePerDamage += 0.250;
    }
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    super.PostLogin(NewPlayer);
    // End:0x51
    if(bPureRFF && Misc_PRI(NewPlayer.PlayerReplicationInfo) != none)
    {
        Misc_PRI(NewPlayer.PlayerReplicationInfo).ReverseFF = 1.0;
    }
    //return;    
}

function RestartPlayer(Controller C)
{
    local int Team;

    super.RestartPlayer(C);
    // End:0x18
    if(C == none)
    {
        return;
    }
    Team = C.GetTeamNum();
    // End:0x3B
    if(Team == 255)
    {
        return;
    }
    // End:0x9D
    if((TAM_TeamInfo(Teams[Team]) != none) && TAM_TeamInfo(Teams[Team]).ComboManager != none)
    {
        TAM_TeamInfo(Teams[Team]).ComboManager.PlayerSpawned(C);
    }
    // End:0x15E
    else
    {
        // End:0xFF
        if((TAM_TeamInfoRed(Teams[Team]) != none) && TAM_TeamInfoRed(Teams[Team]).ComboManager != none)
        {
            TAM_TeamInfoRed(Teams[Team]).ComboManager.PlayerSpawned(C);
        }
        // End:0x15E
        else
        {
            // End:0x15E
            if((TAM_TeamInfoBlue(Teams[Team]) != none) && TAM_TeamInfoBlue(Teams[Team]).ComboManager != none)
            {
                TAM_TeamInfoBlue(Teams[Team]).ComboManager.PlayerSpawned(C);
            }
        }
    }
    //return;    
}

function SetupPlayer(Pawn P)
{
    local byte difference, Won;
    local int Health, Armor;
    local float formula;

    super.SetupPlayer(P);
    // End:0x222
    if(bChallengeMode)
    {
        difference = byte(Max(0, int(Teams[P.GetTeamNum()].Score - Teams[int(!bool(P.GetTeamNum()))].Score)));
        difference += byte(Max(0, Teams[P.GetTeamNum()].Size - Teams[int(!bool(P.GetTeamNum()))].Size) * 2);
        Won = byte(P.PlayerReplicationInfo.Team.Score);
        // End:0x103
        if(GoalScore > 0)
        {
            formula = 0.250 / float(GoalScore);
        }
        // End:0x10E
        else
        {
            formula = 0.0;
        }
        Health = int(float(StartingHealth) - (((float(StartingHealth) * formula) * float(difference)) + ((float(StartingHealth) * formula) * float(Won))));
        Armor = int(float(StartingArmor) - (((float(StartingArmor) * formula) * float(difference)) + ((float(StartingArmor) * formula) * float(Won))));
        P.Health = Max(40, Health);
        P.HealthMax = float(Health);
        P.SuperHealthMax = float(int(float(Health) * MaxHealth));
        xPawn(P).ShieldStrengthMax = float(Max(0, int(float(Armor) * MaxHealth)));
        P.AddShieldStrength(Max(0, Armor));
    }
    // End:0x236
    else
    {
        P.AddShieldStrength(StartingArmor);
    }
    // End:0x2A3
    if(TAM_TeamInfo(P.PlayerReplicationInfo.Team) != none)
    {
        TAM_TeamInfo(P.PlayerReplicationInfo.Team).StartingHealth = int(float(P.Health) + P.ShieldStrength);
    }
    // End:0x37A
    else
    {
        // End:0x310
        if(TAM_TeamInfoBlue(P.PlayerReplicationInfo.Team) != none)
        {
            TAM_TeamInfoBlue(P.PlayerReplicationInfo.Team).StartingHealth = int(float(P.Health) + P.ShieldStrength);
        }
        // End:0x37A
        else
        {
            // End:0x37A
            if(TAM_TeamInfoRed(P.PlayerReplicationInfo.Team) != none)
            {
                TAM_TeamInfoRed(P.PlayerReplicationInfo.Team).StartingHealth = int(float(P.Health) + P.ShieldStrength);
            }
        }
    }
    //return;    
}

function string SwapDefaultCombo(string ComboName)
{
    // End:0x3D
    if(ComboName ~= "xGame.ComboSpeed")
    {
        return "3SPNv3210CW.Misc_ComboSpeed";
    }
    // End:0x7B
    else
    {
        // End:0x7B
        if(ComboName ~= "xGame.ComboBerserk")
        {
            return "3SPNv3210CW.Misc_ComboBerserk";
        }
    }
    return ComboName;
    //return;    
}

function string RecommendCombo(string ComboName)
{
    local int i;
    local bool bEnabled;

    // End:0x18
    if(EnabledCombos.Length == 0)
    {
        return super(GameInfo).RecommendCombo(ComboName);
    }
    i = 0;
    J0x1F:
    // End:0x59 [Loop If]
    if(i < EnabledCombos.Length)
    {
        // End:0x4F
        if(EnabledCombos[i] ~= ComboName)
        {
            bEnabled = true;
            // [Explicit Break]
            goto J0x59;
        }
        ++ i;
        J0x59:
        // [Loop Continue]
        goto J0x1F;
    }
    // End:0x78
    if(!bEnabled)
    {
        ComboName = EnabledCombos[Rand(EnabledCombos.Length)];
    }
    return SwapDefaultCombo(ComboName);
    //return;    
}

function StartNewRound()
{
    // End:0x51
    if((TAM_TeamInfo(Teams[0]) != none) && TAM_TeamInfo(Teams[0]).ComboManager != none)
    {
        TAM_TeamInfo(Teams[0]).ComboManager.ClearData();
    }
    // End:0x9F
    else
    {
        // End:0x9F
        if((TAM_TeamInfoRed(Teams[0]) != none) && TAM_TeamInfoRed(Teams[0]).ComboManager != none)
        {
            TAM_TeamInfoRed(Teams[0]).ComboManager.ClearData();
        }
    }
    // End:0xF0
    if((TAM_TeamInfo(Teams[1]) != none) && TAM_TeamInfo(Teams[1]).ComboManager != none)
    {
        TAM_TeamInfo(Teams[1]).ComboManager.ClearData();
    }
    // End:0x13E
    else
    {
        // End:0x13E
        if((TAM_TeamInfoBlue(Teams[1]) != none) && TAM_TeamInfoBlue(Teams[1]).ComboManager != none)
        {
            TAM_TeamInfoBlue(Teams[1]).ComboManager.ClearData();
        }
    }
    super.StartNewRound();
    //return;    
}

defaultproperties
{
    bDisableTeamCombos=true
    StartingArmor=100
    MaxHealth=1.250
    bForceRespawn=true
    MapListType="3SPNv3210CW.MapListTeamArenaMaster"
    MaxLives=1
    GameReplicationInfoClass=class'TAM_GRI'
    GameName="Team ArenaMaster v3"
    Acronym="TAM"
}