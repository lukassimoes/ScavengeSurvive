new
		HoldActionLimit[MAX_PLAYERS],
		HoldActionProgress[MAX_PLAYERS],
Timer:	HoldActionTimer[MAX_PLAYERS],
		HoldActionState[MAX_PLAYERS];


forward OnHoldActionUpdate(playerid, progress);
forward OnHoldActionFinish(playerid);


StartHoldAction(playerid, duration, startvalue = 0)
{
	if(HoldActionState[playerid] == 1)
		return 0;

	stop HoldActionTimer[playerid];
	HoldActionTimer[playerid] = repeat HoldActionUpdate(playerid);

	HoldActionLimit[playerid] = duration;
	HoldActionProgress[playerid] = startvalue;
	HoldActionState[playerid] = 1;

	SetPlayerProgressBarMaxValue(playerid, ActionBar, HoldActionLimit[playerid]);
	SetPlayerProgressBarValue(playerid, ActionBar, HoldActionProgress[playerid]);
	ShowPlayerProgressBar(playerid, ActionBar);

	return 1;
}

StopHoldAction(playerid)
{
	if(HoldActionState[playerid] == 0)
		return 0;

	stop HoldActionTimer[playerid];
	HoldActionLimit[playerid] = 0;
	HoldActionProgress[playerid] = 0;
	HoldActionState[playerid] = 0;

	HidePlayerProgressBar(playerid, ActionBar);

	return 1;
}

timer HoldActionUpdate[100](playerid)
{
	if(HoldActionProgress[playerid] >= HoldActionLimit[playerid])
	{
		StopHoldAction(playerid);
		CallLocalFunction("OnHoldActionFinish", "d", playerid);
		return;
	}

	SetPlayerProgressBarMaxValue(playerid, ActionBar, HoldActionLimit[playerid]);
	SetPlayerProgressBarValue(playerid, ActionBar, HoldActionProgress[playerid]);
	ShowPlayerProgressBar(playerid, ActionBar);

	CallLocalFunction("OnHoldActionUpdate", "dd", playerid, HoldActionProgress[playerid]);

	HoldActionProgress[playerid] += 100;

	return;
}

#endinput

#include <YSI\y_hooks>
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 16)
	{
		StartHoldAction(playerid, 3000);
	}
	if(oldkeys & 16)
	{
		StopHoldAction(playerid);
	}
}
