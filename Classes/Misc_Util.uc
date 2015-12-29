/*******************************************************************************
 * Misc_Util generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class Misc_Util extends xUtil;

static function string GetStatsID(Controller C)
{
    // End:0x5E
    if(((C.Level == none) || C.Level.Game == none) || C.Level.Game.GameStats == none)
    {
        return "";
    }
    return C.Level.Game.GameStats.GetStatsIdentifier(C);
    //return;    
}

static function string GetMapName(LevelInfo Level)
{
    return Left(string(Level), InStr(string(Level), "."));
    //return;    
}

static function int GetTimeStampHours(LevelInfo Level)
{
    return ((Level.Hour + ((Level.Day - 1) * 24)) + (((Level.Month - 1) * 24) * 31)) + ((((Level.Year - 2000) * 24) * 31) * 12);
    //return;    
}

static function string GetTimeStringFromLevel(LevelInfo Level)
{
    local string HourStr, MinuteStr, SecondStr;

    // End:0x0E
    if(Level == none)
    {
        return "";
    }
    // End:0x41
    if(Level.Hour < 10)
    {
        HourStr = "0" $ string(Level.Hour);
    }
    // End:0x57
    else
    {
        HourStr = string(Level.Hour);
    }
    // End:0x8A
    if(Level.Minute < 10)
    {
        MinuteStr = "0" $ string(Level.Minute);
    }
    // End:0xA0
    else
    {
        MinuteStr = string(Level.Minute);
    }
    // End:0xD3
    if(Level.Second < 10)
    {
        SecondStr = "0" $ string(Level.Second);
    }
    // End:0xE9
    else
    {
        SecondStr = string(Level.Second);
    }
    return (((((((((string(Level.Year) $ "-") $ string(Level.Month)) $ "-") $ string(Level.Day)) $ "-") $ HourStr) $ ":") $ MinuteStr) $ ":") $ SecondStr;
    //return;    
}

static function string GetTimeString(int TimeStampHours)
{
    local int Hour, Day, Month, Year;

    Year = (TimeStampHours / ((24 * 31) * 12)) + 2000;
    TimeStampHours -= ((((Year - 2000) * 24) * 31) * 12);
    Month = (TimeStampHours / (24 * 31)) + 1;
    TimeStampHours -= (((Month - 1) * 24) * 31);
    Day = (TimeStampHours / 24) + 1;
    TimeStampHours -= ((Day - 1) * 24);
    Hour = TimeStampHours;
    return (((((string(Hour) $ ":00 ") $ string(Month)) $ "/") $ string(Day)) $ " ") $ string(Year);
    //return;    
}

static function int GetBit(int theInt, int bitNum)
{
    return theInt & (1 << bitNum);
    //return;    
}

static function bool GetBitBool(int theInt, int bitNum)
{
    return (theInt & (1 << bitNum)) != 0;
    //return;    
}

static function string MakeColorCode(Color NewColor)
{
    // End:0x22
    if(NewColor.R == 0)
    {
        NewColor.R = 1;
    }
    // End:0x62
    else
    {
        // End:0x45
        if(NewColor.R == 10)
        {
            NewColor.R = 9;
        }
        // End:0x62
        else
        {
            NewColor.R = byte(Min(250, NewColor.R));
        }
    }
    // End:0x84
    if(NewColor.G == 0)
    {
        NewColor.G = 1;
    }
    // End:0xC4
    else
    {
        // End:0xA7
        if(NewColor.G == 10)
        {
            NewColor.G = 9;
        }
        // End:0xC4
        else
        {
            NewColor.G = byte(Min(250, NewColor.G));
        }
    }
    // End:0xE6
    if(NewColor.B == 0)
    {
        NewColor.B = 1;
    }
    // End:0x126
    else
    {
        // End:0x109
        if(NewColor.B == 10)
        {
            NewColor.B = 9;
        }
        // End:0x126
        else
        {
            NewColor.B = byte(Min(250, NewColor.B));
        }
    }
    return ((Chr(27) $ Chr(NewColor.R)) $ Chr(NewColor.G)) $ Chr(NewColor.B);
    //return;    
}

static function string ColorReplace(int k)
{
    local Color theColor;

    theColor.R = byte((GetBit(k, 0)) * 250);
    theColor.G = byte((GetBit(k, 1)) * 250);
    theColor.B = byte((GetBit(k, 2)) * 250);
    return MakeColorCode(theColor);
    //return;    
}

static function string RandomColor()
{
    local Color theColor;

    theColor.R = byte(Rand(250));
    theColor.G = byte(Rand(250));
    theColor.B = byte(Rand(250));
    return MakeColorCode(theColor);
    //return;    
}

static simulated function string StripColorCodes(string S)
{
    local array<string> StringParts;
    local int i;
    local string s2;

    Split(S, Chr(27), StringParts);
    // End:0x29
    if(StringParts.Length >= 1)
    {
        s2 = StringParts[0];
    }
    i = 1;
    J0x30:
    // End:0x8C [Loop If]
    if(i < StringParts.Length)
    {
        StringParts[i] = Right(StringParts[i], Len(StringParts[i]) - 3);
        s2 = s2 $ StringParts[i];
        ++ i;
        // [Loop Continue]
        goto J0x30;
    }
    // End:0xB4
    if(Right(s2, 1) == Chr(27))
    {
        s2 = Left(s2, Len(s2) - 1);
    }
    return s2;
    //return;    
}

static function string StripColor(string S)
{
    local int P;

    P = InStr(S, Chr(27));
    J0x11:
    // End:0x54 [Loop If]
    if(P >= 0)
    {
        S = Left(S, P) $ Mid(S, P + 4);
        P = InStr(S, Chr(27));
        // [Loop Continue]
        goto J0x11;
    }
    return S;
    //return;    
}

static simulated function DrawTextClipped(Canvas C, string S, float MaxWidth)
{
    local float oldClipX;

    oldClipX = C.ClipX;
    C.ClipX = C.CurX + MaxWidth;
    C.DrawTextClipped(S);
    C.ClipX = oldClipX;
    //return;    
}

static simulated function bool InStrNonCaseSensitive(string S, string s2)
{
    local int i;

    i = 0;
    J0x07:
    // End:0x4A [Loop If]
    if(i <= (Len(S) - Len(s2)))
    {
        // End:0x40
        if(Mid(S, i, Len(s2)) ~= s2)
        {
            return true;
        }
        ++ i;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return;    
}

static function string FixUnicodeString(string S)
{
    local int i, Code;
    local string Result;

    i = 0;
    J0x07:
    // End:0x65 [Loop If]
    if(i < Len(S))
    {
        Code = Asc(Mid(S, i));
        // End:0x47
        if(Code >= 65280)
        {
            Code -= 65280;
        }
        Result = Result $ Chr(Code);
        ++ i;
        // [Loop Continue]
        goto J0x07;
    }
    return Result;
    //return;    
}

static function string SanitizeLoginOptions(string Options)
{
    local string Pair, Key, Value, Result, OrigOptions;

    OrigOptions = Options;
    J0x0B:
    // End:0x8E [Loop If]
    if(class'GameInfo'.static.GrabOption(Options, Pair))
    {
        class'GameInfo'.static.GetKeyValue(Pair, Key, Value);
        // End:0x55
        if(Len(Key) == 0)
        {
        }
        // End:0x8B
        else
        {
            // End:0x68
            if(Key == "Load")
            {
            }
            // End:0x8B
            else
            {
                Result = (((Result $ "?") $ Key) $ "=") $ Value;
            }
        }
        // [Loop Continue]
        goto J0x0B;
    }
    Log(((("Sanitized options string '" $ OrigOptions) $ "' to '") $ Result) $ "'");
    return Result;
    //return;    
}
