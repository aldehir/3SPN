/*******************************************************************************
 * TAM_Scoreboard generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class TAM_Scoreboard extends ScoreBoardTeamDeathMatch
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force)
    config;

var int LastUpdateTime;
var Texture Box;
var Texture BaseTex;
var Texture ShieldTexture;
var Texture DefaultShieldTexture;
var Texture FlagTexture;
var Texture DefaultFlagTexture;
var Texture RankTex[30];
var byte BaseAlpha;
var int MaxTeamSize;
var int MaxTeamPlayers;
var int MaxSpectators;
var config bool bEnableColoredNamesOnScoreboard;
var config bool bEnableColoredNamesOnHUD;

simulated function SetCustomBarColor(out Color C, PlayerReplicationInfo PRI, bool bOwner)
{
    //return;    
}

simulated function SetCustomLocationColor(out Color C, PlayerReplicationInfo PRI, bool bOwner)
{
    //return;    
}

simulated function DrawRank(Canvas C, int X, int Y, int W, int H, float Rank)
{
    local int i;

    C.DrawColor = HudClass.default.WhiteColor;
    C.DrawColor.A = BaseAlpha;
    i = int(FClamp(Rank, 0.0, 1.0) * float(30 - 1));
    C.SetPos(float(X), float(Y));
    C.DrawTile(RankTex[i], float(W), float(H), 0.0, 0.0, 64.0, 64.0);
    //return;    
}

simulated function DrawHeader(Canvas C, int BarX, int BarY, int BarW, int BarH)
{
    local float XL, YL;
    local string Name;
    local int TitleX, TitleY, SubTitleX, SubTitleY, URLX, URLY,
	    DateTimeX, DateTimeY;

    TitleX = int(C.ClipX * 0.010);
    TitleY = int(C.ClipY * 0.010);
    SubTitleX = int(C.ClipX * 0.010);
    SubTitleY = int(C.ClipY * 0.040);
    URLX = int(C.ClipX * 0.990);
    URLY = int(C.ClipY * 0.010);
    DateTimeX = int(C.ClipX * 0.990);
    DateTimeY = int(C.ClipY * 0.040);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -1);
    C.DrawColor = HudClass.default.BlackColor;
    C.DrawColor.A = BaseAlpha;
    C.SetPos(float(BarX), float(BarY));
    C.DrawTile(Box, float(BarW), float(BarH), 0.0, 0.0, 16.0, 16.0);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    Name = (GRI.GameName $ MapName) $ Level.Title;
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + TitleX), float(BarY + TitleY));
    C.DrawText(Name);
    // End:0x279
    if(UnrealPlayer(Owner).bDisplayLoser)
    {
        Name = class'HudBase'.default.YouveLostTheMatch;
    }
    // End:0x339
    else
    {
        // End:0x2A7
        if(UnrealPlayer(Owner).bDisplayWinner)
        {
            Name = class'HudBase'.default.YouveWonTheMatch;
        }
        // End:0x339
        else
        {
            Name = FragLimit @ string(GRI.GoalScore);
            // End:0x30A
            if(GRI.TimeLimit != 0)
            {
                Name = ((Name @ Spacer) @ TimeLimit) @ (FormatTime(GRI.RemainingTime));
            }
            // End:0x339
            else
            {
                Name = ((Name @ Spacer) @ FooterText) @ (FormatTime(GRI.ElapsedTime));
            }
        }
    }
    C.DrawColor = HudClass.default.RedColor * 0.70;
    C.DrawColor.G = 130;
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + SubTitleX), float(BarY + SubTitleY));
    C.DrawText(Name);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    Name = "www.combowhore.com";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + URLX) - XL, float(BarY + URLY));
    C.DrawText(Name);
    Name = "";
    // End:0x48E
    if(Level.Month < 10)
    {
        Name = "0";
    }
    Name = (Name $ string(Level.Month)) $ "/";
    // End:0x4D5
    if(Level.Day < 10)
    {
        Name = Name $ "0";
    }
    Name = (((Name $ string(Level.Day)) $ "/") $ string(Level.Year)) @ "- ";
    // End:0x534
    if(Level.Hour < 10)
    {
        Name = Name $ "0";
    }
    Name = (Name $ string(Level.Hour)) $ ":";
    // End:0x57B
    if(Level.Minute < 10)
    {
        Name = Name $ "0";
    }
    Name = (Name $ string(Level.Minute)) $ ":";
    // End:0x5C2
    if(Level.Second < 10)
    {
        Name = Name $ "0";
    }
    Name = Name $ string(Level.Second);
    C.DrawColor = HudClass.default.RedColor * 0.70;
    C.DrawColor.G = 130;
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + DateTimeX) - XL, float(BarY + DateTimeY));
    C.DrawText(Name);
    //return;    
}

simulated function DrawRoundTime(Canvas C, int BoxX, int BoxY)
{
    local string Name;
    local float XL, YL;

    // End:0x1B
    if(Misc_BaseGRI(GRI).MinsPerRound == 0)
    {
        return;
    }
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, 0);
    Name = FormatTime(Misc_BaseGRI(GRI).RoundTime);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BoxX) - (XL * 0.50), float(BoxY) - (YL * 0.50));
    C.DrawText(Name);
    //return;    
}

simulated function DrawTeamScores(Canvas C, int BoxX, int BoxY, int BoxW, int BoxH, string GameName, string Acronym, int RedScore, int BlueScore)
{
    local int RedScoreX, RedScoreY, BlueScoreX, BlueScoreY, SeparatorX, SeparatorY,
	    GameNameX, GameNameW, GameNameY, AcronymX, AcronymW,
	    AcronymY;

    local string Name;
    local float XL, YL, W, H;

    RedScoreX = int(float(BoxW) * 0.30);
    RedScoreY = int(float(BoxH) * 0.470);
    BlueScoreX = int(float(BoxW) * 0.70);
    BlueScoreY = int(float(BoxH) * 0.470);
    SeparatorX = int(float(BoxW) * 0.50);
    SeparatorY = int(float(BoxH) * 0.470);
    GameNameX = int(float(BoxW) * 0.50);
    GameNameW = int(float(BoxW) * 0.710);
    GameNameY = int(float(BoxH) * 0.2050);
    AcronymX = int(float(BoxW) * 0.50);
    AcronymW = int(float(BoxW) * 0.5760);
    AcronymY = int(float(BoxH) * 0.8350);
    C.DrawColor = HudClass.default.WhiteColor;
    C.DrawColor.A = BaseAlpha;
    // End:0x274
    if(Misc_BaseGRI(GRI).FlagTextureEnabled)
    {
        // End:0x1BB
        if(FlagTexture == none)
        {
            // End:0x1A5
            if(Len(Misc_BaseGRI(GRI).FlagTextureName) > 0)
            {
                FlagTexture = Texture(DynamicLoadObject(Misc_BaseGRI(GRI).FlagTextureName, class'Texture', true));
            }
            // End:0x1BB
            if(FlagTexture == none)
            {
                FlagTexture = DefaultFlagTexture;
            }
        }
        XL = float(BoxX + ((BoxW * 207) / 512));
        YL = float(BoxY + ((BoxH * 350) / 512));
        W = float((BoxW * 100) / 512);
        H = float((BoxH * 127) / 512);
        C.SetPos(XL, YL);
        C.DrawTile(FlagTexture, W, H, 0.0, 0.0, 128.0, 128.0);
    }
    // End:0x2DA
    if(ShieldTexture == none)
    {
        // End:0x2C4
        if(Len(Misc_BaseGRI(GRI).ShieldTextureName) > 0)
        {
            ShieldTexture = Texture(DynamicLoadObject(Misc_BaseGRI(GRI).ShieldTextureName, class'Texture', true));
        }
        // End:0x2DA
        if(ShieldTexture == none)
        {
            ShieldTexture = DefaultShieldTexture;
        }
    }
    C.SetPos(float(BoxX), float(BoxY));
    C.DrawTile(ShieldTexture, float(BoxW), float(BoxH), 0.0, 0.0, 512.0, 512.0);
    // End:0x47F
    if(Misc_BaseGRI(GRI).ShowServerName)
    {
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -4);
        C.DrawColor = HudClass.default.WhiteColor;
        C.DrawColor.A = BaseAlpha;
        Name = GameName;
        C.StrLen(Name, XL, YL);
        // End:0x427
        if(XL > float(GameNameW))
        {
            Name = Left(Name, int((float(GameNameW) / XL) * float(Len(Name))));
            C.StrLen(Name, XL, YL);
        }
        C.SetPos(float(BoxX + GameNameX) - (XL * 0.50), float(BoxY + GameNameY) - (YL * 0.50));
        C.DrawText(Name);
    }
    // End:0x5D4
    if(Misc_BaseGRI(GRI).FlagTextureShowAcronym)
    {
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -5);
        C.DrawColor = HudClass.default.RedColor;
        C.DrawColor.A = BaseAlpha;
        Name = Acronym;
        C.StrLen(Name, XL, YL);
        // End:0x57C
        if(XL > float(AcronymW))
        {
            Name = Left(Name, int((float(AcronymW) / XL) * float(Len(Name))));
            C.StrLen(Name, XL, YL);
        }
        C.SetPos(float(BoxX + AcronymX) - (XL * 0.50), float(BoxY + AcronymY) - (YL * 0.50));
        C.DrawText(Name);
    }
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -1);
    C.DrawColor = HudClass.default.WhiteColor;
    Name = "-";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BoxX + SeparatorX) - (XL * 0.50), float(BoxY + SeparatorY) - (YL * 0.50));
    C.DrawText(Name);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, 1);
    C.DrawColor = HudClass.default.RedColor * 0.70;
    Name = string(RedScore);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BoxX + RedScoreX) - (XL * 0.50), float(BoxY + RedScoreY) - (YL * 0.50));
    C.DrawText(Name);
    C.DrawColor = HudClass.default.TurqColor * 0.70;
    Name = string(BlueScore);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BoxX + BlueScoreX) - (XL * 0.50), float(BoxY + BlueScoreY) - (YL * 0.50));
    C.DrawText(Name);
    //return;    
}

simulated function DrawLabelsBar(Canvas C, int BarX, int BarY, int BarW, int BarH, Color BackgroundCol)
{
    local int NameX, NameY, StatX, StatY, RankX, RankY,
	    AvgPPRX, AvgPPRY, ScoreX, ScoreY, PointsPerX,
	    PointsPerY, KillsX, KillsY, DeathsX, DeathsY,
	    PingX, PingY, PLX, PLY;

    local float XL, YL;
    local string Name;

    NameX = int(float(BarW) * 0.0310);
    NameY = int(C.ClipY * 0.010);
    StatX = int(float(BarW) * 0.0510);
    StatY = int(C.ClipY * 0.0350);
    ScoreX = int(float(BarW) * 0.590);
    ScoreY = int(C.ClipY * 0.010);
    PointsPerX = int(float(BarW) * 0.590);
    PointsPerY = int(C.ClipY * 0.0350);
    KillsX = int(float(BarW) * 0.710);
    KillsY = int(C.ClipY * 0.010);
    DeathsX = int(float(BarW) * 0.710);
    DeathsY = int(C.ClipY * 0.0350);
    PingX = int(float(BarW) * 0.820);
    PingY = int(C.ClipY * 0.010);
    PLX = int(float(BarW) * 0.820);
    PLY = int(C.ClipY * 0.0350);
    RankX = int(float(BarW) * 0.930);
    RankY = int(C.ClipY * 0.010);
    AvgPPRX = int(float(BarW) * 0.930);
    AvgPPRY = int(C.ClipY * 0.0350);
    C.DrawColor = BackgroundCol;
    C.DrawColor.A = BaseAlpha;
    C.SetPos(float(BarX), float(BarY));
    C.DrawTile(BaseTex, float(BarW), float(BarH), 17.0, 31.0, 751.0, 71.0);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    C.SetPos(float(BarX + NameX), float(BarY + NameY));
    C.DrawText("Name", true);
    C.DrawColor = HudClass.default.RedColor * 0.70;
    C.DrawColor.G = 130;
    Name = "Location";
    C.SetPos(float(BarX + StatX), float(BarY + StatY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    Name = "Rank";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + RankX) - (XL * 0.50), float(BarY + RankY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -3);
    C.DrawColor = HudClass.default.WhiteColor * 0.550;
    Name = "Avg PPR";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + AvgPPRX) - (XL * 0.50), float(BarY + AvgPPRY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    Name = "Score";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + ScoreX) - (XL * 0.50), float(BarY + ScoreY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -3);
    C.DrawColor = HudClass.default.WhiteColor * 0.550;
    Name = "PPR";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + PointsPerX) - (XL * 0.50), float(BarY + PointsPerY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    Name = "Kills";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + KillsX) - (XL * 0.50), float(BarY + KillsY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -3);
    C.DrawColor.R = 170;
    C.DrawColor.G = 20;
    C.DrawColor.B = 20;
    Name = "Deaths";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + DeathsX) - (XL * 0.50), float(BarY + DeathsY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.CyanColor * 0.50;
    C.DrawColor.B = 150;
    C.DrawColor.R = 20;
    Name = "Ping";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + PingX) - (XL * 0.50), float(BarY + PingY));
    C.DrawText(Name, true);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -3);
    Name = "P/L";
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + PLX) - (XL * 0.50), float(BarY + PLY));
    C.DrawText(Name, true);
    //return;    
}

simulated function DrawPlayerBar(Canvas C, int BarX, int BarY, int BarW, int BarH, PlayerReplicationInfo PRI)
{
    local int NameX, NameY, NameW, StatX, StatY, RankX,
	    RankY, RankW, RankH, AvgPPRX, AvgPPRY,
	    ScoreX, ScoreY, PointsPerX, PointsPerY, KillsX,
	    KillsY, DeathsX, DeathsY, PingX, PingY,
	    PLX, PLY;

    local string Name;
    local float XL, YL;
    local Misc_PRI OwnerPRI;
    local int OwnerTeam;

    OwnerPRI = Misc_PRI(PlayerController(Owner).PlayerReplicationInfo);
    // End:0x52
    if(OwnerPRI.Team != none)
    {
        OwnerTeam = OwnerPRI.Team.TeamIndex;
    }
    // End:0x5A
    else
    {
        OwnerTeam = 255;
    }
    NameX = int(float(BarW) * 0.0310);
    NameY = int(C.ClipY * 0.00750);
    NameW = int(float(BarW) * 0.470);
    StatX = int(float(BarW) * 0.0510);
    StatY = int(C.ClipY * 0.0350);
    ScoreX = int(float(BarW) * 0.590);
    ScoreY = int(C.ClipY * 0.00750);
    PointsPerX = int(float(BarW) * 0.590);
    PointsPerY = int(C.ClipY * 0.0350);
    KillsX = int(float(BarW) * 0.710);
    KillsY = int(C.ClipY * 0.00750);
    DeathsX = int(float(BarW) * 0.710);
    DeathsY = int(C.ClipY * 0.0350);
    PingX = int(float(BarW) * 0.820);
    PingY = int(C.ClipY * 0.00750);
    PLX = int(float(BarW) * 0.820);
    PLY = int(C.ClipY * 0.0350);
    RankX = int(float(BarW) * 0.930);
    RankY = int(C.ClipY * 0.00750);
    AvgPPRX = int(float(BarW) * 0.930);
    AvgPPRY = int(C.ClipY * 0.0350);
    RankW = int((C.ClipX * 32.0) / 1920.0);
    RankH = int((C.ClipY * 32.0) / 1080.0);
    C.SetPos(float(BarX), float(BarY));
    C.DrawTile(BaseTex, float(BarW), float(BarH), 18.0, 107.0, 745.0, 81.0);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    // End:0x38A
    if(PRI.bOutOfLives)
    {
        Name = PRI.PlayerName;
        C.DrawColor = HudClass.default.WhiteColor * 0.40;
    }
    // End:0x418
    else
    {
        // End:0x3DF
        if((default.bEnableColoredNamesOnScoreboard && Misc_PRI(PRI) != none) && Misc_PRI(PRI).GetColoredName() != "")
        {
            Name = Misc_PRI(PRI).GetColoredName();
        }
        // End:0x3F3
        else
        {
            Name = PRI.PlayerName;
        }
        C.DrawColor = HudClass.default.WhiteColor * 0.70;
    }
    C.SetPos(float(BarX + NameX), float(BarY + NameY));
    class'Misc_Util'.static.DrawTextClipped(C, Name, float(NameW));
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -4);
    // End:0x583
    if(!GRI.bMatchHasBegun)
    {
        // End:0x4CD
        if(PRI.bReadyToPlay)
        {
            Name = ReadyText;
        }
        // End:0x4D8
        else
        {
            Name = NotReadyText;
        }
        // End:0x545
        if(PRI.bAdmin)
        {
            Name = "Admin -" @ Name;
            C.DrawColor.R = 170;
            C.DrawColor.G = 20;
            C.DrawColor.B = 20;
        }
        // End:0x580
        else
        {
            C.DrawColor = HudClass.default.RedColor * 0.70;
            C.DrawColor.G = 130;
        }
    }
    // End:0x7A9
    else
    {
        // End:0x75A
        if(!PRI.bAdmin)
        {
            // End:0x677
            if(!PRI.bOutOfLives)
            {
                C.DrawColor = HudClass.default.RedColor * 0.70;
                C.DrawColor.G = 130;
                // End:0x660
                if((PRI.Team.TeamIndex == OwnerTeam) || OwnerPRI.bOnlySpectator)
                {
                    // End:0x648
                    if(Freon_PRI(PRI) != none)
                    {
                        Name = Freon_PRI(PRI).GetLocationNameTeam();
                    }
                    // End:0x65D
                    else
                    {
                        Name = PRI.GetLocationName();
                    }
                }
                // End:0x674
                else
                {
                    Name = PRI.StringUnknown;
                }
            }
            // End:0x732
            else
            {
                C.DrawColor.R = 170;
                C.DrawColor.G = 20;
                C.DrawColor.B = 20;
                // End:0x71D
                if(((PRI.Team.TeamIndex == OwnerTeam) || OwnerPRI.bOnlySpectator) && Freon_PRI(PRI) != none)
                {
                    Name = Freon_PRI(PRI).GetLocationNameTeam();
                }
                // End:0x732
                else
                {
                    Name = PRI.GetLocationName();
                }
            }
            SetCustomLocationColor(C.DrawColor, PRI, PRI == OwnerPRI);
        }
        // End:0x7A9
        else
        {
            C.DrawColor.R = 170;
            C.DrawColor.G = 20;
            C.DrawColor.B = 20;
            Name = "Admin";
        }
    }
    C.StrLen(Name, XL, YL);
    // End:0x7FD
    if(XL > float(NameW))
    {
        Name = Left(Name, int((float(NameW) / XL) * float(Len(Name))));
    }
    C.SetPos(float(BarX + StatX), float(BarY + StatY));
    C.DrawText(Name);
    DrawRank(C, (BarX + RankX) - (RankW / 2), BarY + RankY, RankW, RankH, Misc_PRI(PRI).Rank);
    // End:0x987
    if(Misc_PRI(PRI).AvgPPR != float(0))
    {
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -4);
        C.DrawColor = HudClass.default.WhiteColor * 0.550;
        Name = class'Misc_PRI'.static.GetFormattedPPR(Misc_PRI(PRI).AvgPPR);
        C.StrLen(Name, XL, YL);
        C.SetPos(float(BarX + AvgPPRX) - (XL * 0.50), float(BarY + AvgPPRY));
        C.DrawText(Name);
    }
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    Name = string(int(PRI.Score));
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + ScoreX) - (XL * 0.50), float(BarY + ScoreY));
    C.DrawText(Name);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -4);
    C.DrawColor = HudClass.default.WhiteColor * 0.550;
    // End:0xB01
    if(Misc_PRI(PRI).PlayedRounds > 0)
    {
        XL = PRI.Score / float(Misc_PRI(PRI).PlayedRounds);
    }
    // End:0xB15
    else
    {
        XL = PRI.Score;
    }
    Name = class'Misc_PRI'.static.GetFormattedPPR(XL);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + PointsPerX) - (XL * 0.50), float(BarY + PointsPerY));
    C.DrawText(Name);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    Name = string(PRI.Kills);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + KillsX) - (XL * 0.50), float(BarY + KillsY));
    C.DrawText(Name);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -4);
    C.DrawColor.R = 170;
    C.DrawColor.G = 20;
    C.DrawColor.B = 20;
    Name = string(int(PRI.Deaths));
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + DeathsX) - (XL * 0.50), float(BarY + DeathsY));
    C.DrawText(Name);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.CyanColor * 0.50;
    C.DrawColor.B = 150;
    C.DrawColor.R = 20;
    Name = string(Min(999, PRI.Ping * 4));
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + PingX) - (XL * 0.50), float(BarY + PingY));
    C.DrawText(Name);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -4);
    C.DrawColor = HudClass.default.CyanColor * 0.50;
    C.DrawColor.B = 150;
    C.DrawColor.R = 20;
    Name = string(PRI.PacketLoss);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + PLX) - (XL * 0.50), float(BarY + PLY));
    C.DrawText(Name);
    //return;    
}

simulated function DrawPlayerTotalsBar(Canvas C, int BarX, int BarY, int BarW, int BarH, string TeamName, Color BackgroundCol, int Score, int Kills, int Ping, float PPR)
{
    local int NameX, NameY, ScoreX, ScoreY, KillsX, KillsY,
	    PingX, PingY, PPRX, PPRY;

    local string Name;
    local float XL, YL;

    NameX = int(float(BarW) * 0.0310);
    NameY = int(C.ClipY * 0.00750);
    ScoreX = int(float(BarW) * 0.590);
    ScoreY = int(C.ClipY * 0.00750);
    KillsX = int(float(BarW) * 0.710);
    KillsY = int(C.ClipY * 0.00750);
    PingX = int(float(BarW) * 0.820);
    PingY = int(C.ClipY * 0.00750);
    PPRX = int(float(BarW) * 0.930);
    PPRY = int(C.ClipY * 0.00750);
    C.DrawColor = BackgroundCol;
    C.DrawColor.A = 200;
    C.SetPos(float(BarX), float(BarY));
    C.DrawTile(BaseTex, float(BarW), float(BarH), 18.0, 107.0, 745.0, 81.0);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -2);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    C.SetPos(float(BarX + NameX), float(BarY + NameY));
    C.DrawText(TeamName);
    Name = string(Score);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + ScoreX) - (XL * 0.50), float(BarY + ScoreY));
    C.DrawText(Name);
    Name = string(Kills);
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + KillsX) - (XL * 0.50), float(BarY + KillsY));
    C.DrawText(Name);
    C.DrawColor = HudClass.default.CyanColor * 0.50;
    C.DrawColor.B = 150;
    C.DrawColor.R = 20;
    Name = string(Min(999, Ping * 4));
    C.StrLen(Name, XL, YL);
    C.SetPos(float(BarX + PingX) - (XL * 0.50), float(BarY + PingY));
    C.DrawText(Name);
    // End:0x4AA
    if(PPR != float(0))
    {
        C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -4);
        C.DrawColor = HudClass.default.WhiteColor * 0.550;
        Name = string(PPR);
        C.StrLen(Name, XL, YL);
        C.SetPos(float(BarX + PPRX) - (XL * 0.50), float(BarY + PPRY) + (YL * 0.250));
        C.DrawText(Name);
    }
    //return;    
}

simulated function DrawSpecList(Canvas C, int BoxX, int BoxY, int BoxW, array<PlayerReplicationInfo> Specs)
{
    local float XL, YL, YL2;
    local int TitleX, TitleY, PingX, PingY, TitleSeparatorH, EndSeparatorH,
	    NameX, NameY, BoxH;

    local string Name;
    local int i;
    local PlayerReplicationInfo PRI;
    local string NameColor, PingColor;

    TitleX = int(float(BoxW) * 0.0310);
    TitleY = int(C.ClipY * 0.0050);
    PingX = int(float(BoxW) * 0.850);
    PingY = int(C.ClipY * 0.0050);
    NameX = int(float(BoxW) * 0.0930);
    TitleSeparatorH = int(C.ClipY * 0.00250);
    EndSeparatorH = int(C.ClipY * 0.0050);
    C.Font = PlayerController(Owner).myHUD.GetFontSizeIndex(C, -5);
    Name = "Spectator";
    C.StrLen(Name, XL, YL);
    BoxH = int((((YL * float(Min(MaxSpectators, Specs.Length) + 1)) + float(TitleY)) + float(TitleSeparatorH * 2)) + float(EndSeparatorH));
    BoxY -= BoxH;
    C.DrawColor = HudClass.default.WhiteColor;
    C.DrawColor.A = BaseAlpha;
    C.SetPos(float(BoxX), float(BoxY));
    C.DrawTile(BaseTex, float(BoxW), (float(TitleY) + YL) + float(TitleSeparatorH), 17.0, 31.0, 751.0, 71.0);
    C.DrawColor = HudClass.default.BlackColor;
    C.DrawColor.A = byte(float(BaseAlpha) * 0.50);
    C.SetPos(float(BoxX), (float(BoxY + TitleY) + YL) + float(TitleSeparatorH));
    C.DrawTile(Box, float(BoxW), float(BoxH) - ((float(TitleY) + YL) + float(TitleSeparatorH)), 0.0, 0.0, 16.0, 16.0);
    C.DrawColor = HudClass.default.WhiteColor * 0.70;
    C.SetPos(float(BoxX + TitleX), float(BoxY + TitleY));
    C.DrawText(Name);
    Name = "Ping";
    C.StrLen(Name, XL, YL2);
    C.SetPos(float(BoxX + PingX) - (XL * 0.50), float(BoxY + PingY));
    C.DrawText(Name);
    NameColor = class'DMStatsScreen'.static.MakeColorCode(class'Canvas'.static.MakeColor(178, 130, 0));
    PingColor = class'DMStatsScreen'.static.MakeColorCode(class'Canvas'.static.MakeColor(20, 127, 150));
    NameY = int((float(TitleY) + YL) + float(TitleSeparatorH * 2));
    i = 0;
    J0x40B:
    // End:0x5AD [Loop If]
    if(i < Specs.Length)
    {
        PRI = Specs[i];
        // End:0x488
        if((default.bEnableColoredNamesOnScoreboard && Misc_PRI(PRI) != none) && Misc_PRI(PRI).GetColoredName() != "")
        {
            Name = NameColor $ Misc_PRI(PRI).GetColoredName();
        }
        // End:0x4A3
        else
        {
            Name = NameColor $ PRI.PlayerName;
        }
        C.SetPos(float(BoxX + NameX), float(BoxY + NameY));
        class'Misc_Util'.static.DrawTextClipped(C, Name, float((PingX - (BoxW - PingX)) - NameX));
        Name = ((PingColor $ "[") $ string(PRI.Ping * 4)) $ "]";
        C.StrLen(Name, XL, YL2);
        C.SetPos(float(BoxX + PingX) - (XL * 0.50), float(BoxY + NameY));
        C.DrawText(Name);
        NameY += int(YL);
        ++ i;
        // [Loop Continue]
        goto J0x40B;
    }
    //return;    
}

simulated function DrawTeamBoard(Canvas C, int BoxX, int BoxY, int BoxW, string TeamName, Color TeamCol, array<PlayerReplicationInfo> Players, int MaxPlayers)
{
    local int i;
    local PlayerReplicationInfo PRI, OwnerPRI;
    local int BarX, BarY, BoxH, LabelsBarX, LabelsBarY, LabelsBarW,
	    LabelsBarH, PlayerBoxX, PlayerBoxY, PlayerBoxW, PlayerBoxH,
	    PlayerBoxSeparatorH, PlayerTotalsW, playerTotalsH, TeamScore, TeamKills,
	    TeamPing;

    local float TeamAvgPPR;
    local int NumPPR;

    OwnerPRI = PlayerController(Owner).PlayerReplicationInfo;
    LabelsBarX = 0;
    LabelsBarY = 0;
    LabelsBarW = BoxW;
    LabelsBarH = int(C.ClipY * 0.070);
    PlayerBoxX = 0;
    PlayerBoxY = LabelsBarY + LabelsBarH;
    PlayerBoxW = BoxW;
    PlayerBoxH = int(C.ClipY * 0.060);
    PlayerBoxSeparatorH = int(C.ClipY * 0.0);
    PlayerTotalsW = BoxW;
    playerTotalsH = int(C.ClipY * 0.040);
    BoxH = PlayerBoxY + ((PlayerBoxH + PlayerBoxSeparatorH) * MaxPlayers);
    // End:0x10D
    if(MaxPlayers >= 2)
    {
        BoxH += playerTotalsH;
    }
    BoxY = int((C.ClipY * 0.50) - (float(BoxH) * 0.50));
    NumPPR = 0;
    DrawLabelsBar(C, BoxX + LabelsBarX, BoxY + LabelsBarY, LabelsBarW, LabelsBarH, TeamCol);
    i = 0;
    J0x17A:
    // End:0x338 [Loop If]
    if(i < Players.Length)
    {
        PRI = Players[i];
        TeamPing += PRI.Ping;
        TeamScore += int(PRI.Score);
        TeamKills += PRI.Kills;
        // End:0x22C
        if((Misc_PRI(PRI) != none) && Misc_PRI(PRI).AvgPPR != float(0))
        {
            TeamAvgPPR += Misc_PRI(PRI).AvgPPR;
            ++ NumPPR;
        }
        // End:0x26B
        if(PRI == OwnerPRI)
        {
            C.DrawColor = TeamCol;
            C.DrawColor.A = BaseAlpha;
        }
        // End:0x2AC
        else
        {
            C.DrawColor = HudClass.default.WhiteColor;
            C.DrawColor.A = byte(float(BaseAlpha) * 0.50);
        }
        SetCustomBarColor(C.DrawColor, PRI, PRI == OwnerPRI);
        BarX = BoxX + PlayerBoxX;
        BarY = (BoxY + PlayerBoxY) + ((PlayerBoxH + PlayerBoxSeparatorH) * i);
        DrawPlayerBar(C, BarX, BarY, PlayerBoxW, PlayerBoxH, PRI);
        ++ i;
        // [Loop Continue]
        goto J0x17A;
    }
    // End:0x3E4
    if(Players.Length >= 2)
    {
        TeamPing /= float(Players.Length);
        // End:0x36D
        if(NumPPR > 1)
        {
            TeamAvgPPR /= float(NumPPR);
        }
        BarX = BoxX + PlayerBoxX;
        BarY = (BoxY + PlayerBoxY) + ((PlayerBoxH + PlayerBoxSeparatorH) * Players.Length);
        DrawPlayerTotalsBar(C, BarX, BarY, PlayerTotalsW, playerTotalsH, TeamName, TeamCol, TeamScore, TeamKills, TeamPing, TeamAvgPPR);
    }
    //return;    
}

simulated event UpdateScoreBoard(Canvas C)
{
    local PlayerReplicationInfo PRI, OwnerPRI;
    local int i;
    local array<PlayerReplicationInfo> Reds, Blues, Specs;
    local int HeaderX, HeaderY, HeaderW, HeaderH, RoundTimeX, RoundTimeY,
	    RedScoreBoardX, BlueScoreBoardX, ScoreBoardY, ScoreBoardW, TeamScoreX,
	    TeamScoreY, TeamScoreW, TeamScoreH, SpecBoxX, SpecBoxY,
	    SpecBoxW;

    local Color RedBackgroundCol, BlueBackgroundCol;

    RedBackgroundCol.R = byte(255);
    RedBackgroundCol.G = 50;
    RedBackgroundCol.B = 0;
    RedBackgroundCol.A = byte(float(BaseAlpha) * 0.750);
    BlueBackgroundCol.R = 50;
    BlueBackgroundCol.G = 178;
    BlueBackgroundCol.B = byte(255);
    BlueBackgroundCol.A = byte(float(BaseAlpha) * 0.750);
    // End:0x95
    if(GRI == none)
    {
        return;
    }
    OwnerPRI = PlayerController(Owner).PlayerReplicationInfo;
    // End:0xBB
    if(OwnerPRI == none)
    {
        return;
    }
    Reds.Length = 0;
    Blues.Length = 0;
    Specs.Length = 0;
    i = 0;
    J0xDA:
    // End:0x2D9 [Loop If]
    if(i < GRI.PRIArray.Length)
    {
        PRI = GRI.PRIArray[i];
        // End:0x11B
        if(PRI == none)
        {
            // [Explicit Continue]
            goto J0x2CF;
        }
        // End:0x1A2
        if(PRI.Team == none)
        {
            // End:0x146
            if(!PRI.bOnlySpectator)
            {
                // [Explicit Continue]
                goto J0x2CF;
            }
            // End:0x17B
            if(Specs.Length < MaxSpectators)
            {
                Specs.Insert(Specs.Length, 1);
                Specs[Specs.Length - 1] = PRI;
            }
            // End:0x19F
            else
            {
                // End:0x19F
                if(PRI == OwnerPRI)
                {
                    Specs[Specs.Length - 1] = PRI;
                }
            }
            // [Explicit Continue]
            goto J0x2CF;
        }
        // End:0x1E0
        if((Level.TimeSeconds - float(LastUpdateTime)) > float(4))
        {
            Misc_Player(Owner).ServerUpdateStats(TeamPlayerReplicationInfo(PRI));
        }
        // End:0x259
        if(PRI.Team.TeamIndex == 0)
        {
            // End:0x232
            if(Reds.Length < MaxTeamSize)
            {
                Reds.Insert(Reds.Length, 1);
                Reds[Reds.Length - 1] = PRI;
            }
            // End:0x256
            else
            {
                // End:0x256
                if(PRI == OwnerPRI)
                {
                    Reds[Reds.Length - 1] = PRI;
                }
            }
            // [Explicit Continue]
            goto J0x2CF;
        }
        // End:0x2CF
        if(PRI.Team.TeamIndex == 1)
        {
            // End:0x2AB
            if(Blues.Length < MaxTeamSize)
            {
                Blues.Insert(Blues.Length, 1);
                Blues[Blues.Length - 1] = PRI;
                // [Explicit Continue]
                goto J0x2CF;
            }
            // End:0x2CF
            if(PRI == OwnerPRI)
            {
                Blues[Blues.Length - 1] = PRI;
            }
        }
        J0x2CF:
        ++ i;
        // [Loop Continue]
        goto J0xDA;
    }
    MaxTeamPlayers = Max(MaxTeamPlayers, Max(Reds.Length, Blues.Length));
    HeaderX = 0;
    HeaderY = 0;
    HeaderW = int(C.ClipX);
    HeaderH = int(C.ClipY * 0.080);
    RoundTimeX = int(C.ClipX * 0.50);
    RoundTimeY = int(C.ClipY * 0.350);
    RedScoreBoardX = int(C.ClipX * 0.010);
    BlueScoreBoardX = int(C.ClipX * 0.590);
    ScoreBoardY = int(C.ClipY * 0.230);
    ScoreBoardW = int(C.ClipX * 0.40);
    TeamScoreX = int(C.ClipX * 0.40);
    TeamScoreY = int(C.ClipY * 0.40);
    TeamScoreW = int(C.ClipX * 0.20);
    TeamScoreH = int(C.ClipY * 0.20);
    SpecBoxX = int(C.ClipX * 0.420);
    SpecBoxY = int(C.ClipY * 0.9150);
    SpecBoxW = int(C.ClipX * 0.160);
    C.Style = 5;
    DrawHeader(C, HeaderX, HeaderY, HeaderW, HeaderH);
    DrawRoundTime(C, RoundTimeX, RoundTimeY);
    DrawTeamScores(C, TeamScoreX, TeamScoreY, TeamScoreW, TeamScoreH, GRI.ShortName, Misc_BaseGRI(GRI).Acronym, int(GRI.Teams[0].Score), int(GRI.Teams[1].Score));
    // End:0x5DB
    if(MaxTeamPlayers > 0)
    {
        DrawTeamBoard(C, RedScoreBoardX, ScoreBoardY, ScoreBoardW, "Red Team", RedBackgroundCol, Reds, MaxTeamPlayers);
        DrawTeamBoard(C, BlueScoreBoardX, ScoreBoardY, ScoreBoardW, "Blue Team", BlueBackgroundCol, Blues, MaxTeamPlayers);
    }
    // End:0x606
    if(Specs.Length > 0)
    {
        DrawSpecList(C, SpecBoxX, SpecBoxY, SpecBoxW, Specs);
    }
    // End:0x63C
    if((Level.TimeSeconds - float(LastUpdateTime)) > float(4))
    {
        LastUpdateTime = int(Level.TimeSeconds);
    }
    bDisplayMessages = true;
    //return;    
}

defaultproperties
{
    Box=Texture'Engine.WhiteSquareTexture'
    BaseTex=Texture'textures.ScoreBoard'
    DefaultShieldTexture=Texture'textures.Shield'
    DefaultFlagTexture=Texture'textures.FlagDefault'
    RankTex[0]=Texture'textures.Rank1'
    RankTex[1]=Texture'textures.Rank2'
    RankTex[2]=Texture'textures.Rank3'
    RankTex[3]=Texture'textures.Rank4'
    RankTex[4]=Texture'textures.Rank5'
    RankTex[5]=Texture'textures.Rank6'
    RankTex[6]=Texture'textures.Rank7'
    RankTex[7]=Texture'textures.Rank8'
    RankTex[8]=Texture'textures.Rank9'
    RankTex[9]=Texture'textures.Rank10'
    RankTex[10]=Texture'textures.Rank11'
    RankTex[11]=Texture'textures.Rank12'
    RankTex[12]=Texture'textures.Rank13'
    RankTex[13]=Texture'textures.Rank14'
    RankTex[14]=Texture'textures.Rank15'
    RankTex[15]=Texture'textures.Rank16'
    RankTex[16]=Texture'textures.Rank17'
    RankTex[17]=Texture'textures.Rank18'
    RankTex[18]=Texture'textures.Rank19'
    RankTex[19]=Texture'textures.Rank20'
    RankTex[20]=Texture'textures.Rank21'
    RankTex[21]=Texture'textures.Rank22'
    RankTex[22]=Texture'textures.Rank23'
    RankTex[23]=Texture'textures.Rank24'
    RankTex[24]=Texture'textures.Rank25'
    RankTex[25]=Texture'textures.Rank26'
    RankTex[26]=Texture'textures.Rank27'
    RankTex[27]=Texture'textures.Rank28'
    RankTex[28]=Texture'textures.Rank29'
    RankTex[29]=Texture'textures.Rank30'
    BaseAlpha=200
    MaxTeamSize=12
    MaxSpectators=19
    bEnableColoredNamesOnScoreboard=true
    bEnableColoredNamesOnHUD=true
}