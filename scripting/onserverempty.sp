#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#pragma newdecls required
#pragma semicolon 1

GlobalForward g_OnServerEmpty;
GlobalForward g_OnServerNotEmpty;

public Plugin myinfo =
{
	name		= "[API] OnServerEmpty",
	author		= "ampere",
	description = "Exposes an OnServerEmpty forward.",
	version		= "1.0.0",
	url			= "https://github.com/maxijabase/sm-onserverempty"
};

public void OnPluginStart()
{
	g_OnServerEmpty	   = new GlobalForward("OnServerEmpty", ET_Ignore);
	g_OnServerNotEmpty = new GlobalForward("OnServerNotEmpty", ET_Ignore);
}

public void OnClientAuthorized(int client)
{
	if (GetClients() == 0)
	{
		Forward_OnServerNotEmpty();
	}
}

public void OnClientDisconnect_Post(int client)
{
	if (GetClients() == 0)
	{
		Forward_OnServerEmpty();
	}
}

void Forward_OnServerEmpty()
{
	Call_StartForward(g_OnServerEmpty);
	Call_Finish();
}

void Forward_OnServerNotEmpty()
{
	Call_StartForward(g_OnServerNotEmpty);
	Call_Finish();
}

int GetClients()
{
	int clients = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i) && !IsClientSourceTV(i))
		{
			clients++;
		}
	}
	return clients;
}