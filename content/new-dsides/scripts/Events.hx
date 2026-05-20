
/**
 * [Events.hx]
 * Script that handles general events used across the mod, like:
 
 - Middle Camera
 - Lock On Camera
*/


var mid = false;
/**
 * [onEvent()]
 * Run when an EventNote in PlayState is triggered.
 
 * @param eventName 
 * String value of the Event Note's name.
 * @param value1 
 * String value of the Event Note's value1.
 * @param value2 
 * String value of the Event Note's value2.
 
 * In this script:
 *  Used for handling the Middle Camera & Lock On Camera events
 */
function onEvent(eventName, value1, value2) {
	switch (eventName) {
			case 'Angle':
				FlxTween.cancelTweensOf(camGame);

				var poop = value1.split(',');
				var angle = Std.parseFloat(poop[0]);
				var time = Std.parseFloat(poop[1]);

				var ease = poop.length <= 2 ? FlxEase.quartInOut : CoolUtil.getEaseFromString(poop[2]);

				FlxTween.tween(camGame, {angle: angle}, time, {ease: ease});

		case 'Middle Camera':
			switch (value1.toLowerCase()) {
				case 'on': mid = true;
				case 'off': mid = false;
				default: mid = !mid;
			}
			var shit = value2.split(',');
			if(shit.length < 2){
				for(i in shit.length...2)
					shit.push('0');
			}
			midCamera(shit);

		case 'Lock On Camera':
			var pos:Dynamic;

			if (value1 != '') {
				var pos_array:Array<Dynamic> = value1.split(', ');
				pos = FlxPoint.get(pos_array[0], pos_array[1]);

				camFollow.setPosition(pos.x, pos.y);
				FlxG.camera.snapToTarget();

				if (value2 != '') {
					defaultCamZoom = Std.parseFloat(value2);
					FlxG.camera.zoom = defaultCamZoom;
				}
				isCameraOnForcedPos = true;
			} else {
				isCameraOnForcedPos = false;
				defaultCamZoom = stage.stageData.defaultZoom;
				moveCameraSection();
			}
	}
}

var gfFocus = PlayState.SONG.song.toLowerCase() == 'boom bash';
var zoom = PlayState.SONG.song.toLowerCase() == 'boom bash' ? 0.525 : stage.stageData.defaultZoom;

/**
 * [midCamera()]
 * Used for setting the camera to the middle of the two characters.
 
 * @param add 
 * Array<Float> value for adding onto the auto-determined value 
 */
function midCamera(add:Array<Float>) {
	if (mid) {
		var pos = FlxPoint.get((boyfriend.getGraphicMidpoint().x + dad.getGraphicMidpoint().x) / 2,
			(boyfriend.getGraphicMidpoint().y + dad.getGraphicMidpoint().y) / 2);
		if (PlayState.SONG.song.toLowerCase() == 'boom bash')
			pos = FlxPoint.get(575, 325);
		camFollow.setPosition(pos.x + Std.parseFloat(add[1]), pos.y + Std.parseFloat(add[0]));
		defaultCamZoom = zoom;
		isCameraOnForcedPos = true;
		// trace(boyfriend.getGraphicMidpoint().x + dad.getGraphicMidpoint().x);
	} else {
		isCameraOnForcedPos = false;
		defaultCamZoom = stage.stageData.defaultZoom;
		moveCameraSection();
	}
}
