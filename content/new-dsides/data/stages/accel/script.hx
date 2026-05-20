import funkin.objects.Bopper;
import funkin.scripts.ScriptedFlxRandom;

var lights = [];
var screens = [];
var pulse:Float = 0;
var totalElapsed:Float = 0;
var extraBopping = false;

function onLoad()
{
    var bg = new FlxSprite(-1050,-400).loadGraphic(Paths.image('backgrounds/accel/bg'));
    bg.setScale(1.125, 1.125);
    bg.scrollFactor.set(0.7, 0.6);
    add(bg);

    speaker = new Bopper(75, 50).loadAtlas('backgrounds/accel/GruntSpeakers');
    speaker.addAnimByPrefix('idle', 'DJ Set', 24, false);
    speaker.setScale(0.7, 0.7);
    speaker.scrollFactor.set(0.7, 0.6);
    add(speaker);

    if(!ClientPrefs.lowQuality){
        var path = Paths.getSparrowAtlas('backgrounds/accel/AccelerantScreens');

        var screen = new Bopper(-810, -205).setFrames(path);
        screen.addAnimByPrefix('idle', 'ScreensLeftHank', 24, true);
        screen.addAnimByPrefix('static', 'ScreensLeftStatic', 24, true);
        screen.addAnimByPrefix('tricky', 'ScreensLeftTricky', 24, true);
        screen.playAnim('idle');
        screen.scrollFactor.set(0.7, 0.6);
        screen.setScale(1.125, 1.125);
        screen.alpha = !ClientPrefs.flashing ? 0.2 : 1;
        add(screen);

        var screen2 = new Bopper(1286, -230).setFrames(path);
        screen2.addAnimByPrefix('idle', 'ScreensRightHank', 24, true);
        screen2.addAnimByPrefix('static', 'ScreensRightStatic', 24, true);
        screen2.addAnimByPrefix('tricky', 'ScreensRightTricky', 24, true);
        screen2.addOffset('tricky', 32, -5);
        screen2.addOffset('static', -40, -52);
        screen2.addOffset('idle', -40, -60);
        screen2.playAnim('idle');
        screen2.scrollFactor.set(0.7, 0.6);
        screen2.setScale(1.125, 1.125);
        screen2.alpha = !ClientPrefs.flashing ? 0.2 : 1;
        add(screen2);


        screens = [screen, screen2];
    }

    girl = new Character(0,0,'grunt_gf_accel');
    girl.scrollFactor.set(0.7, 0.6);
    girl.playAnim('dieTRICK-2');
    add(girl);


    if(!ClientPrefs.lowQuality){
        sanford = new Character(-240,238,'grunt_bonus');
        sanford.idleSuffix = '-sanford';
        sanford.recalculateDanceIdle();
        sanford.scrollFactor.set(0.7, 0.6);
        sanford.visible = false;
        add(sanford);
        
        gf2 = new Character(-240, 238, 'grunt_bonus');
        gf2.idleSuffix = '-gf';
        gf2.recalculateDanceIdle();
        gf2.scrollFactor.set(0.7, 0.6);
        gf2.visible = false;
        add(gf2);
        
        l5 = new FlxSprite(-142, 225).loadGraphic(Paths.image('backgrounds/accel/l5'));
        l5.setScale(1.125, 1.125);
        l5.scrollFactor.set(0.7, 0.6);
        l5.blend = BlendMode.ADD;
        add(l5);

        l7 = new FlxSprite(-142, 225).loadGraphic(Paths.image('backgrounds/accel/l7'));
        l7.setScale(1.125, 1.125);
        l7.scrollFactor.set(0.7, 0.6);
        l7.blend = BlendMode.ADD;
        add(l7);

        l6 = new FlxSprite(1164, 340).loadGraphic(Paths.image('backgrounds/accel/l6'));
        l6.setScale(1.125, 1.125);
        l6.scrollFactor.set(0.7, 0.6);
        l6.blend = BlendMode.ADD;
        add(l6);

        l8 = new FlxSprite(850, 340).loadGraphic(Paths.image('backgrounds/accel/l8'));
        l8.setScale(1.125, 1.125);
        l8.scrollFactor.set(0.7, 0.6);
        l8.blend = BlendMode.ADD;
        add(l8);

        bl = new FlxSprite().makeGraphic(4000, 2000, FlxColor.WHITE);
        bl.alpha = 0;
        bl.scrollFactor.set();
        bl.screenCenter();
        bl.blend = BlendMode.ADD;
        add(bl);

        redTricky = new FlxSprite(-1000, 340).loadGraphic(Paths.image('backgrounds/accel/stageGradient'));
        //redTricky.alpha = 0;
        redTricky.blend = BlendMode.ADD;
        redTricky.color = FlxColor = 0xffFF0000;
        redTricky.setScale(2.25, 1.025);

        redTricky.alpha = 0;
        add(redTricky);

        lightTricky1 = new FlxSprite(-400, -240).loadGraphic(Paths.image('backgrounds/accel/Light'));
        //redTricky.alpha = 0;
        lightTricky1.blend = BlendMode.ADD;
        lightTricky1.setScale(1.5, 1.5);
        lightTricky1.alpha = 0;
        lightTricky1.color = FlxColor = 0xffFF0000;
        add(lightTricky1);

        lightTricky2 = new FlxSprite(1200, -240).loadGraphic(Paths.image('backgrounds/accel/Light'));
        //redTricky.alpha = 0;
        lightTricky2.blend = BlendMode.ADD;
        lightTricky2.setScale(1.5, 1.5);
        lightTricky2.alpha = 0;
        lightTricky2.color = FlxColor = 0xffFF0000;
        add(lightTricky2);
        
        whit = new FlxSprite().makeGraphic(4000, 2000, 0xFF00FFFF);
        whit.alpha = 0;
        whit.blend = BlendMode.ADD;
        whit.scrollFactor.set();
        whit.screenCenter();
        add(whit);

    }

    var floor = new FlxSprite(-650, 625).loadGraphic(Paths.image('backgrounds/accel/stage'));
    floor.setScale(1.125, 1.125);
    add(floor);

    if(!ClientPrefs.lowQuality){
        l1 = new FlxSprite(-830, 420).loadGraphic(Paths.image('backgrounds/accel/l1'));
        l1.setScale(1.125, 1.125);
        l1.scrollFactor.set(0.7, 0.6);
        l1.blend = BlendMode.ADD;
        add(l1);

        l3 = new FlxSprite(-830, 420).loadGraphic(Paths.image('backgrounds/accel/l3'));
        l3.setScale(1.125, 1.125);
        l3.scrollFactor.set(0.7, 0.6);
        l3.blend = BlendMode.ADD;
        add(l3);

        l2 = new FlxSprite(1080, 500).loadGraphic(Paths.image('backgrounds/accel/l2'));
        l2.setScale(1.125, 1.125);
        l2.scrollFactor.set(0.7, 0.6);
        l2.blend = BlendMode.ADD;
        add(l2);

        l4 = new FlxSprite(1460, 500).loadGraphic(Paths.image('backgrounds/accel/l4'));
        l4.setScale(1.125, 1.125);
        l4.scrollFactor.set(0.7, 0.6);
        l4.blend = BlendMode.ADD;
        add(l4);

        for(i in [l1, l2, l3, l4, l5, l6, l7, l8]){
            i.alpha = 0;
            lights.push(i);
        }

        fgGrunt = new Character(-950,600,'grunt_fg');
        fgGrunt.scrollFactor.set(1.2, 1.1);
        add(fgGrunt);

        fgGrunt2 = new Character(1550,600,'grunt_fg');
        fgGrunt2.scrollFactor.set(1.2, 1.1);
        add(fgGrunt2);
    }

    jeebus = new Bopper(260, -800);
    jeebus.loadAtlas('backgrounds/accel/ending');
    jeebus.addAnimByPrefix('braaap', 'JebusFullEntrance', 24, false);
    jeebus.playAnim('braaap', true);
    add(jeebus);

    agent1 = new Bopper(1600, -800);
    agent1.loadAtlas('backgrounds/accel/ending');
    agent1.addAnimByPrefix('braaap', 'Agent1Cameo', 24, false);
    agent1.playAnim('braaap', true);
    agent1.scrollFactor.set(0.7, 0.6);
    add(agent1);

    scrape = new Bopper(-750, -1060);
    scrape.loadAtlas('backgrounds/accel/ending');
    scrape.addAnimByPrefix('braaap', 'ScrapefaceCameo', 24, false);
    scrape.playAnim('braaap', true);
    scrape.scrollFactor.set(0.7, 0.6);
    add(scrape);

    for(i in [jeebus, agent1, scrape]){
        i.visible = false;
    }

    yellow_sub = new FlxSprite().makeGraphic(1280, 720, 0xFFb26e0d);
    yellow_sub.camera = camHUD;
    yellow_sub.blend = BlendMode.SUBTRACT;
    yellow_sub.alpha = 0.1;
    add(yellow_sub);

    if(!ClientPrefs.lowQuality){
        speaker.zIndex = 1;
        girl.zIndex = 2;
        sanford.zIndex = 2;
        gf2.zIndex = 2;
        for(i in [l1, l2, l3, l4, l5, l6, l7, l8])
            i.zIndex = 3;
        redTricky.zIndex = 4;
        lightTricky1.zIndex = 4;
        lightTricky2.zIndex = 4;
        agent1.zIndex = 4;
        scrape.zIndex = 4;
        floor.zIndex = 4;
        boyfriendGroup.zIndex = 5;
        jeebus.zIndex = 5;
        dadGroup.zIndex = 6;
        whit.zIndex = 999;
        fgGrunt2.zIndex = 999;
        fgGrunt.zIndex = 999;
    } else{
        speaker.zIndex = 1;
        girl.zIndex = 2;
        boyfriendGroup.zIndex = 5;
        dadGroup.zIndex = 6;

    }
}

var canMoveLeft = true;
var canMoveRight = true;

function triggerFGGrunt(dir:String)
{
    var grunt = dir == 'left' ? fgGrunt : fgGrunt2;
    var enemy = dir == 'left' ? sanford : gf2;
    var enemyAnim = dir == 'left' ? 'sanford' : 'gf';

    grunt.onAnimationFinish.removeAll();

    grunt.playAnim('enter-' + dir, true);
    grunt.visible = true;

    grunt.onAnimationFinish.addOnce(()->{
        FlxTimer.wait(0.2, ()->{
            enemy.canDance = false;
            enemy.playAnim(enemyAnim + 'gun', true);
            grunt.playAnim('die-' + dir, true);
            grunt.onAnimationFinish.addOnce(()->{
                grunt.visible = false;
                enemy.canDance = true;
                grunt.onAnimationFinish.removeAll();
            });
        });
    });
}

function onCreatePost()
{
	initScript('data/scripts/NoteWarning');

    snapCamToPos(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y);

    gfGroup.scrollFactor.set(0.7, 0.6);
    girl.setPosition(gf.x - 140, gf.y);
    girl.visible = false;

    modManager.queueFuncOnce(528, ()->{
        FlxTween.tween(camHUD, {alpha: 0.4}, 2);

        isCameraOnForcedPos = true;
        camFollow.setPosition(getCharacterCameraPos(gf).x, getCharacterCameraPos(gf).y + 215);

        boyfriend.playAnim('scene', true);
        boyfriend.specialAnim = true;

        gf.playAnim('scene', true);
        gf.specialAnim = true;
        gf.idleSuffix = '-tricky';
        gf.recalculateDanceIdle();

    });
}

function onEvent(name, v1, v2)
{
    if(name == 'Song Events'){
        switch(v1){
            case 'end':
                for(i in [agent1, scrape]){
                    i.playAnim('braaap', true);
                    i.visible = true;
                }

                canMoveLeft = canMoveRight = false;

                boyfriend.playAnim('end', true);
                boyfriend.specialAnim = true;
                boyfriend.canDance = false;

                dad.canDance = false;
                dad.onAnimationFinish.addOnce(()->{
                    dad.playAnim('End', true);
                    dad.specialAnim = true;

                    jeebus.playAnim('braaap', true);
                    jeebus.visible = true;
                });
            case 'screen':
                for(i in screens)
                    i.playAnim(v2, true);
            case 'tricky die':
                girl.visible = true;
                girl.playAnim('dieTRICK-2', true);
                girl.specialAnim = true;

                if(!ClientPrefs.lowQuality){
                    FlxTimer.wait(1, ()->{
                        sanford.visible = true;
                        sanford.playAnim('entrance', true);
                        sanford.onAnimationFinish.addOnce(()->{
                            sanford.dance();
                            gf2.dance();
                            gf2.visible = true;

                            extraBopping = true;
                        });
                    });
                }

            case 'gf die':
                girl.visible = true;
                girl.playAnim('dieGF', true);
                girl.specialAnim = true;
        }
        girl.onAnimationFinish.add(()->{
            girl.visible = false;
        });
    }
}

var colors = [
    FlxColor.RED,
    FlxColor.GREEN,
    FlxColor.BLUE,
    FlxColor.PURPLE,
    FlxColor.ORANGE
];

function onSectionHit()
{
    if(ClientPrefs.lowQuality)
        return ScriptConstants.CONTINUE_FUNC;

    var poop = [];
    for(i in 0...4){
        poop.push(FlxG.random.int(0, 7), [poop]);
        // trace(i)
    }

    var prevColors = [];
    for(i in poop){
        var col = FlxG.random.int(0, 4, prevColors);
        prevColors.push(col);

        lights[i].color = colors[col];
        lights[i].alpha = 1;
        FlxTween.tween(lights[i], {alpha: 0}, 1);
    }
}

function opponentNoteHit(note){
    if(!note.isSustainNote && note.noteType == 'Accelerant Gun' && !ClientPrefs.lowQuality && ClientPrefs.flashing){
        FlxTween.cancelTweensOf(whit);
        whit.alpha = 0.3;
        FlxTween.tween(whit, {alpha: 0}, 0.4);

        FlxTween.cancelTweensOf(bl);
        bl.alpha = 0.1;
        FlxTween.tween(bl, {alpha: 0}, 0.4);

    }
}

function onBeatHit()
{
    speaker.dance(true);

    if(ClientPrefs.lowQuality)
        return ScriptConstants.CONTINUE_FUNC;

    if(extraBopping){
        sanford.dance();
        gf2.dance();

        if(FlxG.random.bool(20)){
            var choice = ['left', 'right'][FlxG.random.int(0, 1)];
            var can = (choice == 1 ? canMoveLeft : canMoveRight);

            if(can){
                can = false;
                triggerFGGrunt(choice);
                // FlxTimer.wait(1, ()->{
                //     can = true;
                // });
            }
        }
    }

    switch (curBeat) {
        case 164:
            for (i in [lightTricky1,lightTricky2]){
                i.angle = -10;
                FlxTween.tween(i, {alpha: 1}, 1 - (FlxG.random.float(0, 5)*0.2), {type: 4, ease: FlxEase.cubeInOut});
                FlxTween.tween(i, {angle: 10}, 2.8 - (FlxG.random.float(0, 5)*0.2), {type: 4, ease: FlxEase.quartInOut});
            }
		case 236:
            fadeActive = true;
            FlxTween.cancelTweensOf(lightTricky1);
            FlxTween.cancelTweensOf(lightTricky2);

            for (i in [lightTricky1,lightTricky2])
                FlxTween.tween(i, {alpha: 0}, 2, {ease: FlxEase.cubeInOut});

            FlxTween.tween(redTricky, {alpha: 1}, 4, {type: 4});

    }
}