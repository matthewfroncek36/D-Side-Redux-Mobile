function onLoad()
{
	var bg = new FlxSprite(-1365, -640).loadGraphic(Paths.image("backgrounds/retro"));
	bg.scale.set(9.35, 9.35);
	bg.updateHitbox();
	add(bg);
	
	noCutscene = false;
	skipCountdown = true;
	camGame.visible = false;
	camHUD.visible = false;
}

function onCreatePost()
{
	playHUD.iconP1.flipX = !playHUD.iconP1.flipX;
	
	modManager.queueFuncOnce(508, ()->{
		var ogPos = [boyfriend.x, boyfriend.y];
		
		boyfriend.playAnim('hey', true);
		boyfriend.scale.set(1.75, 1.75);
		boyfriend.updateHitbox();
		boyfriend.specialAnim = true;
		
		boyfriend.x -= 100;
		boyfriend.y -= 100;
		
		FlxTimer.wait(0.85, () -> {
			boyfriend.scale.set(1, 1);
			boyfriend.updateHitbox();
			
			boyfriend.setPosition(ogPos[0], ogPos[1]);
		});

	});

	modManager.queueFuncOnce(512, () -> {
		camGame.zoom += 0.1;
		camGame.shake(0.006125, 0.5);
		
	});
}

function onStartCountdown()
{
	if (!noCutscene)
	{
		snapCamToPos(125, 260, true);
		cutsceneVid = new FunkinVideoSprite(0, 0, false);
		cutsceneVid.onFormat(() -> {
			cutsceneVid.cameras = [camOther];
			cutsceneVid.setGraphicSize(FlxG.width, 0);
			cutsceneVid.updateHitbox();
			cutsceneVid.screenCenter(FlxAxes.XY);
			cutsceneVid.antialiasing = false;
			cutsceneVid.alpha = 1;
		});
		cutsceneVid.onEnd(() -> {
			FlxTimer.wait(0.5, ()->{
				noCutscene = true;
				camGame.visible = true;
				camHUD.visible = true;
				boyfriend.alpha = 0;
				FlxTween.tween(boyfriend, {alpha: 1}, 2);
				var time = 10;
				var delay = 2;
				FlxTween.tween(camFollow, {x: getCharacterCameraPos(dad).x, y: getCharacterCameraPos(dad).y}, time,
					{
						startDelay: delay,
						ease: FlxEase.bounceInOut,
						onComplete: () -> {
							isCameraOnForcedPos = false;
						}
					});
				FlxTween.num(0.4625, 0.5625, time,
					{
						startDelay: delay,
						ease: FlxEase.quadInOut,
						onUpdate: (t) -> {
							defaultCamZoom = t.value;
							camGame.zoom = t.value;
						}
					});
				startCountdown();

				cutsceneVid.destroy();
			});


		});
		if (cutsceneVid.load(Paths.video("RETROSLALA")))
		{
			cutsceneVid.delayAndStart();
		}
		else
		{
			trace("Fart.");
			noCutscene = true;
			startCountdown();
		}
		add(cutsceneVid);
		return ScriptConstants.STOP_FUNC;
	}
}
