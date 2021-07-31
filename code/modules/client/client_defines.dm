/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
	parent_type = /datum
		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/datum/admins/deadmin_holder = null

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/adminobs		= null

	var/adminhelped = 0

	var/staffwarn = null

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0
	var/list/played_lobby_tracks	//List of tracks we've already heard this session. Used to sort-of prevent a user from hearing the same track more than once per round
	var/lobby_trackchange_timer			//Timer handle for queued lobby track change. This must be deleted when the client leaves the lobby

		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1

	var/received_irc_pm = -99999
	var/irc_admin			//IRC admin that spoke with them last.
	var/mute_irc = 0
	var/warned_about_multikeying = 0	// Prevents people from being spammed about multikeying every time their mob changes.
	var/connection_time //world.time they connected
	var/connection_realtime //world.realtime they connected
	var/connection_timeofday //world.timeofday they connected
	
		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id

	preload_rsc = 0 // This is 0 so we can set it to an URL once the player logs in and have them download the resources from a different server.

	var/datum/tooltip/tooltips

		////////////
		//MOUSE HANDLING//
		////////////
	var/last_click_atom	//The atom we last clicked, if it was on a turf

	/*-------------------------------
		View Handling
	--------------------------------*/
	var/view_offset_magnitude	//Cached when view offset is set

	//Static framerate
	fps = 40

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
