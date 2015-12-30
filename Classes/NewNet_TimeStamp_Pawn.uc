//-----------------------------------------------------------
//
//-----------------------------------------------------------
class NewNet_TimeStamp_Pawn extends Pawn;

var int timestamp;
var float dt;

function prebeginplay()
{
    super.prebeginplay();
}

function PossessedBy(Controller C)
{
   Super.PossessedBy(C);
   NetPriority=default.NetPriority;
}
function destroyed()
{
   super.destroyed();

}

simulated event tick(float deltatime)
{
   Super.tick(deltatime);
   timestamp+=1;
   DT=deltatime;
}

DefaultProperties
{
    ControllerClass = class'NewNet_TimeStamp_Controller'
    bAlwaysRelevant=true
    NetPriority=50
    bCollideActors=false
    bCollideWorld=false
    bBlockActors=false
    bProjTarget=false
    bCanBeDamaged=false
    bAcceptsProjectors=false
    bCanTeleport=false
    bBlockPlayers=false
    bDisturbFluidSurface=false
    Physics=Phys_None
}
