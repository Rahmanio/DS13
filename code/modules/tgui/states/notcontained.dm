/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: tg_notcontained_state
 *
 * Checks that the user is not inside src_object, and then makes the
 * default checks.
 */

GLOBAL_DATUM_INIT(tg_notcontained_state, /datum/ui_state/tg_notcontained_state, new)

/datum/ui_state/tg_notcontained_state/can_use_topic(atom/src_object, mob/user)
	. = user.shared_ui_interaction(src_object)
	if(. > UI_CLOSE)
		return min(., user.tg_notcontained_can_use_topic(src_object))

/mob/proc/tg_notcontained_can_use_topic(src_object)
	return UI_CLOSE

/mob/living/tg_notcontained_can_use_topic(atom/src_object)
	if(src_object.contains(src))
		return UI_CLOSE // Close if we're inside it.
	return default_can_use_topic(src_object)

/mob/living/silicon/tg_notcontained_can_use_topic(src_object)
	return default_can_use_topic(src_object) // Silicons use default bevhavior.

/mob/living/simple_animal/drone/tg_notcontained_can_use_topic(src_object)
	return default_can_use_topic(src_object) // Drones use default bevhavior.
