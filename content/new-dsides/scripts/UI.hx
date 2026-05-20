/**
 * [UI.hx]
 * Used for handling D-Side's custom UI.
 * Also used for accessing the custom pause menu.
 */

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxCameraFollowStyle;
import funkin.utils.CameraUtil;
import funkin.scripting.PluginsManager;
import funkin.FunkinAssets;

/**
 * [onLoad()]
 * Runs on loading of the script.
 * 
 * In this script:
 *  Turns off the Discord Client being automated.
 *  Sets the combo-graphic's offsets. 
 */
function onLoad() {
	automatedDiscord = false;

	if (ClientPrefs.downScroll)
		ClientPrefs.comboOffset = [-407, 214, -280, 281];
	else
		ClientPrefs.comboOffset = [-407, -294, -280, -234];
}

/**
 * [onPause]
 * Runs when the player pauses the game.
 * 
 * In this script:
 *  Stops existing pause menu from opening if not on low quality mode
 *  Opens custom pause menu (if not on lq mode)
 */
function onPause() {
	if (!ClientPrefs.lowQuality) {
		FlxG.camera.followLerp = 0;
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if (audio.inst != null)
			audio.pause();

		openSubState(new HScriptSubstate("Pause"));
		return ScriptConstants.STOP_FUNC;
	}
}

/**
 * [onCreatePost()]
 * Run after super.create() is called in PlayState.
 * 
 * In this script:
 * 	Precaching the pause menu assets so there's no game stutter on pause
 * 	Creating custom graphics for the time & health bars
 *  Setting the on-screen text font & size
 *  Sets the prefix for the in-game rating graphic file location
 *  Checks if a lyrics.json file exists, and if so, runs the Lyrics.hx script in the data folder.
 */
function onCreatePost() {
	playHUD.ratingPrefix = "UI/game/ratings/";

	// precaching pause assets
	if (!ClientPrefs.lowQuality) {
		Paths.image('menus/pause/overlay');
		Paths.image('menus/checker');
		Paths.image('menus/pause/side bars');
		Paths.image('menus/pause/bottom box');
		Paths.image('menus/pause/top box');
		Paths.getSparrowAtlas('menus/pause/pause buttons');
		Paths.image('menus/pause/PAUSE');
		Paths.image('menus/pause/overlay');
		Paths.image('menus/pause/cover vol 1');

		for (i in 1...10)
			Paths.sound('keys/keyClick' + i);

		Paths.music("breakfast");

		Paths.sound('keys/keyClick9');
		for (i in 1...8)
			Paths.sound('misses/miss' + i);
	}

	FlxG.mouse.visible = false;
	for (m in [playHUD.timeTxt, playHUD.scoreTxt]) {
		m.setFormat(Paths.font("tomo.otf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		m.borderSize = 3;
	}
	if (ClientPrefs.timeBarType != 'Disabled') {
		playHUD.timeBar.setColors(dad.healthColour, FlxColor.BLACK);
		playHUD.timeBar.bg.loadGraphic(Paths.image("UI/game/timeBar"));
		playHUD.timeBar.setBGOffset(-5, -5);
	}

	if (PlayState.SONG.song.toLowerCase() != 'execution') {
		playHUD.healthBar.bg.loadGraphic(Paths.image("UI/game/healthBar"));
		playHUD.healthBar.setBGOffset(-5, -10);
	}

	playHUD.scoreTxt.y -= 10;
	FlxG.mouse.load(Paths.image('UI/window/cursor1').bitmap, 0.325);

	if (FlxG.save.data.restarting) {
		camHUD.flash(FlxColor.BLACK, 1);
		FlxG.save.data.restarting = false;
	}

	if (FunkinAssets.exists(Paths.modFolders(StringTools.replace('songs/' + PlayState.SONG.song.toLowerCase() + '/data/lyrics.json', ' ', '-'))))
		initScript('data/scripts/Lyrics');

	// if (boyfriend.curCharacter == 'bf' && ClientPrefs.inDevMode)
	// 	initScript('data/scripts/bf');
	
	// trace(boyfriend.curCharacter);
}

/**
	* [onUpdatePost(elapsed)]
	* Run on every frame update. Run after super.update(elapsed) is called.

	* @param elapsed
	* Floating-point value that holds the second-value between the last frame update of the game.
	* Also known as a frame-delta.
	 
	* In this script, sets the scale of the scoretxt.
 */
function onUpdatePost(elapsed) {
	canAccessEditors = ClientPrefs.inDevMode;

	scoreTxt.scale.set(1, 1);

	if (FlxG.keys.justPressed.NINE)
		playHUD.iconP1.changeIcon('bf-old');
}

var lastSound = 0;

/**
	* [noteMiss()]
	* Run every time the player misses a note.

	* @param note 
	* Note variable of the missed note
	* 
	* In this script: Plays a random miss sound numbered 1-7.
 */
function noteMiss(note) {
	if (!note.isSustainNote && !ClientPrefs.lowQuality) {
		var rand = FlxG.random.int(1, 7, [lastSound]);
		lastSound = rand;
		FlxG.sound.play(Paths.sound("misses/miss" + rand), 0.3);
	}
}

/**
	* [onEvent()]
	* Run when an EventNote in PlayState is triggered.

	* @param eventName 
	* String value of the Event Note's name.

	* In this script:
	*  Used for ensuring GF plays the 'hey' animation.
 */
function onEvent(eventName) {
	switch (eventName) {
		case 'Hey!':
			gf.playAnimForDuration('hey', 1);
	}
}

var camFollow:FlxObject;

/**
 * [onGameOverStart()]
 * Run when the animation in GameOverSubstate begins.
 * 
 * In this script: 
 *  used for spawning a menu music card for the game over song.
 */
function onGameOverStart() {
	if (GameOverSubstate.characterName == 'bf-dead') {
		FlxTimer.wait(0.001, () -> {
			camFollow = new FlxObject(GameOverSubstate.instance.boyfriend.x + 250, GameOverSubstate.instance.boyfriend.y + 220);
			FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0);
		});
	}

	var credits = [];
	switch (GameOverSubstate.characterName) {
		case 'mobian_bf-dead':
			credits = ['Game Over (JP)', 'squishyzumorizu', [24, 8, 800]];
		case 'pico-dead':
			credits = ['Game Over (Pico)', 'squishyzumorizu', [24, 8, 800]];
		default:
			credits = ["Game Over", 'theWAHbox, Sturm, Wrathstetic', [24, -5, 500]];
	}

	var songtxt = PluginsManager.callPluginFunc('Utils', 'menuIntroCard', credits);
	songtxt.camera = CameraUtil.lastCamera;
	GameOverSubstate.instance.add(songtxt);
}

/**
 * [onDestroy()]
 * Run when the current FlxState is destroyed.
 * 
 * In this script:
 * 	Makes the mouse visible again
 *  Sets the conductor bpm value for external menus. 
 */
function onDestroy() {
	FlxG.mouse.visible = true;

	Conductor.bpm = 102;
}

var kills = ['Gum Note', 'Ice Note', 'GunshotNote', 'Accelerant Gun'];

/**
	* [onSpawnNote()]
	* Runs when a Note object is created.

	* @param note 
	* Note object being created

	* In this script: 
	*  Stops specific note types from spawning if mechanics are disabled in the player's options.
 */
function onSpawnNote(note) {
	if (ClientPrefs.mechanics)
		return;

	for (i in kills) {
		if (note.noteType == i && note.lane == 0)
			return ScriptConstants.STOP_FUNC;
	}
}
