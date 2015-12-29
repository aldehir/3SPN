/*******************************************************************************
 * Misc_MapListBase generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class Misc_MapListBase extends MapList
    dependson(MapLimits3SPNCW)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force)
    config;

function string UpdateMapNum(int NewMapNum)
{
    local string CurrentMapName, MapName;

    // End:0x4E
    if(Maps.Length == 0)
    {
        Warn("No maps configured for game maplist! Unable to change maps!");
        return "";
    }
    // End:0x7C
    if((MapNum >= 0) && MapNum < Maps.Length)
    {
        CurrentMapName = Maps[MapNum];
    }
    J0x7C:
    // End:0x13D [Loop If]
    if(true)
    {
        // End:0xA4
        if((NewMapNum < 0) || NewMapNum >= Maps.Length)
        {
            NewMapNum = 0;
        }
        MapName = Maps[NewMapNum];
        // End:0xE6
        if(((NewMapNum == MapNum) || MapNum < 0) || MapNum >= Maps.Length)
        {
            // [Explicit Break]
            goto J0x13D;
        }
        // End:0x133
        if(class'MapLimits3SPNCW'.static.IsSuitableMap(CurrentMapName, MapName, Level.Game.NumPlayers) && (FindCacheIndex(MapName)) != -1)
        {
            // [Explicit Break]
            goto J0x13D;
        }
        ++ NewMapNum;
        J0x13D:
        // [Loop Continue]
        goto J0x7C;
    }
    MapNum = NewMapNum;
    class'MapLimits3SPNCW'.static.SetLastMap(MapName);
    // End:0x19F
    if(Level.Game.MaplistHandler != none)
    {
        Level.Game.MaplistHandler.MapChange(MapName);
    }
    class'MapLimits3SPNCW'.static.StaticSaveConfig();
    SaveConfig();
    return MapName;
    //return;    
}
