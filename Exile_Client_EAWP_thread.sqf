/**
* Exile_Client_EAWP_thread
* V0.42 
* Copyright © El Rabito
*/

private ["_lineIntersectsObjs","_IntersectCount","_type","_forceFirstPerson","_forceFPDuration"];
if !(isNull objectParent player) exitWith{};
if !(isNull getConnectedUAV player)exitWith{};
if !(alive player) exitWith{findDisplay 46 displayRemoveEventHandler ["keyDown",ESCEH];};
if ((toLower (animationState player)) in ["ladderriflestatic", "ladderrifleuploop", "ladderrifledownloop", "laddercivilstatic", "ladderciviluploop", "laddercivildownloop"]) exitWith{};
if !(isnull ExileClientCameraObject) exitWith{};
if (ExilePlayerInSafezone) exitWith{};
if !(isNull (uiNamespace getVariable ['RscExileVirtualGarageDialog', displayNull])) exitwith {}; // Virtual Garage
if !(isNull (uiNamespace getVariable ['RscSMPaint', displayNull])) exitwith {}; // SM_Paint

// !!! Uncomment below if you don't use Safezones !!! 
//
//if !(isNull (uiNamespace getVariable ['RscExileTraderDialog', displayNull])) exitwith {}; 
//if !(isNull (uiNamespace getVariable ['RscExileVehicleTraderDialog', displayNull])) exitwith {}; 
//if !(isNull (uiNamespace getVariable ['RscExileVehicleCustomsDialog', displayNull])) exitwith {};

// ConfigSTART
_forceFirstPerson = false; 	// Force first person after glitching
_forceFPDuration = 60;		// Duration of the forced first person.

// Intersections
//X/Z/Y // https://community.bistudio.com/wikidata/images/e/e6/PositionCameraToWorld.jpg
_lineIntersectsObjs = flatten [
                                                                    
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,-0.12,-0.06]],		
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,-0.12,0.06]],		                                                                        
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [-0.08,-0.12,0]],	
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0.08,-0.12,0]],
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0.08,0]]
];
_IntersectCount = count _lineIntersectsObjs;
// ConfigEND

if(_lineIntersectsObjs isEqualTo []) then
{
	if (_forceFirstPerson) then
	{
		if (diag_tickTime - ExileClientLastForcedFirstPerson >= _forceFPDuration) then
		{
			if !(findDisplay 46 getVariable ["ForceFirstPersonModuleForced", -1] == -1) then 
			{
				_EH = findDisplay 46 getVariable ["ForceFirstPersonModuleForced", -1];
				findDisplay 46 setVariable ["ForceFirstPersonModuleForced", -1];
				(findDisplay 46) displayRemoveEventHandler ["KeyDown",_EH];
			};
		};
	};
	if(ExileClientGlitchBlackOut)then
	{ 
		ExileClientGlitchBlackOut = false;
		TitleText ['','PLAIN DOWN'];
		findDisplay 46 displayRemoveEventHandler ["keyDown",ESCEH];
	};
}	
else
{
	if(_IntersectCount < 3) exitWith {};
	{
		if(_x getVariable ['ExileBreaching',false])exitWith{};
		_type = typeOf _x;
		if(((_x isKindOf 'Exile_Construction_Abstract_Static') || (_x isKindOf 'AbstractConstruction') || (_x isKindOf 'AbstractWall') || (_x isKindOf 'House')) && !(_type in ['Exile_Construction_ConcreteStairs_Static','Exile_Construction_WoodStairs_Static','Exile_Plant_GreenBush','EBM_Metalwall_stairs','EBM_Brickwall_stairs','Land_GH_Stairs_F'])) exitWith 
		{
			if!(ExileClientGlitchBlackOut) then 
			{
				if(cameraView isEqualTo "EXTERNAL") then {player switchCamera "INTERNAL"};
				ExileClientGlitchBlackOut= true;
				TitleText ['ANTI-GLITCH BLACKOUT - Dont try to look through objects!','BLACK FADED'];
				ESCEH = (findDisplay 46) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then {true} else {false};"];
			};
			if (findDisplay 46 getVariable ["ForceFirstPersonModuleForced", -1] == -1 && _forceFirstPerson) then 
			{
				_EH = findDisplay 46 displayAddEventHandler ["KeyDown", {if (inputAction "personView" > 0) then {["WarningTitleAndText", ["ANTI-GLITCH","-<br/>You are forced to first person for 60 seconds!"]] call ExileClient_gui_toaster_addTemplateToast; true;};}];
				findDisplay 46 setVariable ["ForceFirstPersonModuleForced", _EH];
				ExileClientLastForcedFirstPerson = diag_ticktime;
			};
		};
	} forEach _lineIntersectsObjs;
};
true
