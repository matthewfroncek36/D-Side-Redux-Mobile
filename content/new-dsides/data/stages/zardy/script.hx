import animate.FlxAnimate;
import animate.FlxAnimateFrames;
import funkin.objects.Bopper;

var colorcorrection = newShader('colorcorrection');
var mesmer = newShader('mesmerize');
mesmer.setFloat('u_alpha', 0);

function makeSpr(x,y,anim)
{
	var spr = new FlxSprite(x,y).setFrames(Paths.getSparrowAtlas('backgrounds/zardy/zard'));
	spr.animation.addByPrefix('idle', anim, 24, false);
	spr.animation.play('idle');
	spr.updateHitbox();

	return spr;
}

var purpleHUD = null;

function onLoad() {

	bg = makeSpr(-600,-500, 'zardysky');
	bg.scrollFactor.set(0.2, 0.2);
	bg.antialiasing = true;
	add(bg);

	mountains = makeSpr(-600,-500,'zardymountains');
	mountains.scrollFactor.set(0.565, 0.565);
	mountains.antialiasing = true;
	add(mountains);

	fence = makeSpr(-150,0,'zardyfence');
	fence.antialiasing = true;
	add(fence);

	ground = makeSpr(-600,-500,'zardyground');
	ground.antialiasing = true;
	add(ground);

	if(!ClientPrefs.lowQuality){
		if(ClientPrefs.shaders)
		{
			purpleHUD = newShader('blue');
			purpleHUD.setFloat('hue', 1.575);
			purpleHUD.setFloat('hueBlend', 0.0);
			purpleHUD.setFloat('pix', 0.000001);
			camHUD.addShader(purpleHUD);
		}

		bg.shader = colorcorrection;
		mountains.shader = colorcorrection;
		fence.shader = colorcorrection;
		ground.shader = colorcorrection;

		colorcorrection.setFloat('brightness', -0.4);
		colorcorrection.setFloat('contrast', 1.35);
		colorcorrection.setFloat('saturation', 0.0);

		colorcorrection.setFloat('customred', 0.2);
		colorcorrection.setFloat('customgreen', 0.1);
		colorcorrection.setFloat('customblue', 0.2);


		colorcorrection.setFloat('brightness', 0.0);
		colorcorrection.setFloat('contrast', 1.0);
		colorcorrection.setFloat('saturation', 1.0);
		colorcorrection.setFloat('customred', 0.0);
		colorcorrection.setFloat('customgreen', 0.0);
		colorcorrection.setFloat('customblue', 0.0);

	}
}


function tweenCCVal(vari, val, time, ease)
{
	FlxTween.num(colorcorrection.getFloat(vari), val, time, {ease: ease, onUpdate: (t)->{
		colorcorrection.setFloat(vari, t.value);	
	}});
}

function onCreatePost() {
	skipCountdown = true;
	camGame.visible = false;
	camGame.zoom = 0.8;
	camHUD.alpha = 0;
	camHUD.zoom = 2;
	snapCamToPos(900, 200, true);
	addCharacterToList('zardy-evil', 1);

	spookyAnim = new FlxAnimate(1125, -50);
	spookyAnim.frames = FlxAnimateFrames.fromAnimate((Paths.textureAtlas('characters/spooky/hardy_animations')));
	spookyAnim.anim.addBySymbol('anim1', 'Spookez (anims DUH)/SpookezCoolAnim', 24, false);
	spookyAnim.anim.addBySymbol('anim2', 'Spookez (anims DUH)/SpookeezAnim2', 24, false);
	spookyAnim.anim.play('anim1', true);
	spookyAnim.anim.pause();
	spookyAnim.flipX = true;
	spookyAnim.antialiasing = true;
	spookyAnim.visible = false;
	add(spookyAnim);

	if(!ClientPrefs.lowQuality){
		gf.shader = colorcorrection;
		boyfriend.shader = colorcorrection;
		spookyAnim.shader = colorcorrection;
	}

	spookyDeath = new Bopper().setFrames(Paths.getSparrowAtlas('backgrounds/zardy/dead'));
	spookyDeath.addAnimByPrefix('dead', 'spooky DEATH', 24, true);
	spookyDeath.addAnimByPrefix('retry', 'spooky RETRY', 24, false);
	spookyDeath.playAnim('dead');
	spookyDeath.camera = camOther;
	spookyDeath.screenCenter();
	spookyDeath.visible = false;
	add(spookyDeath);

	modManager.queueFuncOnce(0, (s, s2) -> {
		FlxTween.tween(camGame, {zoom: 1}, 3);
		camGame.visible = true;
	});
	modManager.queueFuncOnce(8, (s, s2) -> {
		gf.playAnimForDuration('line', 2.5, true);
	});
	modManager.queueFuncOnce(32, (s, s2) -> {
		camFollow.setPosition(400, 300);
		FlxTween.cancelTweensOf(camGame);
		FlxTween.tween(camGame, {zoom: 0.75}, 0.625, {ease: FlxEase.backOut});


		FlxTween.tween(camGame, {angle: -3, zoom: 0.9}, 3.2, {startDelay: 7.2, ease: FlxEase.backInOut});
		camGame.shake(0.05, 0.125);
	});
	modManager.queueFuncOnce(164, (s, s2) -> {
		FlxTween.cancelTweensOf(camGame);
		snapCamToPos(1125, 350);
		FlxTween.tween(camGame, {angle: 0, zoom: 0.75}, 0.325, {ease: FlxEase.bounceOut});

		spookyAnim.anim.play('anim1');
		spookyAnim.visible = true;
		boyfriend.visible = false;
	});
	modManager.queueFuncOnce(236, (s, s2) -> {
		FlxTween.tween(camGame, {zoom: 0.625}, 0.5, {ease: FlxEase.bounceOut});
	});
	modManager.queueFuncOnce(256, (s, s2) -> {
		for(i in dadGroup.members)
			i.canDance = true;

		spookyAnim.anim.pause();
		spookyAnim.visible = false;
		boyfriend.visible = true;
		boyfriend.dance();
		isCameraOnForcedPos = false;

		FlxTween.tween(camHUD, {zoom: 1, alpha: 1}, 0.625, {ease: FlxEase.quintOut});
	});

	modManager.queueFuncOnce(2634, (s, s2) -> {
		spookyAnim.visible = true;
		boyfriend.visible = false;
		spookyAnim.setPosition(1225, 100);
		spookyAnim.anim.play('anim2', true);

		FlxTween.tween(camHUD, {alpha: 0}, 1);
	});

	modManager.queueFuncOnce(2678, ()->{
		isCameraOnForcedPos = true;
		camZooming = false;
		FlxTween.tween(camGame, {zoom: 0.625}, 2.25, {ease: FlxEase.quadInOut});
		FlxTween.tween(camFollow, {x: getCharacterCameraPos(dad).x, y: getCharacterCameraPos(dad).y + 100}, 2, {ease: FlxEase.quartInOut});
	});

	modManager.queueFuncOnce(2768, (s, s2) -> {
		boyfriend.visible = true;
		spookyAnim.visible = false;
		isCameraOnForcedPos = false;
		FlxTween.tween(camHUD, {alpha: 1}, 0.625);
	});

	modManager.queueFuncOnce(3168, ()->{
		boyfriend.playAnim('end', true);
		boyfriend.specialAnim = true;
		boyfriend.onAnimationFinish.add(()->{
			boyfriend.visible = false;
		});

		gf.playAnim('end', true);
		gf.specialAnim = true;
		gf.canDance = false;

		FlxTween.tween(camHUD, {alpha: 0}, 1);
	});

	modManager.queueFuncOnce(3184, (s,s2)->{
		camOther.fade(FlxColor.BLACK, 1.5);
	});
	
	if(ClientPrefs.shaders && !ClientPrefs.lowQuality && ClientPrefs.flashing)
		camGame.addShader(mesmer);
}

function goodNoteHit(note) {
	if (note.noteType == 'Alt Animation') {
		boyfriend.healthColour = 0xFFdcdcdc;
	} else {
		boyfriend.healthColour = 0xFF9adae4;
	}

	playHUD.reloadHealthBarColors();
}

var can = true;
var fuck = false;
function onGameOver()
{
	if(can)
	{
		can = false;
		fuck = false;
		isDead = true;
		canPause = false;

		volumeMult = 0;
		KillNotes();

		camGame.visible = false;
		camHUD.visible = false;
		spookyDeath.visible = true;
	}

	return ScriptConstants.STOP_FUNC;
}

var totalElapsed = 0;
function onUpdate(elapsed)
{
	if(ClientPrefs.shaders){
		totalElapsed += elapsed * 2;
		mesmer.setFloat('iTime', totalElapsed);
	}

	if(!can && !fuck)
	{
		if(FlxG.keys.justPressed.ENTER)
		{
			fuck = true;
			FlxG.sound.play(Paths.sound("skidyeah"));
			spookyDeath.playAnim('retry');
			spookyDeath.y -= 100;

			camOther.fade(FlxColor.BLACK, 2);
			FlxTimer.wait(2.1, FlxG.resetState);
		}
	}
}

function onEvent(eventName, value1, value2)
{
	switch(eventName)
	{
		case 'Play Animation':
			if(value1 == 'anim-end')
			{
				dad.onAnimationFinish.add(()->{
					changeCharacter('zardy-evil', 1);
				});
				
				if(ClientPrefs.lowQuality) return;

				dad.onAnimationFrameChange.add((name, frame)->{
					switch(frame)
					{
						case 160:
							var time = 0.8;
							camGame.filtersEnabled = true;

							if(ClientPrefs.shaders){							
								purpleHUD.setFloat('hueBlend', 1);

								FlxTween.num(0, 1, time, {ease: FlxEase.circOut, onUpdate: (t)->{
									mesmer.setFloat('u_alpha', t.value);
								}});
							}

							tweenCCVal('brightness', -0.4, time, FlxEase.circOut);
							tweenCCVal('contrast', 1.35, time, FlxEase.circOut);
							tweenCCVal('saturation', 0.0, time, FlxEase.circOut);
							tweenCCVal('customred', 0.2, time, FlxEase.circOut);
							tweenCCVal('customgreen', 0.1, time, FlxEase.circOut);
							tweenCCVal('customblue', 0.2, time, FlxEase.circOut);


					}
				});
			}
	}
}