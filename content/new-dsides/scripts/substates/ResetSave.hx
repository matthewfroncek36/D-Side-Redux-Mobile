import funkin.utils.CameraUtil;
import funkin.backend.PlayerSettings;
import funkin.states.TitleState;
import funkin.scripting.PluginsManager;

var can = false;
var controls = PlayerSettings.player1.controls;

function onLoad()
{
    poop = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
    poop.alpha = 0;
    add(poop);

    bg = new FlxSprite().loadGraphic(Paths.image('menus/reset save'));
    bg.setGraphicSize(1200);
    bg.updateHitbox();
    bg.screenCenter();
    bg.y -= 30;
    add(bg);

    bg.alpha = 0;
    FlxTween.tween(poop, {alpha: 0.725}, 0.5);
    FlxTween.tween(bg, {alpha: 0.8}, 0.5);
    FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.5, {ease: FlxEase.circOut});
    FlxTween.tween(FlxG.sound.music, {volume: 0.2, pitch: 0.92}, 0.5);

    FlxTimer.wait(2, ()->{
        can = true;
    });
}

function onUpdate(elapsed)
{
    if(can){
        if(FlxG.keys.justPressed.Y){
            can = false;
            FlxG.sound.play(Paths.sound('confirmMenu'));

            CameraUtil.lastCamera.fade(FlxColor.BLACK, 4);
            FlxTween.tween(FlxG.sound.music, {volume: 0.00001, pitch: 0.00001}, 4);

            PluginsManager.callPluginFunc('Utils', 'deleteProgress', []);

            FlxTimer.wait(4.3, ()->{
                FlxG.switchState(()->{
                    new TitleState();
                });
            });
        }

        if(controls.BACK){
            cam = false;
            FlxTween.tween(FlxG.sound.music, {volume: 0.45, pitch: 1}, 0.5);
            FlxTween.tween(FlxG.camera, {zoom: 1}, 0.5, {ease: FlxEase.circIn});
            FlxTween.tween(bg, {alpha: 0}, 0.5);
            FlxTween.tween(poop, {alpha: 0}, 0.5);

            FlxTimer.wait(0.6, ()->{
                close();
            });
        }
    }
}