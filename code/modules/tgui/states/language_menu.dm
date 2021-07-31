/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: tg_language_menu_state
 */

//we dont use this
GLOBAL_DATUM_INIT(tg_language_menu_state, /datum/ui_state/tg_language_menu, new)

/datum/ui_state/tg_language_menu/can_use_topic(src_object, mob/user)
	. = UI_CLOSE
	if(check_rights(R_ADMIN, TRUE, user.client))
		. = UI_INTERACTIVE
	else/* if(istype(src_object, /datum/language_holder))
		var/datum/language_holder/LM = src_object
		if(LM.get_atom() == user)*/ //TODO: rework system languages
		. = UI_INTERACTIVE
