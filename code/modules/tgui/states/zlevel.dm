/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: tg_z_state
 *
 * Only checks that the Z-level of the user and src_object are the same.
 */

GLOBAL_DATUM_INIT(tg_z_state, /datum/ui_state/tg_z_state, new)

/datum/ui_state/tg_z_state/can_use_topic(src_object, mob/user)
	var/turf/turf_obj = get_turf(src_object)
	var/turf/turf_usr = get_turf(user)
	if(turf_obj && turf_usr && turf_obj.z == turf_usr.z)
		return UI_INTERACTIVE
	return UI_CLOSE
