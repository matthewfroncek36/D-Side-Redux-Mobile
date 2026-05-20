import funkin.utils.CameraUtil;
import funkin.backend.Conductor;
import openfl.filters.ShaderFilter;
import funkin.game.shaders.HSLColorSwap;
import funkin.game.shaders.WiggleEffect;
import animate.FlxAnimateFrames;
import animate.FlxAnimate;
import funkin.scripting.PluginsManager;
import flixel.util.FlxStringUtil;
import flixel.text.FlxText;

var skipIntro:Bool = ClientPrefs.lowQuality;
var black:FlxSprite;
var grayscale = new HSLColorSwap();
grayscale.saturation = -0.5;
var wave = new WiggleEffect();
wave.waveSpeed = 1.5;
if (!skipIntro) {
	wave.waveFrequency = 8;
	wave.waveAmplitude = 0.06125 * 1.25;
}
wave.shader.effectType.value = [1];
var high_effectiveness:Float = 0;
var geeked:Bool = false;
var highamnt = 0.425;
var high = newShader('high');
var bgCam = FlxCamera;
var bambino:Character;
var cutscene:FunkinVideoSprite;
var cutscene2:FunkinVideoSprite;

function makeStageSprite(x, y, name) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas('backgrounds/week2/week2evil'));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}

function onLoad() {
	if (!ClientPrefs.lowQuality) {
		bgCam = new FlxCamera(0, 0, 1280, 720, 1);
		if (ClientPrefs.shaders && ClientPrefs.flashing) {
			bgCam.filters = [
				new ShaderFilter(wave.shader),
				new ShaderFilter(grayscale.shader),
				new ShaderFilter(high)
			];
		}
		FlxG.cameras.insert(bgCam, FlxG.cameras.list.indexOf(camGame), false);
		followingCams.push(bgCam);

		camGame.bgColor = 0x0;
	}

	bgOld = new FlxSprite(-526, -318).setFrames(Paths.getSparrowAtlas('backgrounds/week2/week2'));
	bgOld.animation.addByPrefix('week2', 'week_22', 24, true);
	bgOld.animation.play('week2');
	bgOld.scale.set(1.2, 1.2);
	add(bgOld);

	bg = makeStageSprite(-514, -313, 'week_2monster');
	bg.animation.addByPrefix('evil', 'week_2darkmonster', 24, false);
	bg.scale.set(1.2, 1.2);
	bg.antialiasing = true;
	add(bg);

	if (!skipIntro) {
		bgOld.camera = bgCam;
		bg.camera = bgCam;

		creatureFeature = new FlxSpriteGroup();
		creatureFeature.zIndex = 999;
		add(creatureFeature);

		monsterPos = [
			[-550, 265],
			[-625, 200],
			[20, 700],
			[625, 750],
			[1300, 900],
			[1350, 450],
			[1500, -100]
		];
		for (i in 1...8) {
			var monster = makeStageSprite(0, 0, 'Week2Friends');
			monster.animation.addByPrefix('idle', 'Monster' + i + '0', 24, true);
			monster.animation.addByPrefix('cheer', 'Monster' + i + 'Cheer', 24, false);
			monster.animation.play('idle');
			monster.scrollFactor.set(1.5, 1.2);
			monster.alpha = 0;
			monster.setPosition(monsterPos[i - 1][0], monsterPos[i - 1][1]);
			creatureFeature.add(monster);
		}

		black = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		black.camera = camHUD;
		black.scrollFactor.set();
		add(black);
	}
}

function onCreatePost() {
	warning = new FlxSprite().loadGraphic(Paths.image('cutscenes/monster/warn'));
	warning.camera = camOther;
	warning.scale.set(0.65, 0.65);
	warning.updateHitbox();
	warning.screenCenter(FlxAxes.Y);
	warning.x = FlxG.width - warning.width - 20;
	warning.alpha = 0;
	add(warning);

	warningTxt = new FlxText();
	warningTxt.setFormat(Paths.font('Pixim.otf'), 60, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	warningTxt.text = '0:00';
	warningTxt.camera = camOther;
	warningTxt.screenCenter(FlxAxes.Y);
	warningTxt.x = warning.x + (warning.width - warningTxt.width) / 2;
	warningTxt.alpha = 0;
	add(warningTxt);

	bambino = new Character(550, -550, 'monsterlemon');
	bambino.y -= bambino.height;
	add(bambino);

	getFieldFromID(2).autoPlayed = true;
	getFieldFromID(2).playerControls = false;
	getFieldFromID(2).owner = bambino;
	getFieldFromID(2).singers = [bambino];

	modManager.queueFuncOnce(1366, (s, s2) -> {
		cameraSpeed = 1;
		defaultCamZoom = 0.675;

		bambino.y = -550;
		bambino.canDance = false;
		bambino.playAnim('intro', true);
		FlxTimer.wait(1, () -> {
			bambino.canDance = true;
		});
	});

	modManager.queueFuncOnce(1638, (s, s2) -> {
		bambino.canDance = false;
		bambino.playAnim('intro', true, true);

		FlxTimer.wait(1.425, () -> {
			bambino.visible = false;
		});
	});

	modManager.queueFuncOnce(1820, () -> {
		FlxTween.tween(warning, {alpha: 1}, 2);
		FlxTween.tween(warningTxt, {alpha: 1}, 2);

		if (!ClientPrefs.opponentStrums)
			FlxTween.tween(getFieldFromID(1), {baseAlpha: 1}, 4);
	});
	modManager.queueFuncOnce(1888, () -> {
		FlxTween.tween(warning, {alpha: 0}, 2);
		FlxTween.tween(warningTxt, {alpha: 0}, 2);
	});

	modManager.queueFuncOnce(1870, () -> {
		getFieldFromID(1).noteSplashes = true;
		getFieldFromID(1).playerControls = true;
		getFieldFromID(1).autoPlayed = cpuControlled;
		// getFieldFromID(1).ID = 0;
	});

	modManager.queueFuncOnce(2080, () -> {
		getFieldFromID(1).playerControls = false;
		getFieldFromID(1).autoPlayed = true;
		getFieldFromID(1).noteSplashes = false;

		if (!ClientPrefs.opponentStrums)
			FlxTween.tween(getFieldFromID(1), {baseAlpha: 0}, 4);

		// getFieldFromID(1).ID = 1;
	});

	modManager.setValue("alpha", 1, 2);
	modManager.setValue("transformY", ClientPrefs.downScroll ? 300 : -300, 2);
	modManager.queueEase(1366, 1374, "alpha", 0, 'linear', 2);
	modManager.queueEase(1366, 1374, "transformY", ClientPrefs.downScroll ? 50 : -50, 'bounceOut');

	modManager.queueEase(1366, 1374, "transformZ", -0.125, 'bounceOut');
	modManager.queueEase(1366, 1374, "transformX", 145, 'bounceOut', 0);
	modManager.queueEase(1366, 1374, "transformX", -145, 'bounceOut', 1);
	modManager.queueEase(1366, 1374, "transformY", ClientPrefs.downScroll ? 50 : -50, 'bounceOut');

	modManager.queueEase(1606, 1622, "alpha", 1, 'linear', 2);
	modManager.queueEase(1606, 1622, "transformX", 0, 'quartInOut');
	modManager.queueEase(1606, 1622, "transformY", 0, 'quartInOut');
	modManager.queueEase(1606, 1622, "transformZ", 0, 'quartInOut');

	modManager.queueEase(1648, 1712, "alpha", 1, 'linear', 0);
	modManager.queueEase(1872, 1888, "opponentSwap", 0.5, 'backIn');
	modManager.queueEase(1872, 1888, "alpha", 0.2, 'backIn', 1);

	modManager.queueEase(2080, 2140, "alpha", 1, 'linear', 1);

	modManager.queueSet(2368, "alpha", 0, 0);
	modManager.queueSet(2368, "alpha", 0, 1);
	modManager.queueSet(2368, "opponentSwap", 0);

	modManager.queueEase(2416, 2432, "opponentSwap", 0.5, 'quartInOut');
	modManager.queueEase(2416, 2432, "alpha", 1, 'quartInOut', 1);

	if (!skipIntro) {
		bambino.camera = bgCam;

		monsterAnims = new Character(-62, 198, 'monster-anims');
		monsterAnims.visible = false;
		monsterAnims.onAnimationFinish.add((name) -> {
			monsterAnims.visible = false;
			dad.visible = true;

			FlxTimer.wait(0.5, monsterAnims.kill);
		});
		add(monsterAnims);
		gfGroup.camera = bgCam;

		bfAnim = new FlxSprite(boyfriendGroup.x + 55, boyfriendGroup.y + boyfriend.y - 150).setFrames(Paths.getSparrowAtlas('cutscenes/monster/BFAnims'));
		bfAnim.animation.addByPrefix('taunt', 'BFCooCoo', 24, true);
		bfAnim.animation.addByPrefix('laugh', 'BFLaugh', 24, true);
		bfAnim.animation.addByPrefix('blah', 'BFBlah', 24, true);
		bfAnim.animation.play('taunt');
		bfAnim.visible = false;
		add(bfAnim);

		thoughtBubble = new FlxSprite(500, 150).setFrames(Paths.getSparrowAtlas('cutscenes/monster/bubble'));
		thoughtBubble.animation.addByPrefix('bubble', 'bub', 24, false);
		thoughtBubble.animation.addByPrefix('pop', 'pop', 24, false);
		thoughtBubble.animation.play('bubble');
		thoughtBubble.visible = false;
		add(thoughtBubble);

		cutscene = new FunkinVideoSprite();
		cutscene.onFormat(() -> {
			cutscene.camera = camOther;
			cutscene.setGraphicSize(1290);
			cutscene.updateHitbox();
		});
		cutscene.load(Paths.video('Chester'), [FunkinVideoSprite.muted]);
		cutscene.onEnd(() -> {
			camHUD.flash(FlxColor.RED, 2);
		});
		add(cutscene);

		cutscene2 = new FunkinVideoSprite();
		cutscene2.onFormat(() -> {
			cutscene2.camera = camOther;
			cutscene2.setGraphicSize(1290);
			cutscene2.updateHitbox();
		});
		cutscene2.load(Paths.video('ChesterEnd'), [FunkinVideoSprite.muted]);
		add(cutscene2);

		skipCountdown = true;
		camHUD.zoom = 1.8;
		defaultHudZoom = 1.8;

		if (ClientPrefs.shaders && ClientPrefs.flashing)
			camGame.filters = [new ShaderFilter(grayscale.shader), new ShaderFilter(wave.shader)];

		dad.visible = false;
		gf.danceEveryNumBeats = 4;
		boyfriend.danceEveryNumBeats = 4;

		isCameraOnForcedPos = true;
		camFollow.x = (800);
		camFollow.y = (450);
		var time = 20;
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, time);
		FlxTween.tween(camFollow, {x: 0, y: 500}, time * 0.5, {startDelay: time * 0.5});

		modManager.queueFuncOnce(240 - 16, (s, s2) -> {
			monsterAnims.visible = true;
			monsterAnims.playAnim('intro');
		});
		modManager.queueFuncOnce(256, (s, s2) -> {
			camZooming = true;
			defaultCamZoom = 1.105;
		});
		modManager.queueFuncOnce(288, (s, s2) -> {
			FlxTween.tween(camFollow, {x: 200}, 5);
			FlxTween.tween(FlxG.camera, {zoom: 1}, 5);
			boyfriend.danceEveryNumBeats = 4;
		});
		modManager.queueFuncOnce(368, (s, s2) -> {
			FlxG.camera.zoom = 1.3;
			defaultCamZoom = 1.3;
			snapCamToPos(1250, 575);
			boyfriend.playAnim('singUP');
		});
		modManager.queueFuncOnce(372, (s, s2) -> {
			snapCamToPos(200, 450);
		});
		modManager.queueFuncOnce(384, (s, s2) -> {
			camZooming = true;
			isCameraOnForcedPos = false;
			cameraSpeed = 0.5;
			FlxTween.tween(PlayState.instance, {defaultHudZoom: 1}, 2);
		});
		modManager.queueFuncOnce(415, (s, s2) -> {
			cameraSpeed = 1;
			defaultCamZoom = 0.75;
			gf.danceEveryNumBeats = 2;
			boyfriend.danceEveryNumBeats = 2;
		});

		modManager.queueFuncOnce(1072, () -> {
			camGame.filters = [];

			var pos = ClientPrefs.downScroll ? -200 : 200;
			for (i in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2])
				FlxTween.tween(i, {y: i.y + pos}, 1, {ease: FlxEase.backIn});

			var pos = ClientPrefs.downScroll ? 200 : -200;
			for (i in [playHUD.timeBar, playHUD.timeTxt])
				FlxTween.tween(i, {y: i.y + pos}, 1, {ease: FlxEase.backIn});

			wave.waveFrequency = 8;
			wave.waveSpeed = 4;
			FlxTween.tween(wave, {waveAmplitude: 0.06125 * 1.25}, 1);
			FlxTween.tween(grayscale, {saturation: -0.25, lightness: 0.5}, 1);

			isCameraOnForcedPos = true;
			camZooming = true;
			FlxTween.tween(camFollow, {x: getCharacterCameraPos(gf).x, y: getCharacterCameraPos(gf).y + 90}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.5}, 1, {ease: FlxEase.backIn});
		});

		modManager.queueFuncOnce(1087, () -> {
			geeked = true;
			highamnt = 0.25;
			camZoomingMult = 1.625;

			FlxTween.cancelTweensOf(PlayState.instance, ["defaultCamZoom"]);
			FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.625}, 0.25, {ease: FlxEase.circOut});
		});

		modManager.queueFuncOnce(1344, () -> {
			FlxTween.tween(wave, {waveAmplitude: 0}, 1);
			FlxTween.tween(grayscale, {saturation: 0, lightness: 0}, 1);
			isCameraOnForcedPos = false;
			cameraSpeed = 0.5;
			camZoomingMult = 1;
			geeked = false;
		});

		modManager.queueFuncOnce(1638, (s, s2) -> {
			isCameraOnForcedPos = true;
			FlxTween.tween(camFollow, {x: getCharacterCameraPos(gf).x - 50, y: getCharacterCameraPos(dad).y - 50}, 8.5, {ease: FlxEase.quadInOut});
			FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.6}, 8.5, {ease: FlxEase.quadInOut});

			for (i in creatureFeature.members)
				FlxTween.tween(i, {alpha: 0.9}, 12);
		});

		modManager.queueFuncOnce(1872, (s, s2) -> {
			FlxTween.tween(camFollow, {x: getCharacterCameraPos(gf).x, y: getCharacterCameraPos(gf).y}, 1.5, {ease: FlxEase.quartOut});
			FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.5}, 1.5, {ease: FlxEase.quadInOut});
		});
		if (ClientPrefs.flashing) {
			var rhymeSteps = [1888, 1920, 2016, 2048];
			var fuck = 1;
			for (i in rhymeSteps) {
				for (j in [i, i + 4]) {
					modManager.queueFuncOnce(j, (s, s2) -> {
						fuck *= -1;
						camGame.zoom += 0.025;
						for (h in [bgCam, camGame, camHUD]) {
							h.angle = 2 * fuck;
							FlxTween.cancelTweensOf(h);
							FlxTween.tween(h, {angle: 0}, 0.75, {ease: FlxEase.quadOut});
						}

						for (i in creatureFeature.members) {
							i.animation.play('cheer', true);
							i.animation.finishCallback = () -> {
								i.animation.play('idle', true);
								i.animation.finishCallback = null;
							}
						}
					});
				}
			}
		}

		modManager.queueFuncOnce(2074, (s, s2) -> {
			isCameraOnForcedPos = false;
			defaultCamZoom = 0.7;
		});

		modManager.queueFuncOnce(2086, (s, s2) -> {
			dad.visible = false;
			monsterAnims.revive();
			monsterAnims.visible = true;
			monsterAnims.playAnim('anim2');

			FlxTween.tween(PlayState.instance, {defaultCamZoom: 1.125}, 5.25, {ease: FlxEase.quadInOut});
			for (i in creatureFeature.members)
				FlxTween.tween(i, {alpha: 0}, 6);

			FlxTimer.wait(3, () -> {
				thoughtBubble.visible = true;
				thoughtBubble.animation.play('bubble', true);
			});

			FlxTimer.wait(5, () -> {
				boyfriend.visible = false;
			});
		});

		modManager.queueFuncOnce(2144, (s, s2) -> {
			camFollow.y += 100;
			FlxTween.tween(camHUD, {alpha: 0}, 0.125);
			FlxTween.cancelTweensOf(PlayState.instance, ['defaultCamZoom']);
			defaultCamZoom = 0.9;

			thoughtBubble.animation.play('pop', true);
			snapCamToPos(325, 450, true);

			FlxTimer.wait(0.5, () -> {
				thoughtBubble.visible = false;
				thoughtBubble.kill();
			});
		});

		modManager.queueFuncOnce(2170, (s, s2) -> {
			snapCamToPos(1250, 635, true);
			boyfriend.visible = true;
			boyfriend.playAnimForDuration('hey', 0.6, true);
		});

		modManager.queueFuncOnce(2176, (s, s2) -> {
			snapCamToPos(325, 525);
		});

		modManager.queueFuncOnce(2218, (s, s2) -> {
			snapCamToPos(1250, 635, true);
			camGame.zoom = 0.9;
			defaultCamZoom = 0.9;

			boyfriend.visible = false;
			bfAnim.visible = true;
			bfAnim.animation.play('blah', true);
		});

		modManager.queueFuncOnce(2232, (s, s2) -> {
			snapCamToPos(325, 525);

			camGame.zoom = 0.7;
			defaultCamZoom = 0.7;
		});

		modManager.queueFuncOnce(2246, (s, s2) -> {
			snapCamToPos(1250, 615, true);
			defaultCamZoom = 0.9;
			camGame.zoom = 0.9;
			camGame.zoom += 0.1;

			bfAnim.animation.play('laugh', true);
		});
		modManager.queueFuncOnce(2250, (s, s2) -> {
			camGame.zoom += 0.1;

			bfAnim.animation.play('laugh', true);
		});
		modManager.queueFuncOnce(2254, (s, s2) -> {
			snapCamToPos(325, 525);

			camGame.zoom = 0.8;
			defaultCamZoom = 0.8;
		});

		modManager.queueFuncOnce(2286, (s, s2) -> {
			snapCamToPos(1250, 615, true);

			bfAnim.animation.play('taunt', true);
		});

		modManager.queueFuncOnce(2296, (s, s2) -> {
			snapCamToPos(325, 525);
			defaultCamZoom = 0.7;
			camGame.zoom = 0.7;
			boyfriend.visible = true;
			bfAnim.visible = false;
		});

		modManager.queueFuncOnce(2272, (s, s2) -> {
			FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.8}, 4, {ease: FlxEase.quadInOut});
		});

		modManager.queueFuncOnce(2316, (s, s2) -> {
			FlxTween.cancelTweensOf(PlayState.instance, ['defaultCamZoom']);
			FlxG.camera.shake(0.005, 0.125);
			bgCam.shake(0.005, 0.125);
			defaultCamZoom = 1;
		});

		modManager.queueFuncOnce(2336, (s, s2) -> {
			defaultCamZoom = 0.825;
			camFollow.x += 325;
			FlxG.camera.shake(0.005, 0.125);
			bgCam.shake(0.005, 0.125);

			black.camera = camOther;
			FlxTween.tween(black, {alpha: 1}, 1, {startDelay: 0.2});
			FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.7}, 1.75, {ease: FlxEase.quadInOut, startDelay: 0.2});
		});

		modManager.queueFuncOnce(2364, (s, s2) -> {
			camGame.filters = [new ShaderFilter(high)];
			camGame.zoom = 1;
			defaultCamZoom = 1;
			FlxTween.tween(camHUD, {alpha: 1}, 1);
			cutscene.play();

			monsterAnims.visible = false;
			dad.visible = true;

			FlxTimer.wait(0.5, monsterAnims.kill);

			changeCharacter('bf-monster-dark', 0);
			changeCharacter('monster-dark', 1);
			changeCharacter('gf-monster-dark', 2);
		});

		modManager.queueFuncOnce(2432, (s, s2) -> {
			isCameraOnForcedPos = false;
			defaultCamZoom = 0.625;
			camZoomingMult = 2.25;

			FlxG.camera.flash(FlxColor.WHITE, 1);
			black.alpha = 0;
			bg.animation.play('evil', true);

			snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y, true);

			bambino.visible = false;
			for (i in creatureFeature.members)
				i.visible = true;

			dad.camera = camHUD;
			dad.setPosition(0, FlxG.height);

			boyfriend.camera = camHUD;
			boyfriend.setPosition(825, FlxG.height);

			FlxTween.tween(dad, {y: 90}, 1, {ease: FlxEase.circOut});
			FlxTween.tween(boyfriend, {y: 350}, 1, {startDelay: 1.625, ease: FlxEase.circOut});

			wave.waveFrequency = 8;
			wave.waveAmplitude = 0.06125 * 1.25;
			wave.waveSpeed = 2.5;
			geeked = true;
			highamnt = 0.425;
		});

		modManager.queueFuncOnce(2640, () -> {
			geeked = false;
			defaultCamZoom = 0.5;
			camGame.visible = false;
			bgCam.visible = false;
			bambino.visible = false;

			bg.animation.play('week_2monster', true);
			grayscale.saturation = 0;
			grayscale.lightness = 0;
			grayscale.hue = 0;

			wave.waveFrequency = 4;
			wave.waveAmplitude = 0.06125 * 1.25;
			wave.waveSpeed = 0.75;
			camZooming = false;

			beatsPerZoom = 99999;
			dad.visible = false;
			boyfriend.visible = false;
		});

		modManager.queueFuncOnce(2672, () -> {
			FlxTween.tween(camHUD, {alpha: 0}, 1);
			gf.visible = false;
			snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(dad).y, true);
			bgCam.visible = true;

			bgOld.alpha = 0;
			bg.alpha = 0;
			FlxTween.tween(bg, {alpha: 1}, 15, {
				onComplete: () -> {
					bgOld.alpha = 1;
					FlxTween.tween(bg, {alpha: 0}, 30);
				}
			});
		});

		modManager.queueFuncOnce(3120, () -> {
			bgCam.visible = false;
		});

		modManager.queueFuncOnce(3152, () -> {
			cutscene2.play();
		});

		modManager.setValue("tipsySpeed", 3);
		modManager.queueEase(1072, 1088, "opponentSwap", 0.5, 'quartInOut');
		modManager.queueEase(1072, 1088, "alpha", 1, 'quartInOut', 1);

		if (ClientPrefs.modcharts) {
			modManager.queueEase(1072, 1088, "tipsy", 0.25, 'quartInOut');

			modManager.queueFunc(1088 - 4, 1344 + 12, function(event, step) {
				var prog = 0;
				var inLen = 8;
				var outLen = 12;

				var localStep = step - (1088 - 4);
				var endStep = 1344 - 1088;
				if (localStep <= inLen) {
					prog = localStep / inLen;
				} else if (localStep >= endStep + outLen) {
					prog = 0;
				} else if (localStep >= endStep) {
					prog = 1 - ((localStep - endStep) / outLen);
				} else
					prog = 1;

				var s = FlxMath.fastSin(3.14 * (step / 4));
				var c = FlxMath.fastCos(3.14 * (step / 4));

				modManager.setValue("transformX", c * 45 * prog);
				modManager.setValue("transformY", -Math.abs(s * 45 * prog));
				modManager.setValue("confusion", c * (45 / 4) * prog);
				modManager.setValue("flip", s * (0.125) * prog);
				modManager.setValue("stretch", c * (0.25) * prog);
				modManager.setValue("squish", s * (0.25 * 0.75) * prog);
			});
		}

		modManager.queueEase(1344, 1360, "opponentSwap", 0, 'quartInOut');
		modManager.queueEase(1344, 1360, "alpha", 0, 'quartInOut', 1);
		modManager.queueEase(1344, 1360, "tipsy", 0, 'quartInOut');

		if (ClientPrefs.modcharts) {
			modManager.queueEase(2416, 2432, "tipsy", 0.25, 'quartInOut');

			modManager.queueFunc(2432 - 4, 2640 + 12, function(event, step) {
				var prog = 0;
				var inLen = 8;
				var outLen = 12;

				var localStep = step - (2432 - 4);
				var endStep = 2640 - 2432;
				if (localStep <= inLen) {
					prog = localStep / inLen;
				} else if (localStep >= endStep + outLen) {
					prog = 0;
				} else if (localStep >= endStep) {
					prog = 1 - ((localStep - endStep) / outLen);
				} else
					prog = 1;

				var s = FlxMath.fastSin(3.14 * (step / 4));
				var c = FlxMath.fastCos(3.14 * (step / 4));

				modManager.setValue("transformX", c * 45 * prog);
				modManager.setValue("transformY", -Math.abs(s * 45 * prog));
				modManager.setValue("confusion", c * (45 / 4) * prog);
				modManager.setValue("flip", s * (0.125) * prog);
				modManager.setValue("stretch", c * (0.25) * prog);
				modManager.setValue("squish", s * (0.25 * 0.75) * prog);
			});
		}

		addCharacterToList('bf-monster-dark', 0);
		addCharacterToList('monster-dark', 1);
		addCharacterToList('gf-monster-dark', 2);
	} else {
		defaultCamZoom = 0.75;
		camZooming = true;
		grayscale.saturation = 0;
	}
}

function onSongStart() {
	if (!skipIntro) {
		FlxTween.tween(black, {alpha: 0}, 22, {ease: FlxEase.quadInOut});
		FlxTween.tween(wave, {waveFrequency: 0, waveAmplitude: 0}, 17, {ease: FlxEase.quadInOut, startDelay: 8});
		FlxTween.tween(grayscale, {saturation: 0}, 17, {
			ease: FlxEase.quadInOut,
			startDelay: 8,
			onComplete: () -> {
				grayscale.saturation = 0;
				camGame.filters = [new ShaderFilter(wave.shader), new ShaderFilter(high)];
			}
		});
	}
}

var f = 1;

function onBeatHit() {
	if (skipIntro)
		return;

	if (geeked)
		high_effectiveness = highamnt;

	bambino.onBeatHit(curBeat);

	if (beatsPerZoom == 1) {
		f *= -1;
		for (i in [camGame, bgCam]) {
			FlxTween.cancelTweensOf(i, ["angle"]);
			i.angle = f;
			FlxTween.tween(i, {angle: 0}, 0.2, {ease: FlxEase.circOut});
		}
	}
}

var timer = 0;

function onUpdate(elapsed) {
	if (warningTxt.alpha > 0 && warningTxt != null) {
		var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.noteOffset);
		var songCalc:Float = (156000 - curTime);
		var secondsTotal:Int = Math.floor(songCalc / 1000);
		if (secondsTotal < 0)
			secondsTotal = 0;

		warningTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
		warningTxt.x = warning.x + (warning.width - warningTxt.width) / 2;
	}

	if (skipIntro)
		return;

	wave.update(elapsed);
	high_effectiveness = FlxMath.lerp(high_effectiveness, geeked ? 0.1 : 0, FlxMath.bound(elapsed * 3, 0, 1));

	timer += elapsed;
	high.setFloat('iTime', timer);
	high.setFloat('effectiveness', high_effectiveness);

	for (i in playFields.members[2].members) {
		i.rgbShader.setColors([0xFFfe600, FlxColor.WHITE, 0xFF7d6919]);
	}
}

function onSpawnNotePost(note) {
	if (note.lane == 2)
		note.setCustomColor([0xFFfe600, FlxColor.WHITE, 0xFF7d6919]);
}

function onEvent(eventName, value1, value2) {
	if (eventName == 'Song Events') {
		switch (value1) {
			case 'Evil Swirl':
				var time = (Conductor.stepCrotchet / 1000) * 16;

				camGame.filters = [];
				wave.waveSpeed = 5;

				FlxTween.tween(wave, {waveFrequency: 20, waveAmplitude: 0.125 / 4}, time, {ease: FlxEase.quadInOut});
				FlxTween.tween(grayscale, {saturation: -0.5, lightness: -0.125}, time, {ease: FlxEase.quadOut});
				FlxTween.num(defaultCamZoom, 0.65, time, {
					ease: FlxEase.quadOut,
					onUpdate: (t) -> {
						defaultCamZoom = t.value;
					}
				});
		}
	}
	if (eventName == 'Middle Camera') {
		switch (value1) {
			case 'on':
				gf.danceEveryNumBeats = 1;
				defaultCamZoom = 0.47;
				beatsPerZoom = 1;
				camZoomingMult = 1.5;
				for (m in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2, playHUD.scoreTxt])
					FlxTween.tween(m, {y: m.y + 200}, 1, {ease: FlxEase.quadIn});
				for (m in [playHUD.timeBar, playHUD.timeTxt])
					FlxTween.tween(m, {y: m.y - 100}, 1, {ease: FlxEase.quadIn});

			case 'off':
				defaultCamZoom = 0.7;
		}
	}
}

var gameovervoiceline:FlxSound;

function deathAnimStart() {
	FlxTween.tween(FlxG.sound.music, {volume: 0.5}, 0.2);
	FlxTimer.wait(0.2, () -> {
		gameovervoiceline = FlxG.sound.play(Paths.sound('gameoverlines/chester/chester_line_' + FlxG.random.int(1, 11)));
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
