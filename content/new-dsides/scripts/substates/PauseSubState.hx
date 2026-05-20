import funkin.Mods;
import funkin.states.substates.PauseSubState;
import funkin.states.transitions.ScriptedTransition;

var can = false;
function onExit()
{
    if(!can)
    {
        can = true;
        Mods.currentModDirectory = 'new-dsides';
        Mods.updateModList('new-dsides');
        Mods.loadTopMod();

        ScriptedTransition.setTransition('Sticker');
        PauseSubState.instance.returnToMain();

        return ScriptConstants.STOP_FUNC;
    }
}