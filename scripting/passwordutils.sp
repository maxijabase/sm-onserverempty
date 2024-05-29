#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include "include/onserverempty"

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name		= "Password Utils",
	author		= "ampere",
	description = "Password utils",
	version		= "1.0",
	url			= "github.com/maxijabase"
};

ConVar sv_password;
ConVar cv_Countdown;
bool   g_IsTimerRunning;

public void OnPluginStart()
{
	RegAdminCmd("sm_nopw", CMD_NoPW, ADMFLAG_GENERIC);
	RegAdminCmd("sm_pw", CMD_PW, ADMFLAG_GENERIC);

	sv_password	 = FindConVar("sv_password");
	cv_Countdown = CreateConVar("sm_passwordutils_countdown", "60", "Amount of seconds the server must remain empty before clearing the password.");
}

public Action CMD_NoPW(int client, int flags)
{
	sv_password.SetString("");
	ReplyToCommand(client, "[SM] Password cleared.");
	return Plugin_Handled;
}

public Action CMD_PW(int client, int args)
{
	if (args != 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_pw <password>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	sv_password.SetString(arg1);
	return Plugin_Handled;
}

public void OnServerEmpty()
{
	char pw[32];
	sv_password.GetString(pw, sizeof(pw));
	if (pw[0] != '\0')
	{
		PrintToServer("[SM] Starting timer to clear password...");
		CreateTimer(cv_Countdown.FloatValue, OnTimerElapsed);
		g_IsTimerRunning = true;
	}
}

public void OnServerNotEmpty()
{
	if (g_IsTimerRunning)
	{
		PrintToServer("[SM] Cancelling timer to clear password...");
		g_IsTimerRunning = false;
	}
}

Action OnTimerElapsed(Handle timer)
{
	if (g_IsTimerRunning)
	{
		sv_password.SetString("");
		PrintToServer("[SM] Empty server! Clearing password.");
		g_IsTimerRunning = false;
	}
	return Plugin_Continue;
}