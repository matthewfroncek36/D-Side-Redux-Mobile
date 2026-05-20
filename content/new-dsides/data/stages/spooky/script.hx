import funkin.objects.Character;
import flixel.animation.FlxAnimation;
import flixel.animation.FlxAnimationController;
import funkin.game.shaders.RGBPalette;

var bf_dark:Character;
var gf_dark:Character;
var kids_dark:Character;
var bgdark:FlxSprite;
var bgFaces:FlxSprite;
var dark = (PlayState.SONG.song.toLowerCase() == 'south') || (PlayState.SONG.song.toLowerCase() == 'ghastly');
var fuck:RGBPalette;
var blue;

var shaders = (!ClientPrefs.lowQuality) && ClientPrefs.shaders;

function makeStageSprite(x, y, name) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas('backgrounds/week2/week2'));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}

function onLoad() {
	var bg:FlxSprite = makeStageSprite(-500, -270, 'week_22');
	bg.scale.set(1.2, 1.2);
	add(bg);

	if (dark && !ClientPrefs.lowQuality) {
		fuck = new RGBPalette();
		fuck.r = 0xFF9F0000;
		fuck.g = 0xFF9F0000;
		fuck.b = 0xFF9F0000;
		fuck.enabled = false;
		fuck.mult = 0.625;

		bgdark = makeStageSprite(-500, -270, 'week_2dark');
		bgdark.scale.set(1.2, 1.2);
		bgdark.alpha = 0;
		bgdark.shader = fuck.shader;
		add(bgdark);

		window = makeStageSprite(1350, 870, 'week2_window');
		window.setGraphicSize(Std.int(window.width * 1.2));
		window.alpha = 0;
		add(window);

		bgFaces = makeStageSprite(300, -200, 'faces');
		bgFaces.animation.addByPrefix('idle', 'faces', 24, true);
		bgFaces.animation.play('idle');
		bgFaces.alpha = 0;
		bgFaces.shader = fuck.shader;
		add(bgFaces);

		eyeball = new FlxSprite(-180, 400).loadGraphic(Paths.image('backgrounds/week2/eyeball'));
		eyeball.alpha = 0;
		eyeball.shader = fuck.shader;
		add(eyeball);
	}

	if(songName.toLowerCase() == 'spookeez')
		songStartCallback = delay_start_4_spookeez;		
}

var nextStrike:Int;
var automatedStrikes = true;

function delay_start_4_spookeez(){		
	FlxTimer.wait(0.9, () -> {
		skipCountdown = true;
		startCountdown();
	});
}

function onCreatePost() {
	if(PlayState.SONG.song.toLowerCase() == 'spookeez'){
		snapCamToPos(getCharacterCameraPos(boyfriend).x + 90, getCharacterCameraPos(boyfriend).y, true);
		FlxG.camera.zoom = 1.7;
		camGame.visible = false;
		camHUD.alpha = 0;
	}

	if (dark && !ClientPrefs.lowQuality) {
		gf_dark = new Character(0, 0, 'gf-costume-dark');
		gf_dark.animateAtlas.useRenderTexture = true;
		startCharacterPos(gf_dark, true);
		gf_dark.alpha = bgdark.alpha;
		gf_dark.shader = fuck.shader;
		gfGroup.add(gf_dark);

		bf_dark = new Character(0, 0, 'bf-costume-dark');
		bf_dark.flipX = false;
		bf_dark.isPlayer = true;
		startCharacterPos(bf_dark, true);
		bf_dark.alpha = bgdark.alpha;
		boyfriendGroup.add(bf_dark);
		bf_dark.shader = fuck.shader;
		bf_dark.playAnim('idle', true);

		kids_dark = new Character(0, 0, 'spooky-dark');
		startCharacterPos(kids_dark, true);
		kids_dark.alpha = bgdark.alpha;
		kids_dark.shader = fuck.shader;
		dadGroup.add(kids_dark);

		if (bgdark.alpha == 1) {
			dad.alpha = 0;
			gf.alpha = 0;
			boyfriend.alpha = 0;
		}
	}

	if(shaders){
		blue = newShader('blue');
		blue.setFloat('pix', 0.000001);
		blue.setFloat('hue', 1.2);
		blue.setFloat('hueBlend', 0);

		camHUD.addShader(blue);
	}

		if (PlayState.SONG.song.toLowerCase() == 'ghastly') {
			camGame.visible = false;
			if(blue != null)
				blue.setFloat('hueBlend', 1);

		}
}

function onSongStart()
{
	var song = PlayState.SONG.song.toLowerCase();
	switch(song){
		case 'spookeez':
			FlxTween.tween(camFollow, {y: getCharacterCameraPos(boyfriend).y + 100}, 1.3, {ease: FlxEase.quartOut});
			FlxTween.tween(camGame, {zoom: 1.2}, 1.8, {ease: FlxEase.quartOut});

			camGame.flash(FlxColor.BLACK, 1);
			camGame.visible = true;

			FlxTimer.wait(1.4, ()->{
				FlxTween.tween(camFollow, {x: getCharacterCameraPos(dad).x, y: getCharacterCameraPos(dad).y}, 0.32, {ease: FlxEase.circOut});
				FlxTween.tween(camGame, {zoom: 0.8}, 1.8, {ease: FlxEase.quartOut});
			});

			FlxTimer.wait(5, ()->{
				isCameraOnForcedPos = false;
				FlxTween.tween(camHUD, {alpha: 1}, 1);
			});

		case 'ghastly':
			camGame.flash(FlxColor.BLACK, 0.4);
			camGame.visible = true;
			automatedStrikes = false;

			if(!ClientPrefs.lowQuality)
			{
				for (i in [bf_dark, gf_dark, kids_dark, bgdark])
					i.alpha = 1;	
			
				bgFaces.alpha = 1;
				window.alpha = 0;
			
			}
			

			if(shaders && blue != null)
				blue.setFloat('hueBlend', 1);
			
			for (i in [dad, gf, boyfriend])
				i.alpha = (ClientPrefs.lowQuality) ? 1 : 0;
	}
	

}

var lightning_array:Array<Character> = [bf_dark, gf_dark, kids_dark];

function onUpdate(elapsed) {
	if(ClientPrefs.lowQuality) return;

	if (dark)
		gf_dark.playAnim(gf.getAnimName(), true, false, gf.animCurFrame);
}

function onUpdatePost(elapsed) {
	if(ClientPrefs.lowQuality) return;

	if (dark) {
		bf_dark.playAnim(boyfriend.getAnimName(), true, false, boyfriend.animCurFrame);
		gf_dark.playAnim(gf.getAnimName(), true, false, gf.animCurFrame);
		kids_dark.playAnim(dad.getAnimName(), true, false, dad.animCurFrame);
	}
}

function startCharacterPos(char) {
	char.x += char.positionArray[0];
	char.y += char.positionArray[1];
}

function opponentNoteHit(note) {
	if(ClientPrefs.lowQuality) return;

	if (dark) {
		if (note.noteType == 'Hey!') {
			dad.playAnim('hey', 0.6);
			dad.specialAnim = true;
		}
	}
}

function onBeatHit() {
	if(ClientPrefs.lowQuality) return;

	if (curBeat == nextStrike && automatedStrikes) {
		strike_lightning();
	}
}

var lightning_timer:Float = 0.9;

function strike_lightning() {
	if(ClientPrefs.lowQuality) return;

	FlxG.sound.play(Paths.sound('thunder_' + FlxG.random.int(1, 2)), 0.4);

	for (i in [boyfriend, gf]) {
		i.playAnimForDuration('scared', 1.6);
		i.canDance = false;
	}
	boyfriend.playAnimForDuration('scared', 1.6);
	gf.playAnimForDuration('scared', 1.6);

	for (i in [dad, gf, boyfriend])
		i.alpha = 1;
	for (i in [bf_dark, gf_dark, kids_dark, bgdark]) {
		i.alpha = 0;
		FlxTween.tween(i, {alpha: 1}, lightning_timer);
	}

	if(shaders && blue != null){
		blue.setFloat('hueBlend', 0);

		FlxTween.num(0, 1, lightning_timer * 1.4, {onUpdate: (t)->{
			blue.setFloat('hueBlend', t.value);
		}});
	}

	bgFaces.alpha = 0;
	FlxTween.tween(bgFaces, {alpha: 1}, lightning_timer * 1.4, {startDelay: lightning_timer * 1.4});

	window.alpha = 1;
	FlxTween.tween(window, {alpha: 0}, lightning_timer);

	FlxTimer.wait(lightning_timer, () -> {
		for (i in [dad, gf, boyfriend])
			i.alpha = 0;

		FlxTimer.wait(lightning_timer / 3, () -> {
			gf.canDance = true;
			gf.dance();

			boyfriend.canDance = true;
			if (boyfriend.getAnimName() == 'scared')
				boyfriend.dance();
		});
	});

	nextStrike = curBeat + FlxG.random.int(14, 20);
}

function onEvent(eventName, value1, value2) {
	if (eventName == 'BlackOut') {
		if (ClientPrefs.flashing && PlayState.SONG.song.toLowerCase() != 'ghastly')
			FlxG.camera.flash();
		strike_lightning();
	}
	if (eventName == 'Song Events') {
		switch (value1) {
			case 'white':
				if(ClientPrefs.lowQuality) return;

				camZoomingMult = 1.4;

				for (i in [dad, gf, boyfriend])
					i.alpha = 1;
				for (i in [bf_dark, gf_dark, kids_dark, bgdark])
					FlxTween.tween(i, {alpha: 0}, 2);

				bgFaces.alpha = 1;
				FlxTween.tween(bgFaces, {alpha: 0}, 2);

				window.alpha = 0;
				FlxTween.tween(window, {alpha: 1}, 2);
				if(shaders && blue != null){
					blue.setFloat('hueBlend', 1);

					FlxTween.num(1, 0, 2, {onUpdate: (t)->{
						blue.setFloat('hueBlend', t.value);
					}});
				}

			case 'beats':
				beatsPerZoom = Std.parseInt(value2);
			case 'Red':
				if(ClientPrefs.lowQuality) return;
				
				camGame.zoom += 0.1;
				fuck.enabled = true;

				eyeball.alpha = 0.2625;
				FlxTween.tween(eyeball, {alpha: 0}, 0.8);

				lightning_timer = 0.4;
				camGame.flash(FlxColor.WHITE, 0.5);
				strike_lightning();

				FlxTimer.wait(0.2, ()->{				
					camHUD.fade(FlxColor.BLACK, 4);
				});
		}
	}
}

var gameovervoiceline:FlxSound;

function deathAnimStart() {
	FlxTween.tween(FlxG.sound.music, {volume: 0.5}, 0.2);
	FlxTimer.wait(0.2, () -> {
		gameovervoiceline = FlxG.sound.play(Paths.sound('gameoverlines/spookykids/sm_gameover_' + FlxG.random.int(1, 4)));
		gameovervoiceline.play();
		gameovervoiceline.onComplete = end_voiceline;
	});
}

function onGameOverCancel()
{
	if(gameovervoiceline != null)
		gameovervoiceline.stop();
	
	FlxTween.cancelTweensOf(FlxG.sound.music);
	FlxG.sound.music.volume = 1;

	return ScriptConstants.CONTINUE_FUNC;
}
	

function end_voiceline() {
	FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.2);
}
