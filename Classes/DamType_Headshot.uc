/*******************************************************************************
 * DamType_Headshot generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class DamType_Headshot extends DamTypeSniperHeadShot;

static function IncrementKills(Controller Killer)
{
    local xPlayerReplicationInfo xPRI;

    // End:0x12
    if(PlayerController(Killer) == none)
    {
        return;
    }
    PlayerController(Killer).ReceiveLocalizedMessage(default.KillerMessage, 0, Killer.PlayerReplicationInfo, none, none);
    xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    // End:0xB2
    if(xPRI != none)
    {
        ++ xPRI.headcount;
        // End:0xB2
        if((xPRI.headcount == 3) && UnrealPlayer(Killer) != none)
        {
            UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('Headhunter', 15);
        }
    }
    //return;    
}
