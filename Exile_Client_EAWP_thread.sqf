/**
* Exile_Client_EAWP_thread
* V0.23
* by El Rabito
*
*/

private ["_lineIntersectsObjs","_IntersectCount","_EH","_type"];
if!(isNull objectParent player)exitWith{};
if ((toLower (animationState player)) in ["ladderriflestatic", "ladderrifleuploop", "ladderrifledownloop", "laddercivilstatic", "ladderciviluploop", "laddercivildownloop"]) exitWith{};
_lineIntersectsObjs = flatten [lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0.1,0,-0.1]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0,0.1]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0.1,0,0]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [-0.1,0,0]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,-0.1,0]],lineIntersectsObjs [eyePos player, AGLToASL positionCameraToWorld [0,0.1,0]]];
_IntersectCount = count _lineIntersectsObjs;
if(_lineIntersectsObjs isEqualTo []) then
{
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
		};
	} forEach _lineIntersectsObjs;
};
true
