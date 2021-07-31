/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: tg_always_state
 *
 * Always grants the user UI_INTERACTIVE. Period.
 */

GLOBAL_DATUM_INIT(tg_always_state, /datum/ui_state/tg_always_state, new)

/datum/ui_state/tg_always_state/can_use_topic(src_object, mob/user)
	return UI_INTERACTIVE
