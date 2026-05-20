/**
 * [Completion.hx]
 * Used to handle song-completion's contributions to your overall update completion.
 */

import funkin.scripting.PluginsManager;

var song;
var needsCompletion:Bool = false;

/**
 * [onLoad()]
 * Runs on loading of the script.
 * 
 * In this script:
 * Used for checking if the current song has been completed or not
 * Also fixes the custom save-data if it happens to be null.
*/
function onLoad()
{
	PluginsManager.callPluginFunc('Utils', 'saveFix', []);

    song = Paths.sanitize(PlayState.SONG.song);
    needsCompletion = (FlxG.save.data.completedSongs.indexOf(song) == -1);

}

/**
 * [onEndSong()]
 * Runs when a playable song is completed.
 
 * In this script:
 * Checks if your song hasn't been completed yet, it adds it to the list of completed songs & adds completion percentage.
*/
function onEndSong()
{
    if(needsCompletion){
        FlxG.save.data.completedSongs.push(song);

        FlxG.save.flush();
    }

    return ScriptConstants.CONTINUE_FUNC;
}