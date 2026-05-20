import openfl.filters.ShaderFilter;
import openfl.filters.BlurFilter;
import funkin.game.shaders.DropShadowShader;
import funkin.scripting.ScriptedState;
import funkin.objects.Bopper;

var bgX:Int = -800;
var bgY:Int = -500;
var bg_size:Float = 1.4;
var bg_string:String = 'backgrounds/week3/week3';
var dark = PlayState.SONG.song.toLowerCase() == 'blammed';

function makeStageSprite(x, y, name, path) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas(path));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}

function onLoad() {
	if (dark)
		bg_string = 'backgrounds/week3/week3dark';

	var sky = makeStageSprite(bgX, bgY, 'week_3sky', bg_string);
	sky.scale.set(bg_size, bg_size);
	sky.scrollFactor.set(0.1, 0.1);
	add(sky);

	var buildingsback = makeStageSprite(bgX, bgY, 'week_3buildings_2', bg_string);
	buildingsback.scale.set(bg_size, bg_size);
	buildingsback.scrollFactor.set(0.3, 0.3);
	add(buildingsback);

	var buildings = makeStageSprite(bgX, bgY, 'build_week3', bg_string);
	buildings.scale.set(bg_size, bg_size);
	buildings.scrollFactor.set(0.4, 0.4);
	add(buildings);

	var streets = makeStageSprite(bgX, bgY - (dark ? -200 : 100), 'week_3streets', bg_string);
	streets.scale.set(bg_size, bg_size);
	streets.scrollFactor.set(0.65, 0.65);
	add(streets);

	lights = makeStageSprite(bgX, bgY + 59, 'week_3lights', bg_string);
	lights.scale.set(bg_size, bg_size);
	lights.scrollFactor.set(0.9, 0.9);
	add(lights);

	if(dark){
		overlay3 = new FlxSprite(-500, -600).loadGraphic(Paths.image('backgrounds/week3/purple_mult2'));
		overlay3.scrollFactor.set();
		overlay3.setGraphicSize(2400, 2000);
		overlay3.updateHitbox();
		overlay3.blend = BlendMode.ADD;
		overlay3.alpha = 0;
		add(overlay3);
	}


	var floor = makeStageSprite(bgX, lights.y + (dark ? 835 : -65), 'week_3floor', bg_string);
	floor.scale.set(bg_size, bg_size);
	floor.scrollFactor.set(1, 1);
	add(floor);

	var props = makeStageSprite(floor.x, floor.y - (dark ? 835 : 0), 'week_3props', bg_string);
	props.scale.set(bg_size, bg_size);
	props.scrollFactor.set(1, 1);
	add(props);

	if (ClientPrefs.lowQuality)
		return;

	if (PlayState.SONG.song.toLowerCase() != 'pico') {
		cyclops = new FlxSprite();
		cyclops.frames = Paths.getSparrowAtlas('backgrounds/week3/props');
		cyclops.animation.addByPrefix('idle', 'CyclopsIdle', 24, false);
		cyclops.animation.play('idle');
		add(cyclops);

		alucard = new FlxSprite();
		alucard.frames = Paths.getSparrowAtlas('backgrounds/week3/props');
		alucard.animation.addByPrefix('idle', 'AlucardIdle', 24, false);
		alucard.animation.play('idle');
		add(alucard);

		nene = new FlxSprite();
		nene.frames = Paths.getSparrowAtlas('backgrounds/week3/props');
		nene.animation.addByIndices('danceLeft', 'NeneIdle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
		nene.animation.addByIndices('danceRight', 'NeneIdle', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 24, false);
		nene.animation.play('danceLeft');
		nene.zIndex = 1;
		add(nene);

		darnell = new FlxSprite();
		darnell.frames = Paths.getSparrowAtlas('backgrounds/week3/props');
		darnell.animation.addByPrefix('idle', 'DarnellIdle', 24, false);
		darnell.animation.play('idle');
		darnell.zIndex = 1;
		add(darnell);

		if (dark) {
			for (i in [cyclops, alucard, nene, darnell]) {
				i.color = 0xff7266c1;

				var rim = new DropShadowShader();
				rim.color = 0x90606059;
				rim.distance = 22;
				rim.angle = 90;
				rim.attachedSprite = i;

				i.animation.onFrameChange.add(() -> {
					rim.updateFrameInfo(i.frame);
				});

				i.shader = rim;
			}
		}
	}

	if (!dark) {
		var overlay = makeStageSprite(bgX, bgY + 50, 'week_3overlay', bg_string);
		overlay.scale.set(bg_size, bg_size);
		overlay.scrollFactor.set(1, 1);
		overlay.zIndex = 999;
		overlay.blend = BlendMode.MULTIPLY;
		add(overlay);

		addCharacterToList('bf-cutscene', 0);
		addCharacterToList('pico-cutscene', 1);
	} else {
		overlay = new FlxSprite().loadGraphic(Paths.image('backgrounds/week3/purple_mult'));
		overlay.camera = camHUD;
		overlay.setGraphicSize(1280, 720);
		overlay.updateHitbox();
		overlay.blend = BlendMode.ADD;
		overlay.alpha = 0.125;
		add(overlay);

		overlay2 = new FlxSprite().loadGraphic(Paths.image('backgrounds/week3/purple_mult'));
		overlay2.camera = camHUD;
		overlay2.setGraphicSize(1280, 720);
		overlay2.updateHitbox();
		overlay2.blend = BlendMode.MULTIPLY;
		overlay2.alpha = 0.5;
		add(overlay2);
	}

}

var high_shader = null;
var contrast = null;

function onCreatePost() {
	initScript('data/scripts/NoteWarning');

	if (dark) {
		var p = [dadGroup, boyfriendGroup, gfGroup];
		if (!ClientPrefs.lowQuality) {
			p.push(nene);
			p.push(cyclops);
			p.push(alucard);
			p.push(darnell);
		}
		for (i in p)
			i.y -= 75;

		lights.y += 200;

		if (ClientPrefs.shaders && ClientPrefs.flashing && !ClientPrefs.lowQuality) {
			high_shader = newShader('high');
			camGame.addShader(high_shader);

			contrast = newShader('colorcorrection');
			contrast.setFloat('customred', 0.1);
			contrast.setFloat('customgreen', 0.1);
			contrast.setFloat('customblue', 0.1);
			contrast.setFloat('brightness', -0.1);
			contrast.setFloat('contrast', 1.0);
			contrast.setFloat('saturation', 1.0);
			camGame.addShader(contrast);
		}
	}

	if (dark) {
		scene = new Bopper();
		scene.loadAtlas('cutscenes/blammed');
		scene.addAnimByPrefix('idle', 'blamletters', 24, false);
		scene.playAnim('idle');
		scene.visible = false;
		scene.zIndex = 2;
		scene.x += 280;
		stage.add(scene);

		modManager.queueFuncOnce(960, endCutscene);
		modManager.queueFuncOnce(1024, () -> {
			camGame.fade(FlxColor.BLACK, 2);
		});
	}

	if (ClientPrefs.lowQuality)
		return;

	if (PlayState.SONG.song.toLowerCase() != 'pico') {
		cyclops.setPosition(gf.x - 390, gf.y + 160);
		alucard.setPosition(gf.x + 820, gf.y + 230);

		nene.setPosition(gf.x - 120, gf.y + 240);
		darnell.setPosition(gf.x + 550, gf.y + 263);
	}
	boyfriendGroup.zIndex = 12;
	dadGroup.zIndex = 12;

	cars = new FlxSprite(-900, 790);
	cars.frames = Paths.getSparrowAtlas('backgrounds/week3/props');
	cars.animation.addByPrefix('idle', 'CarsAnim', 24, false);
	cars.animation.play('idle');
	cars.setGraphicSize(Std.int(cars.width * 1.2));
	cars.alpha = 0;
	cars.antialiasing = true;
	cars.zIndex = 16;
	cars.flipX = true;
	add(cars);

	refreshZ(stage);

	blur = new BlurFilter(0,0);
	camHUD.filters = [blur];

}

var blammed_lights:Bool = false;
var high_timer:Float = 0;
var high_effectiveness:Float = 0;

function onUpdate(elapsed) {
	if (ClientPrefs.lowQuality)
		return;

	if (dark) {
		overlay.alpha = (Conductor.songPosition / songLength) * (0.125);
		overlay2.alpha = (Conductor.songPosition / songLength) * (0.5);
	}

	blur.blurX = FlxMath.lerp(blur.blurX, blammed_lights ? 1 : 0, FlxMath.bound(elapsed * 3, 0, 1));
	blur.blurY = FlxMath.lerp(blur.blurY, blammed_lights ? 1 : 0, FlxMath.bound(elapsed * 3, 0, 1));
	
	if (high_shader != null) {
		high_timer = Conductor.songPosition / 1000;

		high_shader.setFloat('iTime', high_timer);
		high_shader.setFloat('effectiveness', high_effectiveness);

		if (ClientPrefs.flashing) {
			high_effectiveness = FlxMath.lerp(high_effectiveness, blammed_lights ? 0.1 : 0, FlxMath.bound(elapsed * 3, 0, 1));
		}
	}
}

function onEndSong() {
	var save = FlxG.save.data.completedMenuShit.get('funky');
	var isSave = save == null || save == false;


	if (PlayState.SONG.song.toLowerCase() == 'blammed' && PlayState.isStoryMode && isSave) {
		FlxG.switchState(new ScriptedState('CreditsVideo'));

		return ScriptConstants.STOP_FUNC;
	}
}

function endCutscene() {
	for (i in stage.members)
		i.visible = false;

	camHUD.visible = false;

	changeCharacter('bf-cutscene', 0);
	boyfriend.playAnim('bf', true);
	boyfriend.specialAnim = true;

	changeCharacter('pico-cutscene', 1);
	dad.playAnim('pico', true);
	dad.specialAnim = true;

	dadGroup.visible = true;
	boyfriendGroup.visible = true;

	scene.visible = true;
	scene.playAnim('idle', true);

	snapCamToPos(845, 500, true);

	FlxTimer.wait(1.6, () -> {
		camFollow.x += 45;
	});

	camZooming = false;
	FlxTween.tween(camGame, {zoom: 0.65}, 0.325, {ease: FlxEase.bounceOut});

}

var car_beat_to_drive_on:Int = FlxG.random.int(16, 26);
var car_sound:FlxSound;
var canDrive:Bool = true;

function car_drive(local_curBeat) {
	if (ClientPrefs.lowQuality)
		return;

	if (canDrive) {
		canDrive = false;
		car_sound = FlxG.sound.play(Paths.sound('policecarslol'));
		car_sound.play();

		FlxTimer.wait(1.53, () -> {
			gf.playAnimForDuration('hairBlow', 0.6);
			gf.canDance = false;

			FlxTimer.wait(0.6, () -> {
				gf.playAnimForDuration('hairFall', 0.7);
				gf.canDance = true;
				gf.animation.finishCallback = function(hairfall:String) {
					canDrive = true;
					gf.animation.finishCallback = function(hairfall:String) {}
				}
			});

			cars.alpha = 1;
			cars.animation.play('idle');
			car_beat_to_drive_on = local_curBeat + 4 + FlxG.random.int(25, 45);
		});
	}
}

function onPause() {
	if (car_sound != null)
		car_sound.pause();
}

function onResume() {
	if (car_sound != null)
		car_sound.resume();
}

function onBeatHit() {
	if (ClientPrefs.lowQuality)
		return;

	car_drive(curBeat);

	if (PlayState.SONG.song.toLowerCase() != 'pico') {
		if (nene.animation.curAnim.name == 'danceLeft')
			nene.animation.play('danceRight', true);
		else
			nene.animation.play('danceLeft', true);

		if (curBeat % 2 == 0) {
			for (char in [alucard, cyclops, darnell])
				char.animation.play('idle');
		}

		if (blammed_lights && overlay3 != null) {
			blammed_light();
		}
	}
}

function opponentNoteHit(note) {
	switch (note.noteType) {
		case 'GunshotNote':
			dad.playAnim('shoot', true);
			dad.specialAnim = true;
		case 'ReloadNote':
			dad.playAnim('singRELOAD', true);
			dad.specialAnim = true;

			dad.onAnimationFinish.addOnce(() -> {
				dad.playAnim('singRELOAD', true);
				dad.specialAnim = true;
			});
	}
}

function onEvent(eventName, value1, value2) {
	switch (eventName) {
		case 'Song Events':
			if (ClientPrefs.lowQuality)
				return;

			switch (value1) {
				case 'Blammed Lights':
					if (!ClientPrefs.flashing)
						return;

					blammed_light();
					blammed_lights = !blammed_lights;
			}
		case 'Play Animation':
			if (value1 == 'burp') {
				dad.onAnimationFinish.addOnce(() -> {
					dad.playAnim('shit', true);
					dad.specialAnim = true;
					dad.canDance = false;
				});
			}
	}
}

var cT:FlxTween = null;
function blammed_light() {
	if (overlay3 == null)
		return;
	FlxTween.cancelTweensOf(overlay3);
	overlay3.alpha = 0.9;
	FlxTween.tween(overlay3, {alpha: 0}, 0.625);

	high_effectiveness += 0.15;

	blur.blurX += 3;
	blur.blurY += 3;

	if(contrast != null){
		if(cT != null){
			cT.cancel();
			cT = null;
		}

		cT = FlxTween.num(1.56, 1, 0.3, {onUpdate: (t)->{
			contrast.setFloat('contrast', t.value);
		}});
	}
}

var gameovervoiceline:FlxSound;

function deathAnimStart() {
	FlxTween.tween(FlxG.sound.music, {volume: 0.5}, 0.2);
	FlxTimer.wait(0.2, () -> {
		gameovervoiceline = FlxG.sound.play(Paths.sound('gameoverlines/pico/pico_line_' + FlxG.random.int(1, 10)));
		gameovervoiceline.play();
		gameovervoiceline.onComplete = end_voiceline;
	});
}

function onGameOverCancel() {
	if (gameovervoiceline != null)
		gameovervoiceline.stop();

	FlxTween.cancelTweensOf(FlxG.sound.music);
	FlxG.sound.music.volume = 1;

	return ScriptConstants.CONTINUE_FUNC;
}

function end_voiceline() {
	FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.2);
}
