import flixel.addons.display.FlxTiledSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxTiledSprite;
import openfl.filters.ShaderFilter;
import flixel.text.FlxText;
import funkin.scripting.PluginsManager;

var megaphone:FlxSprite;
var building_back:FlxBackdrop;
var building_middle:FlxBackdrop;
var building_front:FlxBackdrop;
var buildings_y:Int = -40;
var AnimateSprite:FlxAnimate;
var rainIntensity:Float = 0;
var rainShader:FlxShader; // ty base game
var rainTime:Float = 0;
var rain2 = newShader('rain2');
var pico_intro_anim:AnimateSprite;
var can = true;
var cutsceneSounds = [];

function onStartCountdown() {
	if (ClientPrefs.lowQuality)
		return;

	if (can) {
		can = false;
		playCutscene();
		return ScriptConstants.STOP_FUNC;
	}
}

function makeStageSprite(x, y, name, dir) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas('backgrounds/weekend1/' + dir));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}

function onLoad() {
	var sky = makeStageSprite(-620, -420, 'sky', 'weekend1');
	sky.scale.set(1.4, 1.4);
	sky.scrollFactor.set(0, 0);
	add(sky);

	building_back = new FlxBackdrop(null, FlxAxes.X, 0).setFrames(Paths.getSparrowAtlas('backgrounds/weekend1/weekend1'));
	building_back.animation.addByPrefix('buildin_last', 'buildin_last', 24, true);
	building_back.animation.play('buildin_last');
	building_back.y += buildings_y - 180;
	building_back.scrollFactor.set(0.3, 0.3);
	building_back.scale.set(1.4, 1.4);
	add(building_back);

	building_middle = new FlxBackdrop(null, FlxAxes.X, 0).setFrames(Paths.getSparrowAtlas('backgrounds/weekend1/weekend1'));
	building_middle.animation.addByPrefix('buildin_second', 'buildin_second', 24, true);
	building_middle.animation.play('buildin_second');
	building_middle.y += buildings_y - 120;
	building_middle.scrollFactor.set(0.4, 0.4);
	building_middle.scale.set(1.4, 1.4);
	add(building_middle);

	building_front = new FlxBackdrop(null, FlxAxes.X, 0).setFrames(Paths.getSparrowAtlas('backgrounds/weekend1/weekend1'));
	building_front.animation.addByPrefix('buildinn_first', 'buildinn_first', 24, true);
	building_front.animation.play('buildinn_first');
	building_front.y += buildings_y - 50;
	building_front.scrollFactor.set(0.6, 0.6);
	building_front.scale.set(1.4, 1.4);
	add(building_front);

	sign = makeStageSprite(700, -170, 'sign1', 'signs');
	sign.scale.set(1.4, 1.4);
	sign.scrollFactor.set(0.7, 0.7);
	add(sign);

	for (i in 1...7) {
		sign.animation.addByPrefix('sign' + i, 'sign' + i, 24, false);
		sign.animation.addByPrefix('ad' + i, 'ad' + i, 24, false);
	}

	reload_sign();

	light_back = new FlxBackdrop(null, FlxAxes.X, 4000).setFrames(Paths.getSparrowAtlas('backgrounds/weekend1/weekend1'));
	light_back.animation.addByPrefix('light_back', 'light_back', 24, true);
	light_back.animation.play('light_back');
	light_back.y = 10;
	light_back.scrollFactor.set(0.93, 0.93);
	light_back.scale.set(1.4, 1.4);
	add(light_back);

	street = new FlxBackdrop(null, FlxAxes.X, 0).setFrames(Paths.getSparrowAtlas('backgrounds/weekend1/weekend1'));
	street.animation.addByPrefix('street', 'street', 24, true);
	street.animation.play('street');
	street.y = 600;
	street.scrollFactor.set(0.95, 0.95);
	add(street);

	light_front = new FlxBackdrop(null, FlxAxes.X, 2000).setFrames(Paths.getSparrowAtlas('backgrounds/weekend1/weekend1'));
	light_front.animation.addByPrefix('light_front', 'light_front', 24, true);
	light_front.animation.play('light_front');
	light_front.y = 170;
	light_front.scrollFactor.set(1.2, 1.2);
	light_front.scale.set(1.4, 1.4);
	light_front.zIndex = 20;
	add(light_front);

	if (!ClientPrefs.lowQuality) {
		tunnelbg = new FlxBackdrop(Paths.image('backgrounds/weekend1/tunnelbg'), FlxAxes.X, 0);
		tunnelbg.scrollFactor.set(0.95, 0.95);
		tunnelbg.y -= 130;
		tunnelbg.visible = false;
		add(tunnelbg);
	}

	truck = makeStageSprite(-600, 270, 'truck', 'weekend1');
	truck.scale.set(1.4, 1.4);
	add(truck);

	if (!ClientPrefs.lowQuality) {
		truckdark = makeStageSprite(-600, 270, 'darktruck', 'weekend1');
		truckdark.scale.set(1.4, 1.4);
		truckdark.alpha = 0.00001;
		add(truckdark);

		megaphone = makeStageSprite(1875, 275, 'megaphoneanim', 'weekend1');
		megaphone.scale.set(1.4, 1.4);
		add(megaphone);

		blend_bg = makeStageSprite(100, 300, 'darnell_gradient', 'weekend1');
		blend_bg.scrollFactor.set(0.15, 0.15);
		blend_bg.antialiasing = ClientPrefs.globalAntialiasing;
		blend_bg.blend = BlendMode.ADD;
		blend_bg.scale.set(2.5, 2.5);
		blend_bg.updateHitbox();
		blend_bg.screenCenter();
		blend_bg.zIndex = 21;
		blend_bg.alpha = 0.15;
		add(blend_bg);

		darnell_cutscene = new Character(0, 0, 'darnell-cutscene');
		// startCharacterPos(darnell_cutscene, true);
		dadGroup.addChar(darnell_cutscene);

		pico_cutscene = new Character(0, 0, 'pico-playable-cutscene', true);
		// startCharacterPos(pico_cutscene, true);
		boyfriendGroup.addChar(pico_cutscene);

		darnell_cutscene.alpha = 0;
		pico_cutscene.alpha = 0;
	}

	black_screen = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
	black_screen.camera = camOther;

	songStartCallback = startCountdown;
}

function onCreatePost() {
	if (ClientPrefs.lowQuality)
		return;

	addCharacterToList('pico-playable-tunnel', 0);
	addCharacterToList('darnell-tunnel', 1);

	rainIntensity = 0.1;

	if (ClientPrefs.shaders) {
		rainShader = newShader('rain');
		rainShader.setFloatArray('uScreenResolution', [FlxG.width, FlxG.height]);
		rainShader.setFloat('uTime', 0);
		rainShader.setFloat('uScale', FlxG.height / 300);
		rainShader.setFloat('uIntensity', rainIntensity);
	}

	// I STILL LIKE THIS SHADER. I WANNA USE IT STILL. BUT WHATEVERRR
	// rain2.setFloat('bDir', 4);
	// rain2.setFloat('bQual', 4);
	// rain2.setFloat('bSize', 1);
	// rain2.setFloat('rSize', 0.2);

	if (ClientPrefs.shaders)
		camGame.filters = [new ShaderFilter(rainShader) /*, new ShaderFilter(rain2)*/];

	transition = makeStageSprite(0, -70, 'transition1', 'weekend1');
	transition.cameras = [camHUD];
	transition.scale.set(0.5, 0.5);
	transition.updateHitbox();
	transition.x += transition.width;
	add(transition);

	transition2 = makeStageSprite(0, -70, 'transition2', 'weekend1');
	transition2.cameras = [camHUD];
	transition2.scale.set(0.5, 0.5);
	transition2.updateHitbox();
	transition2.x += transition2.width;
	add(transition2);
}

var cutscene = false;
var cutsceneSong:FlxSound;
var eventTimer:FlxTimer;
var weirdTween:FlxTween;
var weirdTween2:FlxTween;
var skipTxt:FlxText;

function playCutscene() {
	if (ClientPrefs.lowQuality)
		return;

	if (FlxG.save.data.completedSongs.contains('darnell')) {
		skipTxt = new FlxText(20);
		skipTxt.setFormat(Paths.font('Pixim.otf'), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		skipTxt.camera = camOther;
		skipTxt.text = 'Press space to skip!';
		skipTxt.borderSize = 3;
		skipTxt.alpha = 0;
		skipTxt.y = FlxG.height;
		add(skipTxt);
		FlxTween.tween(skipTxt, {alpha: 1, y: FlxG.height - skipTxt.height - 10}, 2, {ease: FlxEase.quadOut});
	}

	cutscene = true;
	dad.alpha = 0;
	boyfriend.alpha = 0;
	darnell_cutscene.alpha = 1;
	pico_cutscene.alpha = 1;

	camGame.flash(FlxColor.BLACK, 4);
	camFollow.setPosition(1350, 660);
	FlxG.camera.snapToTarget();

	defaultCamZoom = 1.5;
	FlxG.camera.zoom = defaultCamZoom;

	isCameraOnForcedPos = true;

	camHUD.alpha = 0;
	black_screen.alpha = 1;

	cameraSpeed = 5;
	cutsceneSong = new FlxSound();
	cutsceneSong.loadEmbedded(Paths.music("talkin_smack"), false, true);
	cutsceneSong.volume = 0.1;
	cutsceneSong.pause();
	FlxG.sound.list.add(cutsceneSong);

	doNeneShit();

	var sound1 = new FlxSound().loadEmbedded(Paths.sound("dPICO_Cig"));
	sound1.pause();
	cutsceneSounds.push(sound1);

	var sound2 = new FlxSound().loadEmbedded(Paths.sound("dPICO_FireShoot"));
	sound2.pause();
	cutsceneSounds.push(sound2);

	FlxTimer.wait(0.3, () -> {
		cutsceneSong.play();
		cutsceneSong.fadeIn(1, 0, 0.5);
	});
	eventTimer = new FlxTimer().start(0.9, () -> {
		FlxTween.tween(black_screen, {alpha: 0}, 3);

		FlxTween.tween(FlxG.camera, {zoom: 0.6}, 7, {ease: FlxEase.quadOut});
		FlxTween.tween(camFollow, {x: 880}, 5.3, {ease: FlxEase.quadInOut});
		FlxTween.tween(camFollow, {y: 500}, 5.3, {ease: FlxEase.quadInOut});

		eventTimer = FlxTimer.wait(2.7, () -> {
			pico_cutscene.playAnim('Intro');
			FlxTimer.wait(2.75, () -> {
				sound1.play();
			});

			FlxTimer.wait(5.5, () -> {
				sound2.play();
			});

			FlxTimer.wait(5.7, () -> {
				darnell_cutscene.playAnim('intro');
			});

			FlxTimer.wait(6.54, () -> {
				if (cutscene) {
					weirdTween = FlxTween.tween(FlxG.camera, {zoom: 0.77}, 0.3, {ease: FlxEase.elasticIn});
					weirdTween2 = FlxTween.tween(camFollow, {y: camFollow.y + 20}, 0.23, {ease: FlxEase.elasticIn});
				}
			});

			FlxTimer.wait(8, () -> {
				FlxG.sound.play(Paths.sound('nene_laugh'), 0.6);
				gf.playAnim('scene1', true);
				gf.specialAnim = true;
			});

			eventTimer = FlxTimer.wait(10.5, () -> {
				endCutscene(false);
				eventTimer = null;
			});
		});
	});

	songtxt = PluginsManager.callPluginFunc('Utils', 'menuIntroCard', ["Talkin' Smack", 'squishyzumorizu', [26, 7]]);
	add(songtxt);
}

function doNeneShit() {
	if (cutscene && !gf.specialAnim) {
		gf.dance();
		FlxTimer.wait(0.645, doNeneShit);
	}
}

function endCutscene(skip) {
	if (ClientPrefs.lowQuality)
		return;

	cutscene = false;
	FlxTween.cancelTweensOf(FlxG.camera);
	FlxTween.cancelTweensOf(camFollow);
	eventTimer.cancel();
	if (weirdTween2 != null) {
		weirdTween.cancel();
		weirdTween2.cancel();
	}

	if (cutsceneSounds.length > 0) {
		for (i in cutsceneSounds) {
			if (i != null) {
				i.volume = 0;
				i.stop();
			}
		}
	}

	if (skipTxt != null) {
		FlxTween.cancelTweensOf(skipTxt);
		FlxTween.tween(skipTxt, {y: FlxG.height}, 1, {ease: FlxEase.circIn});
	}

	cameraSpeed = 1;
	dad.alpha = 1;
	boyfriend.alpha = 1;
	darnell_cutscene.alpha = 0;
	pico_cutscene.alpha = 0;
	isCameraOnForcedPos = false;

	FlxTween.tween(FlxG.camera, {zoom: stage.stageData.defaultZoom}, skip ? 0.1 : 0.9, {ease: FlxEase.quartInOut});
	defaultCamZoom = stage.stageData.defaultZoom;

	FlxTween.tween(camHUD, {alpha: 1}, 0.6);

	if (songtxt != null) {
		FlxTween.cancelTweensOf(songtxt);
		FlxTween.tween(songtxt, {y: (FlxG.height)}, 0.5, {ease: FlxEase.quintIn});
	}

	cutsceneSong.fadeOut(1.4, 0);
	FlxTimer.wait(1.4, () -> {
		cutsceneSong.stop();
	});
	startCountdown();
}

var nene_readytokill:Bool = false;
var inTunnel:Bool = false;
var rt2 = 0;

function onUpdate(elapsed) {
	building_back.x = FlxMath.lerp(building_back.x, building_back.x - 21, FlxMath.bound(elapsed * 9, 0, 1));
	building_middle.x = FlxMath.lerp(building_middle.x, building_middle.x - 27, FlxMath.bound(elapsed * 9, 0, 1));
	building_front.x = FlxMath.lerp(building_front.x, building_front.x - 50, FlxMath.bound(elapsed * 9, 0, 1));
	light_back.x = FlxMath.lerp(light_back.x, light_back.x - 270, FlxMath.bound(elapsed * 9, 0, 1));
	street.x = FlxMath.lerp(street.x, street.x - 270, FlxMath.bound(elapsed * 9, 0, 1));
	light_front.x = FlxMath.lerp(light_front.x, light_front.x - 270, FlxMath.bound(elapsed * 9, 0, 1));

	sign.x = FlxMath.lerp(sign.x, sign.x - 140, FlxMath.bound(elapsed * 9, 0, 1));

	if (sign.x < -1280 && inTunnel != true)
		reload_sign();

	if (ClientPrefs.lowQuality)
		return;

	if (eventTimer != null && !cutscene)
		eventTimer.cancel();

	tunnelbg.x = FlxMath.lerp(tunnelbg.x, tunnelbg.x - 270, FlxMath.bound(elapsed * 9, 0, 1));

	rainTime += elapsed;
	rainTime++;

	if (ClientPrefs.shaders) {
		rainShader.setFloatArray('uCameraBounds', [
			camGame.scroll.x + camGame.viewMarginX,
			camGame.scroll.y + camGame.viewMarginY,
			camGame.scroll.x + camGame.viewMarginX + camGame.width,
			camGame.scroll.y + camGame.viewMarginY + camGame.height
		]);
		rainShader.setFloat('uTime', rainTime);
		rainShader.setFloat('uIntensity', rainIntensity);
	}

	if (cutscene && skipTxt != null) {
		if (FlxG.keys.justPressed.SPACE) {
			endCutscene(true);
		}
	}
}

function onUpdatePost(elapsed) {
	if (0.4 >= health && !nene_readytokill) {
		gf.stunned = true;
		nene_readytokill = true;
		gf.playAnim('knife1', true);
		FlxTimer.wait(0.36, () -> {
			gf.playAnim('knife2', true);
		});
	} else if (health > 0.4 && nene_readytokill) {
		gf.stunned = false;
		nene_readytokill = false;
		gf.playAnimForDuration('knife3', 0.5, true);
	}
}

var ad:Bool = false;

function reload_sign() {
	sign.x = 2000;
	ad = FlxG.random.bool(50);
	sign.y = ad ? -170 : 200;
	sign.animation.play((ad ? 'ad' : 'sign') + FlxG.random.int(1, 6), true);
}

var previous_combo:Int;

function goodNoteHit(note) {
	previous_combo = combo;

	if (combo < 50)
		return ScriptConstants.CONTINUE_FUNC;

	if (combo % 50 == 0 && !note.isSustainNote && !nene_readytokill)
		gf.playAnimForDuration(combo >= 100 ? 'cheer2' : 'cheer1', 0.7, true);
}

function noteMiss(note) {
	if (previous_combo > 10 && !nene_readytokill) {
		gf.playAnimForDuration('sad', 1.1, true);
	}
	previous_combo = combo;
}

var middle_cam:Bool = false;

function onEvent(eventName, value1, value2) {
	switch (eventName) {
		case 'Song Events':
			if (ClientPrefs.lowQuality)
				return;

			switch (value1) {
				case 'Honk Horn':
					megaphone.animation.play('megaphoneanim', true);

				case 'Tunnel':
					var trans_speed:Float = 0.3;
					switch (value2.toLowerCase()) {
						case 'on':
							inTunnel = true;
							transition.x = transition.width;
							FlxTween.tween(transition, {x: 0}, trans_speed, {
								onComplete: function(thegrandestgoon:FlxTween) {
									camGame.filters = [];
									tunnelbg.visible = true;
									light_front.visible = false;
									blend_bg.visible = false;

									truck.alpha = 0.00001;
									truckdark.alpha = 1;
									megaphone.color = 0xFF2a2471;

									changeCharacter('pico-playable-tunnel', 0);
									changeCharacter('darnell-tunnel', 1);
									gf.color = 0xFF475365;

									FlxTween.tween(transition, {x: transition.width * -1}, trans_speed);
								}
							});

						case 'off':
							transition2.x = transition2.width;
							FlxTween.tween(transition2, {x: 0}, trans_speed, {
								onComplete: () -> {
									if (ClientPrefs.shaders)
										camGame.filters = [new ShaderFilter(rainShader) /*, new ShaderFilter(rain2)*/];

									tunnelbg.visible = false;
									light_front.visible = true;
									blend_bg.visible = true;

									truck.alpha = 1;
									truckdark.alpha = 0.00001;
									megaphone.color = 0xFFFFFFFF;

									changeCharacter('pico-playable', 0);
									changeCharacter('darnell', 1);
									gf.color = FlxColor.WHITE;

									inTunnel = false;

									FlxTween.tween(transition2, {x: transition2.width * -1}, trans_speed);
								}
							});
					}
			}
	}
}

var confirmed:Bool = false;

function onGameOverStart() {
	FlxTween.cancelTweensOf(cutsceneSong);
	cutsceneSong.volume = 0;

	camGame.filters = [];

	nene_death = new FlxSprite();
	nene_death.frames = Paths.getSparrowAtlas('characters/PicoSchool/Nene/NeneKnifeToss');
	nene_death.animation.addByPrefix('idle', 'NeneGameOverDeath', 24, false);
	nene_death.animation.play('idle');
	nene_death.scrollFactor.set(1, 1);
	nene_death.setPosition(gf.x + 100, gf.y - 40);
	GameOverSubstate.instance.add(nene_death);

	nene_death.animation.finishCallback = function(hairfall:String) {
		nene_death.visible = false;
	}

	death_retry = new FlxSprite();
	death_retry.frames = Paths.getSparrowAtlas('characters/PicoSchool/Pico/playable/death');
	death_retry.animation.addByPrefix('red', 'FUCK loop red', 24, true);
	death_retry.animation.addByPrefix('retry', 'FUCK loop retry', 24, false);
	death_retry.animation.play('red');
	death_retry.scrollFactor.set(1, 1);
	death_retry.alpha = 0.0001;

	FlxTimer.wait(1.4, () -> {
		if (confirmed)
			return;
		death_retry.alpha = 1;
		death_retry.setPosition(GameOverSubstate.instance.boyfriend.x + 530, GameOverSubstate.instance.boyfriend.y + 50);
	});
}

function onGameOverPost() {
	GameOverSubstate.instance.add(death_retry);
}

function onGameOverConfirm() {
	confirmed = true;
	death_retry.setPosition(GameOverSubstate.instance.boyfriend.x + 160, GameOverSubstate.instance.boyfriend.y - 190);
	death_retry.animation.play('retry');
	death_retry.alpha = 1;

	FlxG.camera.fade(2, FlxColor.BLACK, FlxG.resetState);
}
