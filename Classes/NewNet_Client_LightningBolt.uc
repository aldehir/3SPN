/*******************************************************************************
 * NewNet_Client_LightningBolt generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_Client_LightningBolt extends NewLightningBolt;

function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x55
    if(Level.NetMode != NM_Client)
    {
        Warn("Server should never spawn the client lightningbolt");
    }
    //return;    
}
