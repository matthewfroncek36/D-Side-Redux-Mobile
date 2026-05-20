var controls = false;

var base_volume:Float;

function onLoad() {
	black = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
	black.alpha = 0;
	add(black);

	warn = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/flashing"));
	warn.alpha = 0;
	warn.scale.set(0.625, 0.625);
	warn.updateHitbox();
	warn.screenCenter();
	add(warn);

	FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.1}, 0.25, {ease: FlxEase.quartOut});
	FlxTween.tween(black, {alpha: 0.8}, 0.25);
	FlxTween.tween(warn, {alpha: 1}, 0.25);

	FlxTimer.wait(0.5, () -> {
		controls = true;
	});

	base_volume = FlxG.sound.music.volume;
	FlxG.sound.play(Paths.sound('menus/FLASHING_DISCLAIMER'));
	FlxTween.tween(FlxG.sound.music, {volume: 0.2, pitch: 0.5}, 0.5);
}

function onUpdate() {
	if (controls) {
		if (FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed){
			ClientPrefs.flashing = true;
			ClientPrefs.flush();			
			cancel();
		}
		else if (FlxG.keys.justPressed.ESCAPE) {
			ClientPrefs.flashing = false;
			ClientPrefs.flush();
			cancel();
		}
	}
}

function cancel() {
	controls = false;
	FlxTween.cancelTweensOf(black);
	FlxTween.cancelTweensOf(FlxG.camera);
	FlxTween.tween(FlxG.sound.music, {volume: base_volume, pitch: 1}, 0.25);

	FlxTween.tween(black, {alpha: 0}, 0.25);
	FlxTween.tween(warn, {alpha: 0}, 0.25);
	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.25, {ease: FlxEase.quartInOut});

	FlxTimer.wait(0.3, () -> {
		close();
	});
}
