/*******************************************************************************
 * Misc_DynCombo generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2013 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class Misc_DynCombo extends Combo
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var array<Combo> Combos;
var Misc_DynComboManager ComboManager;

function StartEffect(xPawn P)
{
    // End:0x57
    if(Misc_Player(P.Controller) != none)
    {
        // End:0x57
        if(P.Controller.Adrenaline < 0.10)
        {
            P.Controller.Adrenaline = 0.10;
        }
    }
    //return;    
}

function AddCombo(class<Combo> ComboClass)
{
    local int i;

    // End:0x3A
    if(((ComboClass == none) || Pawn(Owner) == none) || Pawn(Owner).Controller == none)
    {
        return;
    }
    // End:0x9E
    if((PlayerController(Pawn(Owner).Controller) != none) && ComboClass.default.ExecMessage != "")
    {
        PlayerController(Pawn(Owner).Controller).ReceiveLocalizedMessage(class'ComboMessage',,,, ComboClass);
    }
    i = 0;
    J0xA5:
    // End:0x116 [Loop If]
    if(i <= Combos.Length)
    {
        // End:0xD8
        if(i == Combos.Length)
        {
            Combos.Length = Combos.Length + 1;
            // [Explicit Break]
            goto J0x116;
        }
        // End:0x10C
        if((Combos[i] != none) && Combos[i].Class == ComboClass)
        {
            // [Explicit Break]
            goto J0x116;
        }
        ++ i;
        J0x116:
        // [Loop Continue]
        goto J0xA5;
    }
    // End:0x15F
    if(Combos[i] == none)
    {
        Combos[i] = Spawn(ComboClass, Pawn(Owner));
        Combos[i].AdrenalineCost = 0.0;
    }
    UnrealMPGameInfo(Level.Game).SpecialEvent(Pawn(Owner).PlayerReplicationInfo, "" $ string(ComboClass));
    // End:0x1BE
    if(Combos[i].IsA('ComboSpeed'))
    {
        i = 0;
    }
    // End:0x234
    else
    {
        // End:0x1E2
        if(Combos[i].IsA('ComboBerserk'))
        {
            i = 1;
        }
        // End:0x234
        else
        {
            // End:0x207
            if(Combos[i].IsA('ComboDefensive'))
            {
                i = 2;
            }
            // End:0x234
            else
            {
                // End:0x22C
                if(Combos[i].IsA('ComboInvis'))
                {
                    i = 3;
                }
                // End:0x234
                else
                {
                    i = 4;
                }
            }
        }
    }
    TeamPlayerReplicationInfo(Pawn(Owner).PlayerReplicationInfo).Combos[i] += byte(1);
    //return;    
}

function RemoveCombo(class<Combo> ComboClass)
{
    local int i;

    // End:0x0D
    if(ComboClass == none)
    {
        return;
    }
    i = 0;
    J0x14:
    // End:0x80 [Loop If]
    if(i < Combos.Length)
    {
        // End:0x76
        if((Combos[i] != none) && Combos[i].Class == ComboClass)
        {
            Combos[i].Destroy();
            Combos.Remove(i, 1);
            // [Explicit Break]
            goto J0x80;
        }
        ++ i;
        J0x80:
        // [Loop Continue]
        goto J0x14;
    }
    // End:0x8F
    if(Combos.Length == 0)
    {
        Destroy();
    }
    //return;    
}

function Tick(float DeltaTime)
{
    Disable('Tick');
    //return;    
}

function Destroyed()
{
    local int i;

    i = 0;
    J0x07:
    // End:0x44 [Loop If]
    if(i < Combos.Length)
    {
        // End:0x3A
        if(Combos[i] != none)
        {
            Combos[i].Destroy();
        }
        ++ i;
        // [Loop Continue]
        goto J0x07;
    }
    Combos.Remove(0, Combos.Length);
    super.Destroyed();
    //return;    
}

function AdrenalineEmpty()
{
    //return;    
}
