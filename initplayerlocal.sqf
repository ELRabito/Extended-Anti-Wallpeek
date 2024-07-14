
//// Add this to your initplayerlocal.sqf
//EAWP
ExileClientGlitchBlackOut = false;
_Exile_Client_EAWP_thread = compileFinal preprocessFileLineNumbers "custom\Exile_Client_EAWP_thread.sqf";
[0.5, _Exile_Client_EAWP_thread, [], true] call ExileClient_system_thread_addtask;
