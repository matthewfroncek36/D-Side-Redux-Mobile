import funkin.backend.math.Vector3;

var modManager;

function onLoad(modMgr)
{
	modManager = modMgr;
}

function getName() return 'tornado';
function getModType() return NOTE_MOD;

function getPos(time, visualDiff, timeDiff, beat, pos, data, player, obj)
{
	if (getPercent(player) == 0) return pos;
	
	var receptors = modManager.receptors[player];
	var len = receptors.length;
	
	// thank you 4mbr0s3
	var playerColumn = data % receptors.length;
	var columnPhaseShift = playerColumn * Math.PI / 3;
	var phaseShift = visualDiff / 135;
	var returnReceptorToZeroOffsetX = (-Math.cos(-columnPhaseShift) + 1) / 2;
	var offsetX = (-Math.cos(phaseShift - columnPhaseShift) + 1) / 2 - returnReceptorToZeroOffsetX;
	var outPos = pos.clone();
	
	return outPos.add(new Vector3(offsetX * getPercent(player)));
}
