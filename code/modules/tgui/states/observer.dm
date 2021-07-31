/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: tg_observer_state
 *
 * Checks that the user is an observer/ghost.
 */

GLOBAL_DATUM_INIT(tg_observer_state, /datum/ui_state/tg_observer_state, new)

/datum/ui_state/tg_observer_state/can_use_topic(src_object, mob/user)
	if(isobserver(user))
		return UI_INTERACTIVE
	return UI_CLOSE
