import openfl.filters.ShaderFilter;

var skew = newShader('3D Floor');
var sand:FlxSprite;
var bgCameos:FlxSpriteGroup;
var camBeach:FlxCamera;
var camSkew:FlxCamera;

function onLoad() {
	camGame.bgColor = 0x0;
	camBeach = new FlxCamera(0, 0, 1280, 720);
	camBeach.bgColor = 0x0;
	camSkew = new FlxCamera(0, 0, 1280, 720);
	camSkew.bgColor = 0x0;
	FlxG.cameras.insert(camBeach, 0, false);
	FlxG.cameras.insert(camSkew, 1, false);

	var sky = makeSpr(0, 0, 'whittysky');
	sky.scrollFactor.set(0.26, 0.2);
	sky.screenCenter();
	sky.y += 50;
	sky.camera = camBeach;
	add(sky);

	sand = makeSpr(0, 0, 'whittysand');
	sand.scrollFactor.set(0.3, sky.scrollFactor.y);
	sand.screenCenter();
	sand.camera = camSkew;
	sand.y += 20;
	sand.shader = skew;
	add(sand);

	if(!ClientPrefs.lowQuality){
		bgCameos = new FlxSpriteGroup(0,80);

		var id = -1;
		for (i in ['MattandShaggy', 'Jim', 'licorice', 'niblet', 'nikku']) {
			id += 1;
			var spr = makeBackSprite(id);
			spr.animation.addByPrefix('idle', i, 24, true);
			spr.animation.play('idle');
			spr.scrollFactor.set(1.6, 1.2);
			bgCameos.add(spr);
		}
		add(bgCameos);
	}

	var umb = makeSpr(0, 0, 'whittyumbrella');
	umb.scrollFactor.set(0.66, 0.66);
	umb.screenCenter();
	umb.y += 50;
	add(umb);

	var floor = makeSpr(0, 0, 'whittyfloor');
	floor.screenCenter();
	add(floor);

	if(!ClientPrefs.lowQuality){
		frontCameos = new FlxTypedGroup();
		frontCameos.zIndex = 999;
		add(frontCameos);

		var id = -1;
		for (i in ['DadnMe', 'SMCharacters', 'SkarletandMora', 'alienhominid', 'enaandfroggy']) {
			id += 1;
			var spr = makeFrontSprite(id);
			spr.animation.addByPrefix('idle', i, 24, true);
			spr.animation.play('idle');
			frontCameos.add(spr);
		}
	}

	for (item in [sky, sand, umb, floor]) {
		item.antialiasing = true;
	}
}

function makeSpr(x, y, name) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas('backgrounds/beach/beach'));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);

	return sprite;
}

function makeFrontSprite(id) {
	var spr = new FlxSprite();
	spr.frames = Paths.getSparrowAtlas('backgrounds/beach/cameos');
	spr.flipX = true;
	spr.ID = id;
	spr.scrollFactor.set(1.5, 1.1);
	spr.antialiasing = true;
	if (spr.ID == 1)
		spr.flipX = !spr.flipX;
	spr.visible = false;

	return spr;
}

function makeBackSprite(id) {
	var spr = new FlxSprite();
	spr.frames = Paths.getSparrowAtlas('backgrounds/beach/cameos');
	spr.scrollFactor.set(0.3, 0.2);
	spr.visible = false;

	return spr;
}

function onCreatePost() {
	dad.forceDance = true;
	followingCams.push(camBeach);
	followingCams.push(camSkew);
	camSkew.filters = [new ShaderFilter(skew)];
}

var canMoveBack:Bool = true;
var prevBacks = [1];

function moveBackChar(id) {
	canMoveBack = false;
	prevBacks.push(id);

	var spr = bgCameos.members[id];
	var dir = FlxG.random.bool(50) ? spr.flipX ? 1 : -1 : spr.flipX ? -1 : 1;
	spr.visible = true;

	if (dir == 1) {
		spr.flipX = false;
		spr.setPosition(1600 + spr.width, FlxG.random.float(200, 250));
		FlxTween.tween(spr, {x: -700 - spr.width}, 22);
	} else {
		spr.flipX = true;
		spr.setPosition(-700 - spr.width, FlxG.random.float(200, 250));
		FlxTween.tween(spr, {x: 1600 + spr.width}, 22);
	}
	FlxTimer.wait(22, () -> {
		canMoveBack = true;
		spr.visible = false;
		if (prevBacks.length > 2)
			prevBacks.remove(prevBacks[0]);
	});
}

var ys = [485, 425, 540, 590, 480];
var canMoveFront = true;
var prevFronts = [0, 1];

function moveFrontChar(id) {
	canMoveFront = false;
	prevFronts.push(id);

	var spr = frontCameos.members[id];
	var dir = FlxG.random.bool(50) ? -1 : 1;
	spr.visible = true;
	if (dir == -1) {
		spr.flipX = true;
		spr.setPosition(-spr.width * 2, ys[spr.ID] + 50);
		FlxTween.tween(spr, {x: FlxG.width + spr.width}, 15);
	} else {
		spr.flipX = false;
		spr.setPosition(FlxG.width + spr.width, ys[spr.ID] + 50);
		FlxTween.tween(spr, {x: -spr.width * 2}, 15);
	}
	FlxTimer.wait(15, () -> {
		canMoveFront = true;
		spr.visible = false;
		if (prevFronts.length > 2)
			prevFronts.remove(prevFronts[0]);
	});
}

var camFollowPos:Float;

function onUpdatePost(elapsed) {
	for (i in [dad, gf, boyfriend])
		i.color = 0xFFfac7a5;

	var skew_pos:Float = 0.05 * ((camFollowPos - 625) * 0.014);
	camFollowPos = FlxMath.lerp(camFollowPos, camFollow.x, FlxMath.bound(elapsed * 3, 0, 1));

	skew.setFloat('curveX', skew_pos * 0.5);

	sand.x = -880 + (skew_pos * 1200);
	
	if(!ClientPrefs.lowQuality)
		bgCameos.y = 200 * (skew_pos);
}

function onBeatHit() {
	if(ClientPrefs.lowQuality)
		return;
	
	if (canMoveFront)
		moveFrontChar(FlxG.random.int(0, 4, prevFronts));

	if (canMoveBack)
		moveBackChar(FlxG.random.int(0, 4, prevBacks));
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
