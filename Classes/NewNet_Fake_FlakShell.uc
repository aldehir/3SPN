/*******************************************************************************
 * NewNet_Fake_FlakShell generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class NewNet_Fake_FlakShell extends FlakShell;

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    Destroy();
    //return;    
}

defaultproperties
{
    bNetTemporary=false
}