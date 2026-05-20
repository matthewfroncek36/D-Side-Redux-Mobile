function onLoad() {
	var bg:BGSprite = new BGSprite('backgrounds/ourple/feddy', -671, -170, 1, 1);
	bg.scale.set(.675, .675);
	bg.updateHitbox();
	bg.screenCenter();
	bg.y += 50;
	add(bg);
}

function onCreatePost()
{
	initScript('data/scripts/ourple_hud');
}