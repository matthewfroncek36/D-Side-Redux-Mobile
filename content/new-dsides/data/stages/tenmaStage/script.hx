import funkin.game.shaders.HSLColorSwap;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.text.FlxTypeText;

var camTenma:FlxCamera;
var camChar:FlxCamera;
var dadReflection:FlxSprite;
var boyfriendReflection:FlxSprite;
var bg_string:String = 'backgrounds/exe/endless';
var lilGuy1:BGSprite;
var lilGuy2:BGSprite;
var lilGuy3:BGSprite;
var lilGuy45:BGSprite;
var audience:BGSprite;
var purp_a:Float = 0;
var purple = newShader('blue');
var purpleHUD = newShader('blue');
var sat = new HSLColorSwap();

function makeSpr(x,y,anim,factor)
{
	var spr = new FlxSprite(x,y).setFrames(Paths.getSparrowAtlas('backgrounds/exe/endless/city'));
	spr.animation.addByPrefix('idle', anim, 24, false);
	spr.animation.play('idle');
	spr.scrollFactor.set(factor[0], factor[1]);
	spr.updateHitbox();

	return spr;
}

function onLoad() {
	if(!ClientPrefs.lowQuality){
		if (ClientPrefs.shaders) {
			sat.saturation = -0.2;

			purple.setFloat('hue', 1.575);
			purple.setFloat('hueBlend', 0.5);
			purple.setFloat('pix', 0.000001);

			purpleHUD.setFloat('hue', 1.575);
			purpleHUD.setFloat('hueBlend', 0.0);
			purpleHUD.setFloat('pix', 0.000001);

			camGame.filters = [new ShaderFilter(sat.shader)];
			camHUD.filters = [new ShaderFilter(purpleHUD)];
		}

		camTenma = new FlxCamera(-465, 0, 2209, 124 * 8);
		camTenma.bgColor = 0x0;
		camChar = new FlxCamera();
		camChar.bgColor = 0x0;
		insertFlxCamera(FlxG.cameras.list.indexOf(camGame), camTenma, false);
		insertFlxCamera(FlxG.cameras.list.indexOf(camGame), camChar, false);

	}

	var bg = makeSpr(-700,-740, 'endlesssky', [0.15, 0.15]);
	add(bg);
	var city = makeSpr(-700,-550, 'endlesscity', [0.25, 0.25]);
	add(city);

	var cd = makeSpr(430, 1100, 'endlesscd', [1.0, 1.0]);

	if(!ClientPrefs.lowQuality){
		var thingyLeft = makeSpr(-380, 0, 'endlesstower1', [0.75, 1.0]);
		add(thingyLeft);

		barLeft = makeSpr(-150, -200, 'endlessbuild2', [0.8, 1.0]);

		lilGuy3 = new BGSprite(bg_string + '/tenmas', barLeft.x + 1070, barLeft.y + 310, 0.65, 1, ['Tenma3'], false);
		lilGuy3.antialiasing = true;

		add(lilGuy3);
		add(barLeft);

		lilGuy2 = new BGSprite(bg_string + '/tenmas', barLeft.x + 670, barLeft.y + 370, 0.8, 1, ['Tenma2'], false);
		lilGuy2.antialiasing = true;
		add(lilGuy2);

		lilGuy1 = new BGSprite(bg_string + '/tenmas', barLeft.x + 270, barLeft.y + 530, 0.8, 1, ['Tenma1'], false);
		lilGuy1.antialiasing = true;
		add(lilGuy1);

		barRight = makeSpr(1300,-200, 'endlessbuild1', [0.85, 1.0]);
		add(barRight);

		lilGuy45 = new BGSprite(bg_string + '/tenmas', barRight.x + 200, barRight.y + 410, 0.85, 1, ['Tenma4and5'], false);
		lilGuy45.antialiasing = true;
		add(lilGuy45);

		thingyRight = makeSpr(2300,0,'endlesstower', [1.2, 1.0]);
		thingyRight.zIndex = 2;
		add(thingyRight);

		audience = new BGSprite(bg_string + '/tenmas', 0, 1200, 1.3, 1, ['AudienceTenmas'], false);
		audience.antialiasing = true;
		audience.zIndex = 3;
		add(audience);

		tenmalinebg = new FlxSprite(-300, 0).makeGraphic(2700, 2000, FlxColor.BLACK);
		tenmalinebg.alpha = 0;
		add(tenmalinebg);

		tenmaline1 = new FlxBackdrop(null, FlxAxes.XY, 0, Std.int(134));
		tenmaline1.frames = Paths.getSparrowAtlas(bg_string + '/tenmas');
		tenmaline1.animation.addByPrefix('idle', 'tenmadance', 12, true);
		tenmaline1.animation.play('idle');
		tenmaline1.scale.set(2, 2);
		tenmaline1.updateHitbox();
		tenmaline1.alpha = 0;
		add(tenmaline1);

		tenmaline2 = new FlxBackdrop(null, FlxAxes.XY, 0, Std.int(134));
		tenmaline2.frames = Paths.getSparrowAtlas(bg_string + '/tenmas');
		tenmaline2.animation.addByPrefix('idle', 'tenmadance', 12, true);
		tenmaline2.animation.play('idle');
		tenmaline2.scale.set(2, 2);
		tenmaline2.updateHitbox();
		tenmaline2.y += 134 * 2;
		tenmaline2.alpha = 0;
		add(tenmaline2);

		introTenma = new FlxSprite();
		introTenma.frames = Paths.getSparrowAtlas(bg_string + '/tenmas');
		introTenma.animation.addByPrefix('idle', 'tenmadance', 12, true);
		introTenma.animation.play('idle');
		introTenma.blend = BlendMode.ADD;
		introTenma.updateHitbox();
		introTenma.screenCenter();
		introTenma.camera = camOther;
		introTenma.visible = false;
		add(introTenma);

		introText = new FlxTypeText(0, 450, 500, 'YOU NEVER STOOD A CHANCE');
		introText.setFormat(Paths.font("rge.ttf"), 50, 0xFFda75ff, FlxTextAlign.CENTER);
		introText.screenCenter(FlxAxes.X);
		introText.camera = camOther;
		add(introText);

		add(cd);

		blend_bg = makeSpr(100,100,'endless_gradient', [0.15, 0.15]);
		blend_bg.antialiasing = ClientPrefs.globalAntialiasing;
		blend_bg.blend = BlendMode.ADD;
		blend_bg.scale.set(2.5, 2.5);
		blend_bg.zIndex = 9;
		blend_bg.alpha = 0.4;
		add(blend_bg);

		for (i in [barLeft, barRight, lilGuy1, lilGuy2, lilGuy3, lilGuy45])
			i.y -= 750;
		audience.y += 500;
	} else{
		add(cd);
		defaultCamZoom = 1;
		camGame.zoom = 1;
	}

	skipCountdown = true;
	countdownDelay = 1;
}

var dropped:Bool = false;

var tenmaline_amt:Int = ClientPrefs.flashing ? 10 : 5;
function onUpdate(elapsed) {
	if(ClientPrefs.lowQuality) return;

	tenmaline1.x -= tenmaline_amt * (60 * elapsed);
	tenmaline2.x += tenmaline_amt * (60 * elapsed);

	blend_bg.alpha = purp_a;
	if (!dropped && ClientPrefs.shaders)
		purple.setFloat('hueBlend', 0.5 + (purp_a * 0.5));

	purp_a = FlxMath.lerp(purp_a, 0.1, FlxMath.bound(0, 1, elapsed * 4));
}

var purpTimer = 99999;
var purpLvl = 0;

function onCreatePost() {
	if(ClientPrefs.lowQuality) return;

	if (ClientPrefs.shaders) {
		boyfriend.shader = purple;
		gf.shader = purple;
		dad.shader = purple;
	}

	camGame.visible = false;
	camHUD.visible = false;

	modManager.queueFuncOnce(2, (s, s2) -> {
		introTenma.visible = true;
		introText.start();
	});

	modManager.queueFuncOnce(16, (s, s2) -> {
		camOther.bgColor = 0x0;
		introTenma.visible = false;
		introText.visible = false;
		if (ClientPrefs.flashing)
			camHUD.flash(FlxColor.WHITE, 1);
		else
			camHUD.flash(FlxColor.BLACK, 2);
		camHUD.visible = true;
		camGame.visible = true;
	});

	modManager.queueFuncOnce(143, (s, s2) -> {
		purpLvl = 0.325;
		purpTimer = 2;
		FlxTween.tween(sat, {saturation: 0}, 1);

		for (i in [barRight, lilGuy45])
			FlxTween.tween(i, {y: i.y + 750}, 3, {startDelay: 0.5, ease: FlxEase.circOut});

		for (i in [barLeft, lilGuy1, lilGuy2])
			FlxTween.tween(i, {y: i.y + 750}, 2.75, {ease: FlxEase.circOut});

		FlxTween.tween(lilGuy3, {y: lilGuy3.y + 750}, 2, {ease: FlxEase.circOut, startDelay: 1.5});
		FlxTween.tween(audience, {y: audience.y - 500}, 1, {ease: FlxEase.circOut, startDelay: 0.75});
	});
	modManager.queueFuncOnce(911, (s, s2) -> {
		drop(true);
	});
	modManager.queueFuncOnce(1167, (s, s2) -> {
		drop(false);
	});
}

var blendbgtween:FlxTween;

function onBeatHit() {
	if(ClientPrefs.lowQuality) return;

	tenmas_dance();
	if (curBeat % purpTimer == 0)
		purp_a = (ClientPrefs.flashing ? purpLvl : purpLvl * 0.5);
}

function onCountdownTick() {
	tenmas_dance();
}

function tenmas_dance() {
	lilGuy1.animation.play('Tenma1', true);
	lilGuy2.animation.play('Tenma2', true);
	lilGuy3.animation.play('Tenma3', true);
	lilGuy45.animation.play('Tenma4and5', true);
	audience.animation.play('AudienceTenmas', true);

	if (blendbgtween != null) {
		blendbgtween.cancel();
	}
}

function drop(dropping) {
	var time = dropping ? 2 : 3;
	dropped = dropping;
	purpLvl = dropping ? 0.625 : 0.325;
	purpTimer = dropping ? 1 : 4;

	if (ClientPrefs.shaders) {
		FlxTween.tween(sat, {saturation: dropping ? 0.5 : 0}, time);
		FlxTween.num(dropping ? 0 : 0.75, dropping ? 0.75 : 0, time, {
			onUpdate: (t) -> {
				purpleHUD.setFloat('hueBlend', t.value);
			}
		});

		FlxTween.num(dropping ? 0.5 : 1, dropping ? 1 : 0.5, time, {
			onUpdate: (t) -> {
				purple.setFloat('hueBlend', t.value);
			}
		});
	}

	for (i in [tenmaline1, tenmaline2, tenmalinebg])
		FlxTween.tween(i, {alpha: dropping ? 1 : 0}, time);
	for (i in [audience, thingyRight])
		FlxTween.tween(i, {alpha: dropping ? 0 : 1}, time);

	var y = ClientPrefs.downScroll ? -200 : 200;
	for (i in [playHUD.timeBar, playHUD.timeTxt])
		FlxTween.tween(i, {y: dropping ? i.y - y : i.y + y}, time * 0.75, {ease: dropping ? FlxEase.expoIn : FlxEase.expoOut});

	for (i in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2])
		FlxTween.tween(i, {y: dropping ? i.y + y : i.y - y}, time * 0.75, {ease: dropping ? FlxEase.expoIn : FlxEase.expoOut});
}

function insertFlxCamera(idx:Int, camera:FlxCamera, defDraw:Bool = false) {
	var cameras = [
		for (i in FlxG.cameras.list)
			{
				cam: i,
				defaultDraw: FlxG.cameras.defaults.contains(i)
			}
	];

	for (i in cameras)
		FlxG.cameras.remove(i.cam, false);

	cameras.insert(idx, {cam: camera, defaultDraw: defDraw});

	for (i in cameras)
		FlxG.cameras.add(i.cam, i.defaultDraw);
}
