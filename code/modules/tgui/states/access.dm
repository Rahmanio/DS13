/**
 * tgui state: tg_access_state
 *
 * Humans need to have access and be adjacent to use it.
 * Silicons and other lifeforms get their default ui_state pass.
 */

GLOBAL_DATUM_INIT(tg_access_state, /datum/ui_state/tg_access_state, new)

/datum/ui_state/tg_access_state/can_use_topic(src_object, mob/user)
	return user.tg_access_can_use_topic(src_object)

/mob/proc/tg_access_can_use_topic(src_object)
	return tg_default_can_use_topic(src_object)

/mob/living/tg_access_can_use_topic(src_object)
	. = tg_human_adjacent_can_use_topic(src_object)

	var/obj/O = src_object
	if(!O?.allowed(src)) //No access? No ui!
		to_chat(src, span_warning("Access Denied!"))
		return UI_CLOSE
	. = min(., UI_INTERACTIVE)

/mob/living/silicon/tg_access_can_use_topic(src_object)
	return tg_default_can_use_topic(src_object)
