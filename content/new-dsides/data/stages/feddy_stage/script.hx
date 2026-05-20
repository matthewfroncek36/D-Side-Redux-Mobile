function makeSpr(x,y,anim,factor)
{
	var spr = new FlxSprite(x,y).setFrames(Paths.getSparrowAtlas('backgrounds/ourple/perf'));
	spr.animation.addByPrefix('idle', anim, 24, false);
	spr.animation.play('idle');
	spr.scrollFactor.set(factor[0], factor[1]);
	spr.updateHitbox();

	return spr;
}

function onLoad() {
	var bg = makeSpr(-671, -150, 'performancewall', [1.0, 1.0]);
	bg.scale.set(0.85, 0.85);
	bg.screenCenter();
	bg.antialiasing = false;
	add(bg);

	for (i in 0...5) {
		var spr = new FlxSprite(-200 + (200 * i), -50);
		spr.frames = Paths.getSparrowAtlas('backgrounds/ourple/perf');
		spr.animation.addByPrefix('idle', 'Kid Idle', FlxG.random.int(11, 18), true);
		spr.animation.play('idle', true, false, FlxG.random.int(0, 10));
		spr.scale.set(0.85, 0.85);
		spr.updateHitbox();
		spr.antialiasing = false;
		add(spr);
	}
	var bg = makeSpr(-671,-150,'performanceground', [1.0, 1.0]);
	bg.screenCenter();
	bg.antialiasing = false;
	add(bg);

	money = new FlxSprite(375, 400).setFrames(Paths.getSparrowAtlas('backgrounds/ourple/perf'));
	money.updateHitbox();
	money.animation.addByPrefix('fall', 'Bag Drop', 12, false);
	money.animation.play('fall');
	money.visible = false;
	money.antialiasing = false;
	add(money);
}

function onCreatePost() {	
	modManager.setPercent("opponentSwap", 100);
	playHUD.flipBar();
	playHUD.reloadHealthBarColors();
	for (i in [dad, boyfriend])
		i.camDisplacement = 10;
}

function postReceptorGeneration(){
	initFunkinScript(FunkinScript.getPath('data/scripts/ourple_hud')).call('flip');
}

function onBeatHit() {
	modManager.setValue("squish", 0.25, 1);
	modManager.setValue("flip", -0.125, 1);
	modManager.queueEase(curStep + 1, curStep + 4, "squish", 0, 'backOut', 1);
	modManager.queueEase(curStep + 1, curStep + 4, "flip", 0, 'backOut', 1);
}

function onEvent(eventName, value1, value2)
{
	if(eventName == 'Song Events' && value1 == 'money')
	{
		boyfriend.playAnim('shock');
		boyfriend.specialAnim = true;

		boyfriend.onAnimationFinish.addOnce(()->{
			boyfriend.playAnim('shake');
			boyfriend.specialAnim = true;
			boyfriend.canDance = false;

			FlxTimer.wait(1, ()->{
				boyfriend.canDance = true;
				boyfriend.specialAnim = false;
			});

		});

		money.visible = true;
		money.animation.play('fall');
	}
}

function onGameOver(){
	boyfriend.cameraPosition[0] += 150;
}