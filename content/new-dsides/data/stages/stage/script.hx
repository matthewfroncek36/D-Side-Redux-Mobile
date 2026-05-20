import openfl.filters.ShaderFilter;
import funkin.objects.Bopper;

var audience:FlxSprite;
var audienceCheer:Bool = false;
var darkLights:Bool = false;
var audienceX:Int = -300;
var audienceY:Int = 730;
var bg_pos:Array<Float> = [-630, -270];
var bg_string:String = "backgrounds/week1";
var dark = (PlayState.SONG.song.toLowerCase() == 'dad battle') || (PlayState.SONG.song.toLowerCase() == 'bobos chicken');

function makeStageSprite(x, y, name) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas(bg_string));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}

function onLoad() {
	bg = makeStageSprite(bg_pos[0] - 115, bg_pos[1] - 50, dark ? 'dark' : 'week_1');
	bg.setGraphicSize(Std.int(bg.width * 1.3));
	bg.updateHitbox();
	bg.antialiasing = true;
	add(bg);

	if (!ClientPrefs.lowQuality) {
		bright_lighting = makeStageSprite(bg_pos[0], bg_pos[1], 'BRIGHTLIGHTS');
		bright_lighting.blend = BlendMode.ADD;
		bright_lighting.alpha = 0.05;
		bright_lighting.zIndex = 10;
		bright_lighting.setGraphicSize(Std.int(bright_lighting.width * 1.2));
		bright_lighting.antialiasing = true;

		if (dark) {
			audience = new FlxSprite(audienceX, audienceY + 300);
			audience.frames = Paths.getSparrowAtlas(bg_string);
			audience.animation.addByPrefix('idle', 'Audience0', 24, true);
			audience.animation.addByPrefix('cheer', 'AudienceCheer', 24, false);
			audience.animation.play('idle');
			audience.setGraphicSize(Std.int(audience.width * 1.2));
			audience.zIndex = 12;
			audience.antialiasing = true;
			audience.scrollFactor.set(1.07, 0.9);
			add(audience);

			boyfriendCameraOffset[1] = -100;
		}

		add(bright_lighting);
	}
	skipCountdown = dark;
}

var high_during_fresh:Bool = false;
var high_effectiveness:Float = 0;
var high_shader = newShader('high');
var trippy_shader = newShader('trippy');
var shrooms_amt:Float = 0;
var dadbattle_chorus:Bool = false;

function onCreatePost() {
	dark_lighting = new FlxSprite().makeGraphic(1300, 720, 0xFF843b00);
	dark_lighting.cameras = [camHUD];
	dark_lighting.blend = BlendMode.SUBTRACT;
	dark_lighting.alpha = 0;
	add(dark_lighting);

	orange_lighting = new FlxSprite().makeGraphic(1300, 720, 0xFF003ed9);
	orange_lighting.blend = BlendMode.SUBTRACT;
	orange_lighting.cameras = [camHUD];
	orange_lighting.alpha = 0;
	add(orange_lighting);

	// so the camera doesnt spawn way off to the side for... some reason
	snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y - 190);

	trippy_shader.setFloat('darkness', 0.55);
	if (ClientPrefs.shaders && ClientPrefs.flashing) {
		camGame.filters = [
			new ShaderFilter(high_shader),
			new ShaderFilter(trippy_shader) /*, new ShaderFilter(rain2)*/
		];
	}

	if (dark) {
		gf.danceEveryNumBeats = 2;
		camGame.alpha = 0;
		camHUD.alpha = 0;
	}

	if (PlayState.SONG.song.toLowerCase() == 'fresh') {
		modManager.queueFuncOnce(636, () -> {
			camGame.visible = false;
			camHUD.visible = false;
		});
	}

	if (PlayState.SONG.song.toLowerCase() == 'bobos chicken') {
		gf.danceEveryNumBeats = 1;
		camGame.alpha = 1;
		camZoomingMult = 0;
		FlxG.camera.zoom = 2.5;
		isCameraOnForcedPos = true;
		snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y + 50, true);
		FlxTween.tween(camFollow, {y: camFollow.y - 120}, 2, {ease: FlxEase.quadOut});

		final pos = getCharacterCameraPos(boyfriend);

		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 8, {
			startDelay: 2.125,
			ease: FlxEase.quartInOut,
			onStart: () -> {
				FlxTween.tween(audience, {y: audienceY}, 8.7, {ease: FlxEase.smootherStepOut});

				FlxTween.tween(camFollow, {x: pos.x, y: pos.y}, 8, {
					ease: FlxEase.quartInOut,
					onComplete: () -> {
						isCameraOnForcedPos = false;
						camZooming = true;
					}
				});
			}
		});

		FlxTween.tween(camHUD, {alpha: 1}, 2, {startDelay: 6});
		FlxTimer.wait(6, () -> {
			camZooming = true;
		});

		camGame.fade(FlxColor.BLACK, 5.5, true);
	}
}

var beatboxing_on:Bool = false;
var high_timer:Float = 0;
var lock_camfollow:Bool = false;

function onUpdate(elapsed) {
	if (lock_camfollow)
		FlxG.camera.snapToTarget();

	if (!ClientPrefs.lowQuality) {
		if (darkLights) {
			if (ClientPrefs.flashing) {
				shrooms_amt = FlxMath.lerp(shrooms_amt, 5, FlxMath.bound(elapsed * 0.75, 0, 1));
				dark_lighting.alpha = FlxMath.lerp(dark_lighting.alpha, 0.7, FlxMath.bound(elapsed * 2.45, 0, 1));
			}
		} else if (dadbattle_chorus) {
			if (ClientPrefs.flashing) {
				shrooms_amt = FlxMath.lerp(shrooms_amt, 5, FlxMath.bound(elapsed * 0.75, 0, 1));
				bright_lighting.alpha = FlxMath.lerp(bright_lighting.alpha, 0.15, FlxMath.bound(elapsed * 1.45, 0, 1));
				dark_lighting.alpha = FlxMath.lerp(dark_lighting.alpha, 0.2, FlxMath.bound(elapsed * 2.45, 0, 1));
			}
		} else {
			if (ClientPrefs.flashing) {
				bright_lighting.alpha = FlxMath.lerp(bright_lighting.alpha, 0.05, FlxMath.bound(elapsed * 1.45, 0, 1));
				dark_lighting.alpha = FlxMath.lerp(dark_lighting.alpha, 0, FlxMath.bound(elapsed * 1.7, 0, 1));
				shrooms_amt = FlxMath.lerp(shrooms_amt, 0, FlxMath.bound(elapsed * 4.45, 0, 1));
			}
		}

		if (ClientPrefs.flashing) {
			if (high_during_fresh) {
				orange_lighting.alpha = FlxMath.lerp(orange_lighting.alpha, 0.25, FlxMath.bound(elapsed * 1.45, 0, 1));
				high_effectiveness = FlxMath.lerp(high_effectiveness, 0.17, FlxMath.bound(elapsed * 1.45, 0, 1));
			} else {
				orange_lighting.alpha = FlxMath.lerp(orange_lighting.alpha, 0.03, FlxMath.bound(elapsed * 1.45, 0, 1));
				high_effectiveness = FlxMath.lerp(high_effectiveness, 0, FlxMath.bound(elapsed * 1.45, 0, 1));
			}
		}

		if (ClientPrefs.shaders) {
			high_timer += elapsed;

			high_shader.setFloat('iTime', high_timer);
			high_shader.setFloat('effectiveness', high_effectiveness);

			trippy_shader.setFloat('iTime', high_timer);
			trippy_shader.setFloat('intensity', shrooms_amt);
		}
	}

	if (darkLights) {
		switch (whosTurn) {
			case 'boyfriend':
				camFollow.x = 1090;
				camFollow.y = 600;
				isCameraOnForcedPos = true;
			case 'dad':
				camFollow.x = 530;
				camFollow.y = 300;
				isCameraOnForcedPos = true;
		}
	}

	if (beatboxing_on)
		defaultCamZoom = FlxMath.lerp(defaultCamZoom, 0.9, FlxMath.bound(elapsed * 0.7, 0, 1));
}

function onSongStart() {
	if (PlayState.SONG.song.toLowerCase() == 'dad battle') {
		snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y + 50, true);
		FlxTween.tween(camFollow, {y: camFollow.y - 120}, 2, {ease: FlxEase.quadOut});

		if (!ClientPrefs.lowQuality)
			audience.y += 250;

		isCameraOnForcedPos = true;

		snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y + 150, true);

		camGame.zoom += 2.75;
		FlxTween.tween(camGame, {zoom: defaultCamZoom * 1.5}, 8, {startDelay: 1, ease: FlxEase.quartInOut});

		FlxTween.tween(camFollow, {y: camFollow.y - 150}, 9, {ease: FlxEase.smootherStepOut});

		camGame.alpha = 1;
		camGame.fade(FlxColor.BLACK, 5.5, true);
	}
}

function onBeatHit() {
	if (audience != null) {
		if ((curBeat + 1) % 2 == 0) {
			if (audienceCheer) {
				setAudienceCheer(true);
			} else {
				setAudienceCheer(false);
			}
		}
	}
}

function setAudienceCheer(cheer:Bool) {
	if (ClientPrefs.lowQuality)
		return;

	if (cheer) {
		bright_lighting.alpha = ClientPrefs.flashing ? (dadbattle_chorus ? 0.8 : 0.6) : 0;
		audience.setPosition(audienceX - 190, audienceY);
		audience.animation.play('cheer', true);
		FlxTween.tween(audience, {y: audienceY - 20}, Conductor.stepCrotchet * 0.004, {
			ease: FlxEase.quadOut,
			onComplete: function(poop:FlxTween) {
				FlxTween.tween(audience, {y: audienceY}, Conductor.stepCrotchet * 0.004, {ease: FlxEase.quadIn});
			}
		});

		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
	} else if (audience.animation.curAnim.name == 'cheer') {
		audience.setPosition(audienceX, audienceY);
		audience.animation.play('idle');
	}
}

function eventEarlyTrigger(name, value1, value2) {
	if (name = 'Song Events' && value1 == 'chorus')
		return 500;
}

var middle_cam:Bool = false;

function onEvent(eventName, value1, value2) {
	switch (eventName) {
		case 'Middle Camera':
			switch (value1.toLowerCase()) {
				case 'on': middle_cam = true;
				case 'off': middle_cam = false;
				default: middle_cam = !middle_cam;
			}

			if (middle_cam) {
				FlxTimer.wait(0.01, () -> {
					camFollow.setPosition(camFollow.x + 150, 360);
					defaultCamZoom = 0.57;
				});
			} else {
				defaultCamZoom = 0.6;
			}

		case 'Song Events':
			switch (value1) {
				case 'Beatboxing':
					if (value2.toLowerCase() == 'on') beatboxing_on = true; else beatboxing_on = false;

				case 'Dark Lighting':
					darkLights = !darkLights;

					switch (darkLights) {
						case true:
							defaultCamZoom = 0.75;
							FlxTween.tween(game, {defaultCamZoom: 1.17}, PlayState.SONG.song.toLowerCase() == "bobos chicken" ? 10 : 4.31, {
								ease: FlxEase.quadIn,
								onComplete: function(tween:FlxTween) {
									FlxTween.tween(game, {defaultCamZoom: 0.6}, 0.25, {ease: FlxEase.quartIn});
								}
							});

							switch (value2) {
								case 'bf': whosTurn = 'boyfriend';
								case 'dad': whosTurn = 'dad';
							}

						case false:
							isCameraOnForcedPos = false;
							defaultCamZoom = 0.6;
					}
				case 'chorus':
					dadbattle_chorus = !dadbattle_chorus;

				case 'Audience Rising':
					if (!ClientPrefs.lowQuality)
						FlxTween.tween(audience, {y: audienceY}, 8.7, {ease: FlxEase.smootherStepOut});

					FlxTween.tween(camGame, {zoom: defaultCamZoom + 0.02}, 8, {ease: FlxEase.quadInOut});
					FlxTween.tween(camFollow, {y: camFollow.y + 70}, 9, {ease: FlxEase.smootherStepOut});

				case 'Ending':
					lock_camfollow = true;
					isCameraOnForcedPos = true;
					FlxTween.tween(camFollow, {x: (getCharacterCameraPos(gf).x), y: 450}, 0.3, {ease: FlxEase.quartOut});
					FlxTween.tween(game, {defaultCamZoom: defaultCamZoom + 0.08}, 0.35, {ease: FlxEase.elasticOut});
					dad.playAnim('ending');
					boyfriend.playAnim('laugh');
					gf.playAnim('ending');
					for (item in [dad, boyfriend, gf]) {
						item.specialAnim = true;
						item.onAnimationFinish.addOnce(() -> {
							item.playAnim(item.getAnimName() + '-loop', true);
							item.specialAnim = true;
						});
					}

					FlxTimer.wait(3.5, () -> {
						camGame.fade(FlxColor.BLACK, 1.5, false);
					});
			}

			if (!ClientPrefs.lowQuality) {
				switch (value1) {
					case 'Fresh Dimming':
						if (value2.toLowerCase() == 'on') high_during_fresh = true; else high_during_fresh = false;

					case 'Audience Cheer':
						audienceCheer = !audienceCheer;

						if (audienceCheer) setAudienceCheer(true);

					case 'chorus':
						trippy_shader.setFloat('darkness', 0.4);
				}
			}
	}
}

var gameovervoiceline:FlxSound;

function deathAnimStart() {
	if (PlayState.SONG.song.toLowerCase() == "tutorial") {
		FlxTween.tween(FlxG.sound.music, {volume: 0.5}, 0.2);

		FlxTimer.wait(0.2, () -> {
			gameovervoiceline = FlxG.sound.play(Paths.sound('gameoverlines/gf/gf_line_' + FlxG.random.int(1, 4)));
			gameovervoiceline.play();
			gameovervoiceline.onComplete = end_voiceline;
		});
	} else {
		FlxTween.tween(FlxG.sound.music, {volume: 0.5}, 0.2);
		FlxTimer.wait(0.2, () -> {
			gameovervoiceline = FlxG.sound.play(Paths.sound('gameoverlines/dad/dd_gameover_' + FlxG.random.int(1, 7)));
			gameovervoiceline.play();
			gameovervoiceline.onComplete = end_voiceline;
		});
	}
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
