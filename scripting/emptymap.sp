#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include "include/onserverempty"

#pragma newdecls required
#pragma semicolon 1

ConVar cv_Map;
char   g_Map[32];

ConVar cv_Countdown;
float  g_Countdown;

bool   g_IsTimerRunning;

public Plugin myinfo =
{
	name		= "Empty Map",
	author		= "ampere",
	description = "Changes server to specified map on server empty.",
	version		= "1.0",
	url			= ""
};

public void OnPluginStart()
{
	cv_Map = CreateConVar("sm_emptymap_map", "mge_chillypunch_final4_fix2", "Change to this map if server is empty.");
	cv_Map.GetString(g_Map, sizeof(g_Map));
	cv_Map.AddChangeHook(OnCvarChanged);

	cv_Countdown = CreateConVar("sm_emptymap_countdown", "60", "Amount of seconds the server must remain empty before changing map.");
	g_Countdown	 = cv_Countdown.FloatValue;
	cv_Countdown.AddChangeHook(OnCvarChanged);
}

public void OnCvarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	cv_Map = FindConVar("sm_emptymap_map");
	cv_Map.GetString(g_Map, sizeof(g_Map));

	g_Countdown = cv_Countdown.FloatValue;
}

public void OnServerEmpty()
{
	char currentMap[32];
	GetCurrentMap(currentMap, sizeof(currentMap));
	char chosenMap[32];
	cv_Map.GetString(chosenMap, sizeof(chosenMap));

	if (strcmp(currentMap, chosenMap) != 0)
	{
		PrintToServer("[SM] Starting timer to change to %s...", chosenMap);
		CreateTimer(g_Countdown, OnTimerElapsed);
		g_IsTimerRunning = true;
	}
}

public void OnServerNotEmpty()
{
	if (g_IsTimerRunning)
	{
		PrintToServer("[SM] Cancelling timer to change map!");
		g_IsTimerRunning = false;
	}
}

Action OnTimerElapsed(Handle timer)
{
	if (g_IsTimerRunning)
	{
		ForceChangeLevel(g_Map, "Empty server.");
		PrintToServer("[SM] Empty server! Changing map...");
		g_IsTimerRunning = false;
	}
	return Plugin_Continue;
}