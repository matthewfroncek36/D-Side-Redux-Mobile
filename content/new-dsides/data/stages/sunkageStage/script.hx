import funkin.objects.Bopper;

var holeMilk:FlxSprite;
var windowMilk:FlxSprite;
var windowMilk2:FlxSprite;
var milkWall:FlxSprite;
var eggDick:FlxSprite;
var isMitee:Bool = false;

var painting_x:Int = 1930;
var current_painting:Int = 0;

function makeSpr(x, y, name) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas('backgrounds/exe/milk/sunky'));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}

function onLoad() {
	bg = makeSpr(-600, -130, 'bg');
	add(bg);

	hole = makeSpr(-600, 515, 'holes1');
	add(hole);

	cum = makeSpr(-200, 740, 'gum');
	cum.updateHitbox();
	cum.origin.set(cum.width - 120, cum.height - 90);
	cum.zIndex = 200;
	add(cum);

	paintings_group = new FlxSpriteGroup();
	add(paintings_group);

	for(i in 1...5){
		paintings = makeSpr(painting_x, 530, 'draw' + i);
		paintings.x = painting_x + (i == 3 ? 25 : 0);
	}
	paintings_group.add(paintings);

	make_random_painting(4);

	hole2 = makeSpr(745, 340, 'holes2');
	hole2.visible = false;
	add(hole2);

	eggDick = new FlxSprite(300, 400);
	eggDick.frames = Paths.getSparrowAtlas("characters/exe/sunky/byeguys");
	eggDick.animation.addByPrefix('flying', 'flying', 48, true);
	eggDick.animation.play("flying");
	eggDick.visible = false;
	add(eggDick);

	amy = new Character(560, 400, 'amy');
	add(amy);

	yolk = new Character(1350, 500, 'yolk');
	add(yolk);

	miteeDead = new FlxSprite().loadGraphic(Paths.image('backgrounds/exe/milk/arealfamilyguy'));
	miteeDead.camera = camOther;
	miteeDead.screenCenter();
	miteeDead.x += 235;
	miteeDead.y += 100;
	miteeDead.alpha = 0;
	add(miteeDead);

	hole_foreground = makeSpr(-600, -130, 'layerforwhensunkydies');
	hole_foreground.zIndex = 4;
	add(hole_foreground);
}

function make_random_painting(?force_painting:Int = -1){
	paintings.kill();
	var choice = FlxG.random.int(1, 4);
	while(choice == current_painting || choice == 3) choice = FlxG.random.int(1, 4);
	if(force_painting != null) choice = force_painting;
	
	paintings = makeSpr(painting_x, 530, 'draw' + choice);
	paintings.x = painting_x + (choice == 3 ? 25 : 0);
	paintings.zIndex = 1;
	paintings_group.add(paintings);

	current_painting = choice;
}

function onBeatHit() {
	amy.onBeatHit(curBeat);
	yolk.onBeatHit(curBeat);
}

function breakSunk() {
	camGame.shake(0.015, 0.02);
	hole.visible = true;
	FlxTween.tween(cum, {angle: -74}, 0.3, {ease: FlxEase.bounceOut});
}

function onCreatePost() {
	initScript('data/scripts/NoteWarning');
	initScript('data/scripts/exe_hud');

	skipCountdown = true;
	gfGroup.zIndex = 1;
	boyfriendGroup.zIndex = 2;
	dadGroup.zIndex = 3;
	refreshZ(stage);
	gf.visible = false;

	modManager.queueEaseP(896, 904, "alpha", 100, "quadInOut", 1);
	modManager.queueEaseP(952, 960, "alpha", 0, "quadInOut", 1);

	modManager.queueEaseP(944, 952, 'opponentSwap', 100, "quadInOut");

	modManager.queueEaseP(1592, 1596, 'opponentSwap', 50, "bounceOut"); // mid scroll
	modManager.queueEaseP(1592, 1596, 'alpha', 100, "bounceOut", 1); // mid scroll

	addCharacterToList('mitee-play', 0);
		
	countdownDelay = 1;
	camHUD.alpha = 0;
	camHUD.zoom = 2;
	FlxTween.tween(camHUD, {alpha: 1, zoom: 1}, 4, {startDelay: 8, ease: FlxEase.quartOut});

	camGame.zoom = 1.8;
	camGame.flash(FlxColor.BLACK, 8);
	snapCamToPos(getCharacterCameraPos(boyfriend).x + 600, getCharacterCameraPos(boyfriend).y - 20, true);

	FlxTween.tween(camGame, {zoom: 0.8}, 10, {ease: FlxEase.circOut});
	FlxTween.tween(camFollow, {x: getCharacterCameraPos(dad).x, y: getCharacterCameraPos(dad).y}, 3, {
		startDelay: 8,
		ease: FlxEase.quadInOut,
		onComplete: () -> {
			FlxTimer.wait(2, () -> {
				isCameraOnForcedPos = false;
			});
		}
	});
}

var sunky_spin:Bool = false;
function onUpdate(elapsed){
	if(sunky_spin) dad.angle += 1000 * elapsed;
}

function onEvent(eventName, value1, value2) {
	switch (eventName) {
		case 'show gf':
			gf.visible = true;
			if (curStage == "mack") {
				FlxTween.tween(gf, {alpha: 0.6}, 3.3, {ease: FlxEase.quadInOut});
				FlxTween.tween(gf.scale, {x: 0.5, y: 0.5}, 3.3, {ease: FlxEase.quadInOut});
			}
		case 'Dad Fade In':
			playHUD.flipBar();
			FlxTween.tween(playHUD.iconP2, {alpha: 1}, 0.5);
			FlxTween.tween(dad, {alpha: 1}, 0.5);
		case 'Change Character':
			if (value2 == 'mitee'){
				dad.alpha = 0;
				sunky_spin = false;
				dad.angle = 0;
			}
			if (value2 == 'eggdick-flip')				
				boyfriend.dance();
			

		case 'Song Events':
			switch (value1) {
				case 'random painting':
					if(value2 == 'mitee')
						make_random_painting(3);
					else
						make_random_painting();

				case 'middle':
					switch (value2) {
						default:
							isCameraOnForcedPos = false;
							defaultCamZoom = 0.625;
						case 'on':
							isCameraOnForcedPos = true;
							defaultCamZoom = 0.55;
							camFollow.setPosition(getCharacterCameraPos(yolk).x, getCharacterCameraPos(yolk).y, true);
					}
				case 'fade in':
					playHUD.flipBar();
					FlxTween.tween(playHUD.iconP2, {alpha: 1}, 0.5);
					FlxTween.tween(dad, {alpha: 1}, 0.5);
				case 'start':
					FlxTween.tween(boyfriendGroup, {x: DAD_X + 200}, 0.3, {ease: FlxEase.quadInOut});
				case 'kick':
					dad.canDance = false;
					dad.playAnim('die');

					sunky_spin = true;
					// why tf did i ease this son
					FlxTween.tween(dad, {x: dad.y + -1800}, 0.425, {
						onComplete: (twn) -> {
							dad.visible = false;
							dad.x = dad.x + 1000;
							dad.canDance = true;
						}
					});

					breakSunk();
					isCameraOnForcedPos = true;
					FlxTween.tween(camFollow, {x: camFollow.x - 400}, 0.3, {ease: FlxEase.circOut, onUpdate: function(t:FlxTween){
						FlxG.camera.snapToTarget();
					}});

					var fakeIcon = new HealthIcon(dad.healthIcon, false);
					fakeIcon.y = playHUD.iconP2.y;
					fakeIcon.x = playHUD.iconP2.x;
					fakeIcon.visible = !ClientPrefs.hideHud;
					fakeIcon.alpha = ClientPrefs.healthBarAlpha;
					fakeIcon.velocity.x = -2600;
					fakeIcon.velocity.y = -800;
					fakeIcon.angularVelocity = -800;
					fakeIcon.acceleration.y = 1000;
					fakeIcon.animation.curAnim.curFrame = 1;
					fakeIcon.cameras = [camHUD];
					playHUD.iconP2.alpha = 0;
					add(fakeIcon);

					for (i in [amy, yolk]) {
						i.canDance = false;
						i.playAnim('shockLeft', true);

						FlxTimer.wait(5, () -> {
							i.idleSuffix = '-alt';
							i.recalculateDanceIdle();

							i.canDance = true;
							i.dance();
						});
					}

				case 'boom':
					dad.visible = false;

				case 'mitee kick':
					dad.playAnim('kick', true);
					dad.specialAnim = true;
					dad.onAnimationFinish.addOnce(() -> {
						changeCharacter('mitee-play', 0);
						isMitee = true;
						boyfriend.visible = true;
						dad.visible = false;
						boyfriend.x -= 150;
					});

					hole2.visible = true;
					boyfriend.visible = false;

					eggDick.visible = true;
					eggDick.x = boyfriend.x - 100;
					eggDick.y = boyfriend.y - 350;
					eggDick.scale.set(0.75, 0.75);
					add(eggDick);

					FlxTween.tween(eggDick.scale, {x: 0, y: 0}, 0.75, {ease: FlxEase.linear});

					var fakeIcon = new HealthIcon(playHUD.iconP1.characterName, true);
					fakeIcon.y = playHUD.iconP1.y;
					fakeIcon.x = playHUD.iconP1.x;
					fakeIcon.velocity.x = 1200;
					fakeIcon.velocity.y = -1800;
					fakeIcon.angularVelocity = 400;
					fakeIcon.acceleration.y = 1000;
					fakeIcon.animation.curAnim.curFrame = 1;
					fakeIcon.cameras = [camHUD];
					playHUD.iconP1.alpha = 0;
					add(fakeIcon);

					FlxTween.tween(fakeIcon.scale, {x: 0, y: 0}, 0.75, {ease: FlxEase.linear});
					FlxTween.tween(dad, {x: boyfriendGroup.x + 300}, 0.2, {
						ease: FlxEase.quadInOut
					});

					playHUD.iconP2.visible = false; // cuz thered be 2 mitee's LOL

					var fakeIcon2 = new HealthIcon(playHUD.iconP2.characterName, false);
					fakeIcon2.y = playHUD.iconP2.y;
					fakeIcon2.x = playHUD.iconP2.x;
					fakeIcon.visible = !ClientPrefs.hideHud;
					fakeIcon.alpha = ClientPrefs.healthBarAlpha;
					fakeIcon2.animation.curAnim.curFrame = 0;
					fakeIcon2.cameras = [camHUD];

					FlxTween.tween(fakeIcon, {x: playHUD.iconP1.x}, 0.1, {
						onComplete: (twn) -> {
							playHUD.iconP1.alpha = 1;
							playHUD.iconP1.changeIcon('mitee');
						}
					});
					add(fakeIcon);

					for (i in [amy, yolk]) {
						i.canDance = false;
						i.playAnim('shockRight', true);
					}
					camGame.shake(0.015, 0.06125);
					defaultCamZoom += 0.2;

				case 'mitee die':
					boyfriend.canDance = false;
					boyfriend.playAnim('die');
					FlxTween.tween(camHUD, {alpha: 0}, 0.325);

					isCameraOnForcedPos = true;
					camFollow.x -= 100;
					camFollow.y -= 100;
			}
		case 'char vis':
			switch (value1) {
				case 'dad':
					switch (value2) {
						case 'true':
							dad.visible = true;
						case 'false':
							dad.visible = false;
					}
				case 'bf':
					switch (value2) {
						case 'true':
							boyfriend.visible = true;
						case 'false':
							boyfriend.visible = false;
					}
				case 'gf':
					switch (value2) {
						case 'true':
							gf.visible = true;
						case 'false':
							gf.visible = false;
					}
			}
	}
}

var can = true;

function onGameOver() {
	if (can) {
		can = false;
		canPause = false;
		isDead = true;
		camZooming = false;
		isCameraOnForcedPos = true;
		KillNotes();

		camHUD.alpha = 0;

		if (!isMitee) {
			FlxTween.tween(PlayState.instance, {volumeMult: 0}, 0.625);
			camFollow.setPosition(getCharacterCameraPos(boyfriend).x, getCharacterCameraPos(boyfriend).y);

			boyfriend.canDance = false;
			boyfriend.playAnim('pop');
			FlxG.sound.play(Paths.sound('pop'));

			FlxTimer.wait(1, () -> {
				FlxG.camera.fade(FlxColor.BLACK, 1);
				FlxTimer.wait(1, FlxG.resetState);
			});
		} else {
			camGame.visible = false;
			miteeDead.alpha = 1;
			volumeMult = 0;
			FlxTimer.wait(1, () -> {
				camOther.fade(FlxColor.BLACK, 1);
				FlxTimer.wait(1, FlxG.resetState);
			});
		}
	}

	return ScriptConstants.STOP_FUNC;
}
