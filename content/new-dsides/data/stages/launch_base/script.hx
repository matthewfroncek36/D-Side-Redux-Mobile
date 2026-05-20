// import funkin.data.NoteSkinHelper;
import openfl.filters.ShaderFilter;
import funkin.utils.WindowUtil;
import funkin.objects.Bopper;

var chud_shader = newShader('colorcorrection');
var cloud_shader = newShader('cloud');
var glitch = newShader('glitch');
var illegaleffect = newShader('illegal');
var hudGlitch = newShader('glitch');
var stageshit:Int = 0;
var totalElapsed:Float = 0;
var fakebg:Array<FlxSprite> = [];
var realbg:Array<FlxSprite> = [];

function onLoad() {
	// if (FlxG.save.data.execution == null || FlxG.save.data.execution == false) {
	// 	FlxG.stage.window.alert('N \n   0 \n\n C h\n         E \n            A T       n\n                    I         G .', 'ILLEGAL INSTRUCTION');
	// 	WindowUtil.exit();
	// }

	// Fake BG
	bg1 = new FlxSprite(-800, -500);
	bg1.loadGraphic(Paths.image("backgrounds/exe/execution/execbg"));
	bg1.scrollFactor.set(1, 1);
	bg1.setGraphicSize(Std.int(bg1.width * 1.0));
	bg1.zIndex = -10;

	bg2 = new FlxSprite(1300, 500);
	bg2.loadGraphic(Paths.image("backgrounds/exe/execution/execspikes"));
	bg2.scrollFactor.set(1, 1);
	bg2.setGraphicSize(Std.int(bg2.width * 0.9));
	bg2.zIndex = 10;

	fakebg.push(bg1);
	fakebg.push(bg2);
	if (!ClientPrefs.lowQuality) {
		meat1 = new Bopper(1375, -385).loadAtlas('backgrounds/exe/execution/trees');
		meat1.addAnimByPrefix('idle', 'BG/BG1', 28, true);
		meat1.playAnim('idle');
		meat1.scale.set(0.9, 0.9);
		meat1.zIndex = -5;

		meat2 = new Bopper(-885, -385).loadAtlas('backgrounds/exe/execution/trees');
		meat2.addAnimByPrefix('idle', 'BG/BG2', 28, true);
		meat2.playAnim('idle');
		meat2.scale.set(0.9, 0.9);
		meat2.zIndex = -5;

		fire = new FlxSprite(-140, -100);
		fire.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/awesome fire");
		fire.animation.addByPrefix('idle', 'awesome fire', 24, true);
		fire.animation.play('idle');
		fire.scrollFactor.set(0, 0);
		fire.setGraphicSize(Std.int(meat1.width * 1.7));
		fire.blend = BlendMode.ADD;
		fire.alpha = 0.001;
		fire.zIndex = 20;

		firecolor = new FlxSprite(-550, -300).makeGraphic(2500, 1500, 0xFF663C33);
		firecolor.scrollFactor.set(0, 0);
		firecolor.zIndex = 19;
		firecolor.blend = BlendMode.MULTIPLY;

		illegal1 = new FlxSprite(-500, -500).makeGraphic(4980, 4020, 0xFF000000);
		illegal1.scrollFactor.set(0, 0);
		illegal1.zIndex = 5;
		illegal1.alpha = 0.5;
		illegal1.visible = false;

		illegal2 = new FlxSprite(-500, -500).makeGraphic(4980, 4020, 0xFF1500FF);
		illegal2.scrollFactor.set(0, 0);
		illegal2.zIndex = 6;
		illegal2.blend = BlendMode.MULTIPLY;
		illegal2.visible = false;

		fakebg.push(meat1);
		fakebg.push(meat2);
		fakebg.push(fire);
		fakebg.push(firecolor);
		fakebg.push(illegal1);
		fakebg.push(illegal2);
	}
	for (item in fakebg)
		add(item);

	// Real BG
	floor = new FlxSprite(-597, 312);
	floor.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Floor"));
	floor.scrollFactor.set(1, 1);
	floor.setGraphicSize(Std.int(floor.width * 1.0));
	floor.zIndex = -10;
	floor.shader = hudGlitch;
	realbg.push(floor);

	spikes = new FlxSprite(1258, 886);
	spikes.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Spikes"));
	spikes.scrollFactor.set(1, 1);
	spikes.setGraphicSize(Std.int(spikes.width * 1.0));
	spikes.zIndex = 10;
	spikes.shader = hudGlitch;
	realbg.push(spikes);

	if (!ClientPrefs.lowQuality) {
		tube1 = new FlxSprite(-401, -467);
		tube1.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Tree1");
		tube1.animation.addByPrefix('idle', 'Tree1', 24, true);
		tube1.animation.play('idle');
		tube1.scrollFactor.set(1, 1);
		tube1.setGraphicSize(Std.int(tube1.width * 1.0));
		tube1.zIndex = 0;
		tube1.shader = hudGlitch;
		realbg.push(tube1);

		tube2 = new FlxSprite(1432, -431);
		tube2.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Tree2");
		tube2.animation.addByPrefix('idle', 'Tree2', 24, true);
		tube2.animation.play('idle');
		tube2.scrollFactor.set(1, 1);
		tube2.setGraphicSize(Std.int(tube2.width * 1.0));
		tube2.zIndex = 0;
		tube2.shader = hudGlitch;
		realbg.push(tube2);

		bushes = new FlxSprite(-674, 97);
		bushes.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Bushes");
		bushes.animation.addByPrefix('idle', 'Bushes', 24, true);
		bushes.animation.play('idle');
		bushes.scrollFactor.set(0.8, 0.8);
		bushes.setGraphicSize(Std.int(bushes.width * 1.0));
		bushes.zIndex = -20;
		bushes.shader = hudGlitch;
		realbg.push(bushes);
	}

	deathegg = new FlxSprite(-189, -419);
	deathegg.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/DeathEgg"));
	deathegg.scrollFactor.set(0.4, 0.4);
	deathegg.setGraphicSize(Std.int(deathegg.width * 1.0));
	deathegg.zIndex = -30;
	deathegg.shader = hudGlitch;
	realbg.push(deathegg);

	ocean = new FlxSprite(-659, 29);
	ocean.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Ocean");
	ocean.animation.addByPrefix('idle', 'Ocean', 24, true);
	ocean.animation.play('idle');
	ocean.scrollFactor.set(0.38, 0.38);
	ocean.setGraphicSize(Std.int(ocean.width * 1.0));
	ocean.zIndex = -31;
	ocean.shader = hudGlitch;
	realbg.push(ocean);

	mountain = new FlxSprite(-752, -286);
	mountain.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Mountains"));
	mountain.scrollFactor.set(0.2, 0.2);
	mountain.setGraphicSize(Std.int(mountain.width * 1.0));
	mountain.zIndex = -40;
	mountain.shader = hudGlitch;
	realbg.push(mountain);

	cloud = new FlxSprite(-461, -461);
	cloud.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Clouds");
	cloud.animation.addByPrefix('idle', 'Clouds', 24, true);
	cloud.animation.play('idle');
	cloud.scrollFactor.set(0.28, 0.28);
	cloud.setGraphicSize(Std.int(cloud.width * 1.0));
	cloud.zIndex = -31;
	cloud.shader = hudGlitch;
	realbg.push(cloud);

	sky = new FlxSprite(-901, -415);
	sky.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Sky"));
	sky.scrollFactor.set(0.1, 0.1);
	sky.setGraphicSize(Std.int(mountain.width * 1.0));
	sky.zIndex = -50;
	sky.shader = glitch;
	realbg.push(sky);

	tailscorpse = new FlxSprite(-605, 251);
	tailscorpse.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Corpses");
	tailscorpse.animation.addByPrefix('idle', 'TailsIdle', 24, true);
	tailscorpse.animation.addByPrefix('turn', 'TailsTurn', 15, false);
	tailscorpse.animation.play('idle');
	tailscorpse.scrollFactor.set(1, 1);
	tailscorpse.setGraphicSize(Std.int(tailscorpse.width * 0.78));
	tailscorpse.zIndex = 0;
	tailscorpse.shader = hudGlitch;
	realbg.push(tailscorpse);

	amycorpse = new FlxSprite(1425, 551);
	amycorpse.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Corpses");
	amycorpse.animation.addByPrefix('idle', 'AmyIdle', 24, true);
	amycorpse.animation.addByPrefix('turn', 'AmyTurn', 15, false);
	amycorpse.animation.play('idle');
	amycorpse.scrollFactor.set(1, 1);
	amycorpse.setGraphicSize(Std.int(amycorpse.width * 0.9));
	amycorpse.zIndex = 0;
	amycorpse.shader = hudGlitch;
	realbg.push(amycorpse);

	orgh = new FlxSprite(0, 0);
	orgh.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/orgh"));
	orgh.scrollFactor.set(0.1, 0.1);
	orgh.setGraphicSize(Std.int(orgh.width * 1.0));
	orgh.cameras = [camHUD];
	orgh.zIndex = -50;
	orgh.blend = BlendMode.OVERLAY;
	realbg.push(orgh);

	orgh2 = new FlxSprite(0, 0);
	orgh2.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/orgh"));
	orgh2.scrollFactor.set(0.1, 0.1);
	orgh2.setGraphicSize(Std.int(orgh2.width * 1.0));
	orgh2.cameras = [camHUD];
	orgh2.zIndex = -5;
	orgh2.alpha = 0.7;
	realbg.push(orgh2);

	cooleffect = new FlxSprite(-700, -300).makeGraphic(3680, 2920, FlxColor = 0xFFFF0000);
	cooleffect.scrollFactor.set(2, 2);
	cooleffect.zIndex = 998;
	cooleffect.blend = BlendMode.ADD;
	realbg.push(cooleffect);

	cooleffect2 = new FlxSprite(-700, -300).makeGraphic(3680, 2920, 0x5F9EA0FF);
	cooleffect2.scrollFactor.set(2, 2);
	cooleffect2.zIndex = 999;
	cooleffect2.blend = BlendMode.MULTIPLY;
	realbg.push(cooleffect2);

	cooleffect.shader = cloud_shader;

	for (item in realbg) {
		item.visible = false;
		add(item);
	}
}

function onCreatePost() {
	modManager.queueFuncOnce(22, (s, s2) -> {
		defaultCamZoom += 0.1;
		FlxTween.tween(camGame, {zoom: defaultCamZoom}, 0.2, {ease: FlxEase.quadIn});
	});

	chud_shader.setFloat('brightness', 0.0);
	chud_shader.setFloat('contrast', 1.35);
	chud_shader.setFloat('saturation', 0.40);

	chud_shader.setFloat('customred', 0.15);
	chud_shader.setFloat('customgreen', 0.05);
	chud_shader.setFloat('customblue', 0.05);

	cloud_shader.setFloat('red_amt', 0.26);
	cloud_shader.setFloat('green_amt', 0.05);
	cloud_shader.setFloat('blue_amt', 0.1);

	glitch.setFloat('GlitchAmount', 0.0001);
	hudGlitch.setFloat('GlitchAmount', 0.00005);
	// swapNoteskin('exe');

	death = new FunkinVideoSprite();
	death.onFormat(() -> {
		death.camera = camOther;
		death.screenCenter();
	});
	death.load(Paths.video('execution game over'));
	death.onEnd(FlxG.resetState);
	add(death);
}

function onEvent(eventName, value1, value2) {
	switch (eventName) {
		case 'Execution Events':
			switch (value1.toLowerCase()) {
				case 'aura':
					if (ClientPrefs.lowQuality)
						return;

					FlxTween.tween(fire, {alpha: 1}, 30, {ease: FlxEase.quintOut});

				case 'aura loss':
					if (ClientPrefs.lowQuality)
						return;

					FlxTween.cancelTweensOf(fire);
					FlxTween.tween(fire, {alpha: 0}, 7, {ease: FlxEase.quintOut});

				case 'he transforms':
					dad.playAnim('Transform1');
					dad.specialAnim = true;

					notes.forEachAlive((note) -> {
						note.canMiss = true;
						note.reloadNote();
					});

				case 'error':
					for (i in fakebg) {
						if (i.frames != null)
							i.animation.pause();
					}

					var poop = ClientPrefs.lowQuality ? [bg1, bg2] : [bg1, bg2, meat1, meat2, boyfriend, gf];
					for (fat in poop)
						fat.shader = illegaleffect;

					camHUD.filters = [new ShaderFilter(illegaleffect)];

					boyfriend.visible = false;
					gf.visible = false;

					notes.forEachAlive((note) -> {
						note.canMiss = true;
						note.reloadNote();
					});

					dad.playAnim('Transform2');
					dad.specialAnim = true;

					if (!ClientPrefs.lowQuality) {
						illegal1.visible = true;
						illegal2.visible = true;
					}

					dadGroup.zIndex = 10;
					refreshZ(stage);

				case 'real intro':
					glitch.setFloat('GlitchAmount', 4);
					dad.shader = glitch;
					camHUD.filters = [];

					var poop = ClientPrefs.lowQuality ? [bg1, bg2, boyfriend, gf] : [bg1, bg2, meat1, meat2, boyfriend, gf];
					for (fat in poop)
						fat.shader = null;

					if (!ClientPrefs.lowQuality)
						illegal1.visible = illegal2.visible = false;

					dadGroup.zIndex = 0;
					refreshZ(stage);

				case 'real intro fade':
					FlxTween.num(4, 0.000001, 12, {
						onUpdate: (t) -> {
							glitch.setFloat('GlitchAmount', t.value);
						}
					});

					FlxTween.num(1.6, 0.000001, 10, {
						startDelay: 3,
						onUpdate: (t) -> {
							hudGlitch.setFloat('GlitchAmount', t.value);
						}
					});

				case 'bg':
					stageshit = 1;
					camGame.filters = [new ShaderFilter(chud_shader)];

					for (item in fakebg)
						item.visible = false;

					for (item in realbg)
						item.visible = true;

					boyfriend.visible = true;
					gf.visible = true;

					dad.x = 297;
					dad.y = 80;

					boyfriend.x = 1080;
					boyfriend.y = 450;

					gf.x = 800;
					gf.y = 290;

				// swapNoteskin('default');

				case 'tails':
					tailscorpse.animation.play('turn');

				case 'amy':
					amycorpse.animation.play('turn');
			}
	}
}

// function swapNoteskin(newSkin:String) {
// 	PlayState.SONG.arrowSkin = newSkin;
// 	noteskinLoading(newSkin);
// 	initNoteSkinning(newSkin);
// 	notes.forEachAlive((note) -> {
// 		note.texture = note.mustPress ? PlayState.noteSkin.data.playerSkin : PlayState.noteSkin.data.opponentSkin;
// 		note.reloadNote();
// 	});
// 	for (j in playFields.members) {
// 		for (i in j.members) {
// 			i.texture = NoteSkinHelper.arrowSkins[i.player];
// 			i.reloadNote();
// 			i.handleColors('static');
// 		}
// 	}
// }

function onSpawnNote(note) {
	note.reloadNote();
}

function onUpdate(elapsed) {
	totalElapsed += elapsed;
	cloud_shader.setFloat('iTime', totalElapsed);

	if (ClientPrefs.lowQuality)
		return;
	firecolor.alpha = fire.alpha;
}

function onDestroy() {
	FlxG.game.setFilters([]);
}

var can = true;

function onGameOver() {
	if (can) {
		can = false;

		KillNotes();
		volumeMult = 0;

		death.play();
	}
	return ScriptConstants.STOP_FUNC;
}
