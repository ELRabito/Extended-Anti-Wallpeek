/**
* Exile_Client_EAWP_thread
*
* Copyright © El Rabito
* v0.50
*/
if !(player call ExileClient_util_world_isInTerritory) exitWith {};
if !(isnull ExileClientCameraObject) exitWith{};
if !(alive player) exitWith{};
if ((toLower (animationState player)) in ["ladderriflestatic", "ladderrifleuploop", "ladderrifledownloop", "laddercivilstatic", "ladderciviluploop", "laddercivildownloop"]) exitWith{};
if !(isNull (uiNamespace getVariable ['RscExileVirtualGarageDialog', displayNull])) exitwith {};
if !(isNull (uiNamespace getVariable ['RscSMPaint', displayNull])) exitwith {}; // SM_Paint

//X/Z/Y // https://community.bistudio.com/wikidata/images/e/e6/PositionCameraToWorld.jpg

private _maxIntersections = 2;
if ((stance player) == "PRONE") then {_maxIntersections = 1;};
private _lineIntersectsObjs = flatten [

	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,-0.07]],
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,0.07]],
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [-0.11,0,0]], 
	lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0.11,0,0]]  
];
private _IntersectCount = count _lineIntersectsObjs;
if(_lineIntersectsObjs isEqualTo []) then
{
	if(ExileClientGlitchBlackOut)then
	{ 
		ExileClientGlitchBlackOut = false;
		TitleText ['','PLAIN DOWN'];
		findDisplay 46 displayRemoveEventHandler ["keyDown",ESCEH];
	};
}	
else
{
	if(_IntersectCount < _maxIntersections) exitWith {};
	{
		if(_x getVariable ['ExileBreaching',false])exitWith{};
		private _type = typeOf _x;
		if(((_x isKindOf 'Exile_Construction_Abstract_Static') || (_x isKindOf 'AbstractConstruction') || (_x isKindOf 'AbstractWall') || (_x isKindOf 'House')) && !(_type in ['Exile_Construction_ConcreteStairs_Static','Exile_Construction_WoodStairs_Static','Exile_Plant_GreenBush','EBM_Metalwall_stairs','EBM_Brickwall_stairs','Land_GH_Stairs_F'])) exitWith 
		{
			if!(ExileClientGlitchBlackOut) then 
			{
				if(cameraView isEqualTo "EXTERNAL") then {player switchCamera "INTERNAL"};
				ExileClientGlitchBlackOut= true;
				TitleText ['ANTI-GLITCH BLACKOUT - Dont try to look through objects!','BLACK FADED'];
				ESCEH = (findDisplay 46) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then {true} else {false};"];
			};
		};
	} forEach _lineIntersectsObjs;
};
true
