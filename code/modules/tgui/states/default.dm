/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: tg_default_state
 *
 * Checks a number of things -- mostly physical distance for humans
 * and view for robots.
 */

GLOBAL_DATUM_INIT(tg_default_state, /datum/ui_state/tg_default, new)

/datum/ui_state/tg_default/can_use_topic(src_object, mob/user)
	return user.tg_default_can_use_topic(src_object) // Call the individual mob-overridden procs.

/mob/proc/tg_default_can_use_topic(src_object)
	return UI_CLOSE // Don't allow interaction by default.

/mob/living/tg_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE && loc) //must not be in nullspace.
		. = min(., shared_living_ui_distance(src_object)) // Check the distance...

/mob/living/silicon/robot/tg_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. <= UI_DISABLED)
		return

	// Robots can interact with anything they can see.
	var/list/clientviewlist = getviewsize(client.view)
	if(get_dist(src, src_object) <= min(clientviewlist[1],clientviewlist[2]))
		return UI_INTERACTIVE
	return UI_DISABLED // Otherwise they can keep the UI open.

/mob/living/silicon/ai/tg_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. < UI_INTERACTIVE)
		return

	// The AI can interact with anything it can see nearby, or with cameras while wireless control is enabled.
	if(!control_disabled && can_see(src_object))
		return UI_INTERACTIVE
	return UI_CLOSE

/mob/living/silicon/pai/tg_default_can_use_topic(src_object)
	// pAIs can only use themselves and the owner's radio.
	if(src_object == src /*|| src_object == radio*/ && !stat)	//TODO: add radio for silicon.
		return UI_INTERACTIVE
	else
		return min(..(), UI_UPDATE)
