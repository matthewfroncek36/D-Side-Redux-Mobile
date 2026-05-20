import funkin.utils.NoteUtil;

function onLoad() {
	bgWindowColor = new BGSprite('backgrounds/ourple/lore/lore_normal_bg_windowcolor', -238, -321, 1.0, 1.0);
	add(bgWindowColor);

	bgWindowNormal = new BGSprite('backgrounds/ourple/lore/lore_normal_bg_window', -238, -321, 1.0, 1.0);
	add(bgWindowNormal);

	bgWindowBroken = new BGSprite('backgrounds/ourple/lore/lore_broken_bg', -238, -321, 1.0, 1.0);
	bgWindowBroken.visible = false;
	add(bgWindowBroken);

	bgWindowColor.zIndex = 0;
	gfGroup.zIndex = 1;
	bgWindowNormal.zIndex = 2;
	dadGroup.zIndex = 3;
	boyfriendGroup.zIndex = 3;
}

function onCreatePost() {
	camFollow.setPosition(1000, 500);
	FlxG.camera.snapToTarget();
	initScript('data/scripts/ourple_hud');

	gfGroup.visible = false;
	camZooming = true;

	bubble = new FlxSprite(1600, -150);
	bubble.frames = Paths.getSparrowAtlas('backgrounds/ourple/lore/speech');
	bubble.animation.addByPrefix('appear', 'Bubble Appear', 24, false);
	bubble.animation.addByPrefix('loop', 'Bubble_Loop', 24, true);
	bubble.animation.addByPrefix('intro1', 'Intro1', 24, true);
	bubble.animation.addByPrefix('intro2', 'Intro2', 24, true);
	bubble.animation.addByPrefix('intro3', 'Intro3', 24, true);
	bubble.animation.addByPrefix('run', 'Run', 24, true);
	bubble.animation.play('appear');
	bubble.scale.set(1.5, 1.5);
	bubble.updateHitbox();
	bubble.zIndex = 5;
	bubble.visible = false;
	stage.add(bubble);
	refreshZ(stage);

	die = new FlxSprite().loadGraphic(Paths.image('backgrounds/ourple/dead'));
	die.camera = camHUD;
	die.scale.set(1.5, 1.5);
	die.updateHitbox();
	die.screenCenter();
	die.alpha = 0;
	add(die);

	modManager.queueFuncOnce(1544, (s, s2) -> {
		FlxTween.tween(camHUD, {alpha: 0}, 1);
		bubble.visible = true;
		bubble.animation.play('appear');
		FlxTimer.wait(0.25, () -> {
			bubble.animation.play('intro1');
		});

		dad.idleSuffix = '-alt';
		dad.recalculateDanceIdle();
		dad.playAnim('idle');
	});
	modManager.queueFuncOnce(1600, (s, s2) -> {
		bubble.animation.play('intro2');
	});
	modManager.queueFuncOnce(1664, (s, s2) -> {
		bubble.animation.play('intro3');
	});
	modManager.queueFuncOnce(1728, (s, s2) -> {
		bubble.animation.play('run');
		gfGroup.visible = true;
		gf.alpha = 0;
	});
	modManager.queueFuncOnce(1776, (s, s2) -> {
		vocals.volume = 1;

		dad.playAnim('shock');
		dad.specialAnim = true;
		dad.idleSuffix = '';
		dad.recalculateDanceIdle();

		boyfriend.playAnim('idle', true);

		bgWindowColor.visible = false;
		bgWindowNormal.visible = false;
		bgWindowBroken.visible = true;

		FlxTween.cancelTweensOf(gf);
		FlxTween.tween(gf, {y: gf.y + 180}, 0.3, {ease: FlxEase.quadOut});
		gf.alpha = 1;
		FlxTween.tween(camHUD, {alpha: 1}, 1);
		bubble.visible = false;

		FlxTimer.wait(1, () -> {
			gf.canDance = true;
		});
	});
}

function onSpawnSustainSplash(splash) {
	// really weird that theyre not being offset correctly??
	// ill fix it engine wise later ig NO TIME I GOT A DEADLINE TO MEET
	splash.animOffsets.set('start' + splash.data, [0, 0]);
	splash.animOffsets.set('loop' + splash.data, [-10, 15]);
	splash.animOffsets.set('end' + splash.data, [0, 0]);
}

var can = true;
var fuck = false;

function onGameOver() {
	if (can) {
		camZooming = false;
		can = false;
		fuck = false;
		canPause = false;

		KillNotes();
		volumeMult = 0;

		camGame.visible = false;

		FlxTween.tween(die, {alpha: 1}, 10);
	}

	return ScriptConstants.STOP_FUNC;
}

function onUpdate(elapsed) {
	if (!can && !fuck) {
		if (FlxG.keys.justPressed.ENTER) {
			fuck = true;

			camHUD.fade(FlxColor.BLACK, 2);
			FlxTimer.wait(2.1, FlxG.resetState);
		}
	}
}
