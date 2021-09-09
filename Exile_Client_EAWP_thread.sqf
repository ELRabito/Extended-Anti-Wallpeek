/**
* Exile_Client_EAWP_thread
* V0.24
* by El Rabito
*
*/

private ["_lineIntersectsObjs","_IntersectCount","_type"];
if !(isNull objectParent player) exitWith{};
if !(isnull ExileClientCameraObject) exitWith{};
if ((toLower (animationState player)) in ["ladderriflestatic", "ladderrifleuploop", "ladderrifledownloop", "laddercivilstatic", "ladderciviluploop", "laddercivildownloop"]) exitWith{};
_forceFP = false;

_lineIntersectsObjs = flatten [

	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0.05,0]],	// BACKWARDS Y/X/Z 
	                                                                                    
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [-0.08,0,0]],     // LEFT
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [-0.09,0,0]],     // LEFT 2
	                                                                                    
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0.08,0,0]],      // RIGHT
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0.09,0,0]],      // RIGHT 2
	                                                                                    
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,0.15]],     // DOWNWARDS
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,0.20]],     // DOWNWARDS 2
	                                                                                    
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,-0.1]]       // UPWARDS
];
_IntersectCount = count _lineIntersectsObjs;
if(_lineIntersectsObjs isEqualTo []) then
{
	
	if (diag_tickTime - ExileClientLastForcedFirstPerson >= 60 && _forceFP) then
	{
		if !(findDisplay 46 getVariable ["ForceFirstPersonModuleForced", -1] == -1) then 
		{
			_EH = findDisplay 46 getVariable ["ForceFirstPersonModuleForced", -1];
			findDisplay 46 setVariable ["ForceFirstPersonModuleForced", -1];
			(findDisplay 46) displayRemoveEventHandler ["KeyDown",_EH];
		};
	};
	if(ExileClientGlitchBlackOut)then{ ExileClientGlitchBlackOut = false;TitleText ['','PLAIN DOWN']; };
}	
else
{
	if(_IntersectCount < 3) exitWith {};
	{
		if(_x getVariable ['ExileBreaching',false])exitWith{};
		_type = typeOf _x;
		if(((_x isKindOf 'Exile_Construction_Abstract_Static') || (_x isKindOf 'AbstractConstruction') || (_x isKindOf 'AbstractWall') || (_x isKindOf 'House')) && !(_type in ['Exile_Construction_ConcreteStairs_Static','Exile_Construction_WoodStairs_Static','Exile_Plant_GreenBush','EBM_Metalwall_stairs','EBM_Brickwall_stairs','Land_GH_Stairs_F'])) exitWith 
		{
			if!(ExileClientGlitchBlackOut) then {ExileClientGlitchBlackOut= true;TitleText ['ANTI-GLITCH BLACKOUT - Dont try to look through objects!','BLACK FADED'];};
			if(cameraView isEqualTo "EXTERNAL") then {player switchCamera "INTERNAL"; if!(ExileClientGlitchBlackOut) then {ExileClientGlitchBlackOut= true;titleText ['ANTI-GLITCH BLACKOUT - Dont try to look through objects!','BLACK FADED'];};};
			if (findDisplay 46 getVariable ["ForceFirstPersonModuleForced", -1] == -1 && _forceFP) then 
			{
				_EH = findDisplay 46 displayAddEventHandler ["KeyDown", {if (inputAction "personView" > 0) then {["WarningTitleAndText", ["ANTI-GLITCH","-<br/>You are forced to first person for 60 seconds!"]] call ExileClient_gui_toaster_addTemplateToast; true;};}];
				findDisplay 46 setVariable ["ForceFirstPersonModuleForced", _EH];
				ExileClientLastForcedFirstPerson = diag_ticktime;
			};
		};
	} forEach _lineIntersectsObjs;
};
true
