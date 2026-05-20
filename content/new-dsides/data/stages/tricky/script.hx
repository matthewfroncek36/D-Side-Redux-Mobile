import funkin.game.shaders.RGBPalette;

var bg_string:String = 'backgrounds/tricky/';
var bgX:Int = -300;
var bgY:Int = -620;

function onLoad() {
	var sky:FlxSprite = new FlxSprite(bgX - 100, bgY + 500);
	sky.loadGraphic(Paths.image(bg_string + "tric_sky"));
	sky.setGraphicSize(Std.int(sky.width * 1.5));
	sky.scrollFactor.set(0.4, 0.58);
	add(sky);

	if(!ClientPrefs.lowQuality){
		var f = ['correction', 'improb', 'incorrect', 'invalid'];
		errSky = new FlxBackdrop();
		errSky.frames = Paths.getSparrowAtlas(bg_string + 'signs');
		for (i in 0...4)
			errSky.animation.addByPrefix(i, f[i], 24, false);
		errSky.animation.play(1);
		errSky.velocity.x = 800;
		errSky.alpha = 0;
		add(errSky);
	}


	bg_fog = new FlxBackdrop(Paths.image(bg_string + '/tricky_fog'), FlxAxes.X, 0);
	bg_fog.y = sky.y - 400;
	bg_fog.scrollFactor.set(0.53, 0.2);
	bg_fog.blend = BlendMode.ADD;
	bg_fog.alpha = 0.2;
	bg_fog.setGraphicSize(Std.int(bg_fog.width * 1.2));
	add(bg_fog);

	var THEDICKSMASHER:FlxSprite = new FlxSprite(bgX + 900, bgY + 750);
	THEDICKSMASHER.loadGraphic(Paths.image(bg_string + "tric_smasher"));
	THEDICKSMASHER.setGraphicSize(Std.int(THEDICKSMASHER.width * 1.5));
	THEDICKSMASHER.scrollFactor.set(0.6, 0.82);
	add(THEDICKSMASHER);

	var wire:FlxSprite = new FlxSprite(bgX + 700, bgY + 350);
	wire.loadGraphic(Paths.image(bg_string + "tric_stick"));
	wire.setGraphicSize(Std.int(wire.width * 1.5));
	wire.scrollFactor.set(0.7, 0.86);
	add(wire);

	var ferris:FlxSprite = new FlxSprite(bgX + 2300, bgY - 50);
	ferris.loadGraphic(Paths.image(bg_string + "tric_ferris"));
	ferris.setGraphicSize(Std.int(ferris.width * 1.5));
	ferris.scrollFactor.set(0.87, 0.96);
	add(ferris);

	var ground:FlxSprite = new FlxSprite(bgX, bgY);
	ground.loadGraphic(Paths.image(bg_string + "tric_floor"));
	ground.setGraphicSize(Std.int(ground.width * 1.5));
	add(ground);

		var corpse1:FlxSprite = new FlxSprite(bgX - 130, bgY+ 1200);
	corpse1.loadGraphic(Paths.image(bg_string + "Body1"));
	corpse1.setGraphicSize(Std.int(corpse1.width * 1.3));
	corpse1.zIndex = 20;
	add(corpse1);

		var corpse2:FlxSprite = new FlxSprite(bgX+2100, bgY+710);
	corpse2.loadGraphic(Paths.image(bg_string + "Body2"));
	corpse2.setGraphicSize(Std.int(corpse2.width * 1));
	add(corpse2);

	var cart:FlxSprite = new FlxSprite(bgX + 2600, bgY + 1700);
	cart.loadGraphic(Paths.image(bg_string + "tric_hotdog"));
	cart.setGraphicSize(Std.int(cart.width * 1.5));
	cart.scrollFactor.set(1.1, 1);
	add(cart);
	cart.zIndex = 10;

	var fog:FlxSprite = new FlxSprite(bgX, bgY);
	fog.loadGraphic(Paths.image(bg_string + "tric_fog"));
	fog.setGraphicSize(Std.int(fog.width * 1.5));
	fog.scrollFactor.set(1.1, 1);
	add(fog);
	fog.zIndex = 10;

	dark_overlay = new FlxSprite(ground.x - 400, ground.y - 400).makeGraphic(Std.int(ground.width) + 700, Std.int(ground.height) + 800, 0xFFd4ff00);
	dark_overlay.blend = BlendMode.SUBTRACT;
	dark_overlay.alpha = 0.07;
	dark_overlay.zIndex = 999;
	add(dark_overlay);

	if(!ClientPrefs.lowQuality){
		if (ClientPrefs.shaders) {
			red = new RGBPalette();
			red.g = 0xFF00FF00;
			red.b = 0xFF0000FF;

			redG = new FlxSprite();
			redG.color = 0xFF00FF00;
			redB = new FlxSprite();
			redB.color = 0xFF0000FF;
		}

		for (item in [sky, bg_fog, THEDICKSMASHER, wire, ferris, ground, cart, fog,corpse1,corpse2]) {
			item.antialiasing = true;
			if (ClientPrefs.shaders)
				item.shader = red.shader;
		}

	}

	skipCountdown = true;
	countdownDelay = 1;
	camHUD.alpha = 0;
	camGame.alpha = 0;
}

function onCreatePost() {
	if(!ClientPrefs.lowQuality){
		if (ClientPrefs.shaders) {
			boyfriend.shader = red.shader;
			gf.shader = red.shader;
			dad.shader = red.shader;
		}
	}

	modManager.queueFuncOnce(1920, () -> {
		camHUD.fade(FlxColor.BLACK, 5);
	});
}

function onSongStart() {
	snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y - 400, true);
	camGame.zoom = 1.5;

	FlxTween.tween(camGame, {zoom: 0.55}, 5, {ease: FlxEase.quartOut});
	FlxTween.tween(camFollow, {y: getCharacterCameraPos(gf).y}, 5, {ease: FlxEase.quartOut});
	camGame.flash(FlxColor.BLACK, 6);
	camGame.alpha = 1;
	camHUD.alpha = 0;

	FlxTimer.wait(4.5, () -> {
		camZooming = true;
	});

	FlxTimer.wait(8, () -> {
		FlxTween.tween(camHUD, {alpha: 1}, 4);
		isCameraOnForcedPos = false;
	});
}

var poop = 0.01;
function onUpdate(elapsed) {
	bg_fog.x = FlxMath.lerp(bg_fog.x, bg_fog.x - 21, FlxMath.bound(elapsed * 9, 0, 1));

	dark_overlay.alpha += poop * (elapsed);
	if (dark_overlay.alpha >= 0.175)
		poop = -0.01;
	 else if(dark_overlay.alpha <= 0.05)
		poop = 0.01;
	

	if(!ClientPrefs.lowQuality){
		if (ClientPrefs.shaders) {
			red.g = redG.color;
			red.b = redB.color;
		}
	}
}

var isRed = false;
var gTween;
var bTween;
var aTween;

function opponentNoteHit(note) {
	if(ClientPrefs.lowQuality) return;

	switch (note.noteType) {
		case 'Alt Animation':
			if(!ClientPrefs.flashing || ClientPrefs.lowQuality) return;

			if (!note.isSustainNote) {
				if (gTween != null)
					gTween.cancel();
				if (bTween != null)
					bTween.cancel();
				if (aTween != null)
					aTween.cancel();

				isRed = true;
				errSky.alpha = 1;
				errSky.animation.play(FlxG.random.int(0, 4), true);

				var f = FlxG.random.int(-3, 3);
				for (i in [camGame, camHUD]) {
					i.shake(0.015, 0.005);
					i.zoom += 0.02;

					FlxTween.cancelTweensOf(i);
					FlxTween.tween(i, {angle: f}, 0.125, {ease: FlxEase.quartOut});
				}

				if (ClientPrefs.shaders) {
					redG.color = 0xFFfc6161;
					redB.color = 0xFFfc6161;
				}
			}
		default:
			if(!ClientPrefs.flashing || ClientPrefs.lowQuality) return;

			if (isRed) {
				isRed = false;

				for (i in [camGame, camHUD]) {
					FlxTween.cancelTweensOf(i);
					FlxTween.tween(i, {angle: 0}, 0.5, {ease: FlxEase.quartOut});
				}
				if (ClientPrefs.shaders) {
					gTween = FlxTween.color(redG, 0.4, redG.color, 0xFF00FF00);
					bTween = FlxTween.color(redB, 0.4, redB.color, 0xFF0000FF);
				}
				aTween = FlxTween.tween(errSky, {alpha: 0}, 0.4);
			}
	}
}
