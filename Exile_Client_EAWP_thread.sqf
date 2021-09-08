/**
* Exile_Client_EAWP_thread
* V0.22
* by El Rabito
*
*/

private ["_lineIntersectsObjs","_IntersectCount","_EH","_type"];
if!(isNull objectParent player)exitWith{};
if ((toLower (animationState player)) in ["ladderriflestatic", "ladderrifleuploop", "ladderrifledownloop", "laddercivilstatic", "ladderciviluploop", "laddercivildownloop"]) exitWith{};
_lineIntersectsObjs = flatten [lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,-0.1]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,0.1]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0.1,0,0]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [-0.1,0,0]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,-0.1,0]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0.1,0]]];
_IntersectCount = count _lineIntersectsObjs;
if(_lineIntersectsObjs isEqualTo []) then
{
	if (diag_tickTime - ExileClientLastForcedFirstPerson >= 60) then
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
		if(
			(
				(_x isKindOf 'Exile_Construction_Abstract_Static') || (_x isKindOf 'AbstractConstruction') || (_x isKindOf 'AbstractWall') || (_x isKindOf 'House')) && !(_type in ['Exile_Construction_ConcreteStairs_Static','Exile_Construction_WoodStairs_Static','Exile_Plant_GreenBush','EBM_Metalwall_stairs','EBM_Brickwall_stairs','Land_GH_Stairs_F'])
		) 
		exitWith 
		{
				if (cameraView isEqualTo "EXTERNAL") then {player switchCamera "INTERNAL";["WarningTitleAndText", ["ANTI-GLITCH","-<br/>You are forced to first person for 60 seconds!"]] call ExileClient_gui_toaster_addTemplateToast};
				if (findDisplay 46 getVariable ["ForceFirstPersonModuleForced", -1] == -1) then 
				{
					_EH = findDisplay 46 displayAddEventHandler ["KeyDown", {if (inputAction "personView" > 0) then {["WarningTitleAndText", ["ANTI-GLITCH","-<br/>You are forced to first person for 60 seconds!"]] call ExileClient_gui_toaster_addTemplateToast; true;};}];
					findDisplay 46 setVariable ["ForceFirstPersonModuleForced", _EH];
					ExileClientLastForcedFirstPerson = diag_ticktime;
				};
				if!(ExileClientGlitchBlackOut) then {ExileClientGlitchBlackOut= true;TitleText ['ANTI-GLITCH BLACKOUT - Dont try to look through objects!','BLACK FADED'];};
		};
	} forEach _lineIntersectsObjs;
};
true
