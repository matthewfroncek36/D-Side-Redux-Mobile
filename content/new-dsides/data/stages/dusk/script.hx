import funkin.backend.Conductor;
import funkin.objects.Bopper;
import funkin.game.shaders.RGBPalette;
import openfl.filters.ShaderFilter;

var bgFuck = [];
var pix:Float = 0;
var intAngle:Float = 0;
var isPink:Bool = false;
var vig:FlxSprite;
var isBumpVig:Bool = false;

function onLoad() {
	var sky = new FlxSprite(-520, -400).loadFromSheet('backgrounds/dusk/dusk', 'skysky');
	sky.scrollFactor.set(0.4, 0.4);
	sky.setScale(1.1, 1.1);

	var back = new FlxSprite(-550).loadFromSheet('backgrounds/dusk/dusk', 'skybackity');
	back.scrollFactor.set(0.6, 0.6);
	back.setScale(1.1, 1.1);

	purple2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF81009A);
	purple2.scrollFactor.set();
	purple2.setScale(1.9, 1.9);
	purple2.screenCenter();
	purple2.blend = BlendMode.MULTIPLY;
	purple2.alpha = 0.3;

	var floor = new FlxSprite(-550, -290).loadFromSheet('backgrounds/dusk/dusk', 'skyfront');
	floor.setScale(1.1, 1.1);

	var cream = new FlxSprite(700, -60).loadFromSheet('backgrounds/dusk/dusk', 'skycreampng');
	cream.setScale(0.9, 0.9);

	uber = new Bopper(1200, 196);
	uber.loadAtlas('backgrounds/dusk/uberkid');
	uber.addAnimByPrefix('idle', 'uberkid', 24, false);
	uber.danceEveryNumBeats = 1;

	black = new FlxSprite(-2000, -1700).makeGraphic(1280 * 4, 720 * 4, FlxColor.BLACK);
	black.scrollFactor.set();
	black.alpha = 0;

	purple = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF81009A);
	purple.scrollFactor.set();
	purple.setScale(1.9, 1.9);
	purple.screenCenter();
	purple.zIndex = 999;
	purple.blend = BlendMode.MULTIPLY;
	purple.alpha = 0.2;

	for (i in [sky, back, purple2, floor, cream, uber, black, purple]) {
		bgFuck.push(i);
		add(i);
	}
	overlay = new FlxSprite().loadGraphic(Paths.image('backgrounds/week3/purple_mult'));
	overlay.setGraphicSize(1280 * 3, 720 * 3);
	overlay.updateHitbox();
	overlay.screenCenter();
	overlay.alpha = 0;
	overlay.blend = BlendMode.ADD;
	overlay.zIndex = 1;
	add(overlay);

	if (!ClientPrefs.lowQuality) {
		vig = new FlxSprite().loadGraphic(Paths.image('backgrounds/Vignette'));
		vig.setGraphicSize(1280, 720);
		vig.updateHitbox();
		vig.camera = camOther;
		vig.color = 0xFFFF0000;
		vig.alpha = 0;
		add(vig);
	}
}

var poo2 = -1;

function onBeatHit() {
	if (curBeat % 2 == 0)
		uber.dance();

	if (!ClientPrefs.lowQuality) {
		if (isBumpVig && curBeat % 2 == 0)
			vig.alpha = 0.4;
	}

	if (isPink) {
		overlay.alpha = 0.6;
		if (!ClientPrefs.lowQuality) {
			if (ClientPrefs.shaders)
				pix = 3;

			vig.alpha = 0.4;

			poo2 *= -1;
			intAngle = poo2;
		}
	}
}

skipCountdown = true;
countdownDelay = 0.8;
var bfShader = newShader('color-replace');
var gfShader = newShader('color-replace');
var duskShader = newShader('color-replace');
var bgShader = newShader('color-replace');
var shaders = [bfShader, gfShader, duskShader, bgShader];

function onCreatePost() {
	if (!ClientPrefs.lowQuality) {
		snapCamToPos(getCharacterCameraPos(dad).x + 500, getCharacterCameraPos(dad).y - 500, true);
		FlxG.camera.zoom = 1.4;

		camGame.alpha = 0;
		camHUD.alpha = 0;

		modManager.queueFuncOnce(16, () -> {
			camGame.alpha = 1;
			camGame.flash(FlxColor.BLACK, 4);
			FlxTween.tween(camFollow, {x: getCharacterCameraPos(boyfriend).x, y: getCharacterCameraPos(boyfriend).y}, 10);
			FlxTween.tween(camGame, {zoom: 1.25}, 10, {ease: FlxEase.quartOut});
		});

		modManager.queueFuncOnce(98, () -> {
			FlxTween.tween(camFollow, {x: getCharacterCameraPos(dad).x, y: getCharacterCameraPos(dad).y}, 5, {ease: FlxEase.quartInOut});
			FlxTween.tween(camGame, {zoom: 0.7}, 5, {ease: FlxEase.quartInOut});
		});

		modManager.queueFuncOnce(112, () -> {
			FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.quartInOut});
		});

		modManager.queueFuncOnce(128, () -> {
			isCameraOnForcedPos = false;
		});

		if (ClientPrefs.shaders) {
			var col = [253, 129, 207];
			for (i in 0...shaders.length)
				shaders[i].data.uReplaceColor.value = [col[0] / 255, col[1] / 255, col[2] / 255, 1];

			bfShader.setFloat('uBlackMax', 0.5);
			bfShader.setFloat('uBlackMin', 0.0);
			boyfriend.animateAtlas.useRenderTexture = true;

			duskShader.setFloat('uBlackMax', 0.45);
			duskShader.setFloat('uBlackMin', 0.0);
			dad.animateAtlas.useRenderTexture = true;

			gfShader.setFloat('uBlackMax', 0.45);
			gfShader.setFloat('uBlackMin', 0.0);
			gf.animateAtlas.useRenderTexture = true;

			bgShader.setFloat('uBlackMax', 0.75);
			bgShader.setFloat('uBlackMin', 0.2);

			greenHUD = newShader('blue');
			greenHUD.setFloat('hue', 0.65);
			greenHUD.setFloat('hueBlend', 1.0);
			greenHUD.setFloat('pix', 0.000001);

			mosaic = newShader('mosaic');
			mosaic.setFloatArray('uBlocksize', [1, 1]);
		}
	}
}

function onUpdate(elapsed) {
	purple.alpha = (Conductor.songPosition / songLength) * 0.17;
	purple2.alpha = (Conductor.songPosition / songLength) * 0.2;
	overlay.alpha = FlxMath.lerp(overlay.alpha, 0, FlxMath.bound(elapsed * 2.125, 0, 1));

	intAngle = FlxMath.lerp(intAngle, 0, FlxMath.bound(elapsed * 10, 0, 1));
	camHUD.angle = camGame.angle = intAngle;

	if (!ClientPrefs.lowQuality) {
		if (isBumpVig)
			vig.alpha = FlxMath.lerp(vig.alpha, 0, FlxMath.bound(elapsed, 0, 1));

		if (isPink)
			vig.alpha = FlxMath.lerp(vig.alpha, 0, FlxMath.bound(elapsed * 4, 0, 1));

		if (ClientPrefs.shaders) {
			pix = FlxMath.lerp(pix, 1, FlxMath.bound(elapsed * 6, 0, 1));
			mosaic.setFloatArray('uBlocksize', [pix, pix]);
		}
	}
}

function onEvent(name, v1, v2) {
	switch (name) {
		case 'Play Animation':
			if (v1 == 'throw') {
				dad.specialAnim = true;
				dad.onAnimationFinish.addOnce(() -> {
					dad.playAnim('throw-loop', true);
					dad.specialAnim = true;
				});
			}
		case 'Song Events':
			switch (v1) {
				case 'pink':
					switch (v2) {
						case 'start':
							isCameraOnForcedPos = true;
							camFollow.setPosition(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y);

							defaultCamZoom = 0.675;

							FlxTween.tween(PlayState.instance, {defaultCamZoom: 1.8}, (Conductor.stepCrotchet / 1000) * 8, {
								ease: FlxEase.backIn,
								onComplete: () -> {
									pink();
									pix = 10;
									camGame.flash(FlxColor.PINK, 3);

									// isCameraOnForcedPos = false;
									defaultCamZoom = 0.7;
									// camGame.zoom = 0.7;
								}
							});
						// pink();
						case 'off':
							camGame.flash(FlxColor.PINK, 3);
							isCameraOnForcedPos = false;
							camZoomingMult = 1;
							isPink = false;

							if (!ClientPrefs.lowQuality) {
								vig.alpha = 0;
								if (ClientPrefs.shaders) {
									camGame.removeShader(mosaic);
									camHUD.removeShader(mosaic);

									FlxTween.num(1, 0.00001, 3, {
										onUpdate: (t) -> {
											greenHUD.setFloat('hueBlend', t.value);
										}
									});
									for (i in [dad, boyfriend, gf]) {
										i.shader = null;
										i.color = FlxColor.WHITE;
									}
									for (i in bgFuck) {
										i.shader = null;
										i.color = FlxColor.WHITE;
									}
								}
							}

							intAngle = 0;
					}
				case 'vig automate':
					isBumpVig = !isBumpVig;
				case 'vig':
					if (ClientPrefs.lowQuality)
						return;
					FlxTween.cancelTweensOf(vig);

					var poop:Array<Dynamic> = v2.split(', ');
					FlxTween.tween(vig, {alpha: poop[0]}, poop[1], {ease: FlxEase.circOut});
				case 'vig color':
					if (ClientPrefs.lowQuality)
						return;

					vig.color = FlxColor.fromString(v2);

				case 'black':
					FlxTween.cancelTweensOf(black);

					var poop:Array<Dynamic> = v2.split(', ');
					FlxTween.tween(black, {alpha: poop[0]}, poop[1], {ease: FlxEase.circOut});
			}
	}
}

function pink() {
	isPink = true;
	isBumpVig = false;

	camZoomingMult = 1.4;

	purple.visible = false;
	purple2.visible = false;

	if (!ClientPrefs.lowQuality) {
		vig.color = FlxColor.PINK;

		if (ClientPrefs.shaders) {
			for (i in bgFuck) {
				i.color = 0xFFe60505;
				i.shader = bgShader;
			}
			var col:FlxColor = FlxColor.fromRGB(253, 129, 207);

			boyfriend.shader = bfShader;
			gf.shader = duskShader;
			dad.shader = duskShader;
			dad.color = col;

			camGame.addShader(mosaic);
			camHUD.addShader(mosaic);
			camHUD.addShader(greenHUD);
		}
	}

	camGame.angle = -1;
	camHUD.angle = -1;
}
