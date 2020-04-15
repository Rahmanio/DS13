#define VIEW_RANGE_CLOSED	6
#define VIEW_OFFSET_CLOSED	0
#define VIEW_RANGE_OPEN	9
#define VIEW_OFFSET_OPEN	(WORLD_ICON_SIZE*5)

#define MOVESPEED_OPEN		0.25
#define SPINE_WINDUP	(1 SECOND)
#define SPINE_COOLDOWN	(2.5 SECONDS)
/*
	Lurker:

	Slow ranged support mob. High damage, but fairly slow movement
	Has retractable armor.
		When Closed:
			Very tough
			Reduced Vision
			Can't attack

		When Open
			Vulnerable
			Longer vision range
			Can launch ranged attacks
			Slower movement
*/

/datum/species/necromorph/lurker
	name = SPECIES_NECROMORPH_LURKER
	mob_type	=	/mob/living/carbon/human/necromorph/lurker
	blurb = "Long range fire-support. The lurker is tough and hard to hit as long as its retractible armor is closed. When open it is slow and vulnerable, but fires sharp spines in waves of three."
	unarmed_types = list(/datum/unarmed_attack/claws/lurker) //Bite attack is a backup if blades are severed
	total_health = 60
	biomass = 50

	icon_template = 'icons/mob/necromorph/lurker.dmi'
	icon_lying = "_lying"
	single_icon = FALSE
	spawner_spawnable = TRUE

	pixel_offset_x = -16

	evasion = 10	//Doesn't move much, but small target

	view_range = VIEW_RANGE_CLOSED
	view_offset = VIEW_OFFSET_CLOSED


	has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest/simple),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm/tentacle/slim/lurker1),
	BP_HEAD =   list("path" = /obj/item/organ/external/arm/tentacle/slim/lurker2),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/tentacle/slim/lurker3)
	)

	has_organ = list(    // which required-organ checks are conducted.
	BP_HEART =    /obj/item/organ/internal/heart/undead,
	BP_LUNGS =    /obj/item/organ/internal/lungs/undead,
	BP_BRAIN =    /obj/item/organ/internal/brain/undead/lurker,
	BP_EYES =     /obj/item/organ/internal/eyes/lurker
	)

	organ_substitutions = list(BP_L_LEG = BP_CHEST,
	BP_R_LEG = BP_CHEST,
	BP_L_FOOT = BP_CHEST,
	BP_R_FOOT = BP_CHEST)

	inherent_verbs = list(/mob/living/carbon/human/proc/retract_shell, /mob/living/proc/lurker_spinelaunch, /mob/proc/shout)
	modifier_verbs = list(KEY_ALT = list(/mob/living/proc/lurker_spinelaunch),
	KEY_CTRLALT = list(/mob/living/carbon/human/proc/toggle_shell))

	slowdown = 2.75

	//Lurker's "legs" are part of the body sprite
	locomotion_limbs = list(BP_CHEST)


	//HUD Handling. This is needed to allow shell to be equipped
	hud_type = /datum/hud_data/necromorph/lurker

	species_audio = list(SOUND_ATTACK = list('sound/effects/creatures/necromorph/lurker/lurker_attack_1.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_2.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_3.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_4.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_5.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_6.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_7.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_8.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_attack_9.ogg'),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/lurker/lurker_death_1.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_death_2.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_death_3.ogg'),
	SOUND_FOOTSTEP = list('sound/effects/footstep/lurker_footstep_1.ogg',
	'sound/effects/footstep/lurker_footstep_2.ogg',
	'sound/effects/footstep/lurker_footstep_3.ogg',
	'sound/effects/footstep/lurker_footstep_4.ogg',
	'sound/effects/footstep/lurker_footstep_5.ogg',
	'sound/effects/footstep/lurker_footstep_6.ogg',
	'sound/effects/footstep/lurker_footstep_7.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/lurker/lurker_pain_1.ogg',
	 'sound/effects/creatures/necromorph/lurker/lurker_pain_2.ogg',
	 'sound/effects/creatures/necromorph/lurker/lurker_pain_3.ogg',
	 'sound/effects/creatures/necromorph/lurker/lurker_pain_4.ogg',
	 'sound/effects/creatures/necromorph/lurker/lurker_pain_5.ogg',
	 'sound/effects/creatures/necromorph/lurker/lurker_pain_6.ogg',
	 'sound/effects/creatures/necromorph/lurker/lurker_pain_7.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/lurker/lurker_shout_1.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_2.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_3.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_4.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_5.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_6.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_7.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/lurker/lurker_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_shout_long_3.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/lurker/lurker_speech_1.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_speech_2.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_speech_3.ogg',
	'sound/effects/creatures/necromorph/lurker/lurker_speech_4.ogg')
	)


#define LURKER_SHELL_DESC	"<h2>Retractable Shell:</h2><br>\
<h3>Hotkey: Ctrl+Alt+Click </h3><br>\
The lurker is covered in a retractible armored shell that protects its fragile interior. Activating this ability will close or retract the shell, toggling between two modes:<br>\
	When the shell is close, the lurker is a fast, agile little creature. Almost incapable of dealing damage, but heavily armored and evasive too.<br>\
	<br>\
	When the shell is open, the internal tentacle weapons are exposed. The lurker becomes slow and fragile, but capable of powerful long-ranged attacks.<br>\
	Closing the shell is instant, but opening it takes a few seconds and leaves you briefly vulnerable to pre-emptive attack."


#define LURKER_SPINES_DESC "<h2>Spine Launch:</h2><br>\
<h3>Hotkey: Alt+Click</h3><br>\
<h3>Cooldown: [SPINE_COOLDOWN * 0.1] seconds</h3><br>\
<h3>Damage: 15x3</h3><br>\
The lurker rears back and launches a fan of up to three sharpened bony spines, one for each tentacle. Less spines will be fired if some tentacles have been lost.<br>\
Spines deal 15 ballistic brute damage each, and have a doubled chance to embed in their victim.<br>\
<br>\
The Lurker can only fire spines while its shell is open"


/datum/species/necromorph/lurker/get_ability_descriptions()
	.= ""
	. += LURKER_SHELL_DESC
	. += "<hr>"
	. += LURKER_SPINES_DESC


//Light claw attack, not its main means of damage
/datum/unarmed_attack/claws/lurker
	damage = 4


/*

	Lurker has three tentacles, and brain+eyes in its "chest"

*/
/obj/item/organ/external/arm/tentacle/slim/lurker1
	organ_tag = BP_L_ARM
	icon_name = "tentacle_1"
	retracted = TRUE

/obj/item/organ/external/arm/tentacle/slim/lurker2
	organ_tag = BP_HEAD
	icon_name = "tentacle_2"
	retracted = TRUE

/obj/item/organ/external/arm/tentacle/slim/lurker3
	organ_tag = BP_R_ARM
	icon_name = "tentacle_3"
	retracted = TRUE

/obj/item/organ/internal/brain/undead/lurker
	parent_organ = BP_CHEST

/obj/item/organ/internal/eyes/lurker
	parent_organ = BP_CHEST




/*
	Spine Launch
*/

//Shrapnel version. Doctors can pull this out of patients
/obj/item/weapon/arrow/spine
	name = "spine"
	desc = "A sharpened splinter of bone"
	icon = 'icons/mob/necromorph/lurker.dmi'
	icon_state = "spine"
	item_state = "spine"
	throwforce = 15

//Projectile version, higher chance of embedding
/obj/item/projectile/bullet/spine
	damage =	15
	armor_penetration = 5
	embed_mult = 2
	step_delay  = 1.6
	icon = 'icons/mob/necromorph/lurker.dmi'
	icon_state = "spine_projectile"
	muzzle_type = null
	tracer_type = null
	impact_type = null

	var/list/woosh_sounds  = list('sound/effects/creatures/necromorph/lurker/spine_woosh1.ogg',
	'sound/effects/creatures/necromorph/lurker/spine_woosh2.ogg',
	'sound/effects/creatures/necromorph/lurker/spine_woosh3.ogg')

	fire_sound  = list('sound/effects/creatures/necromorph/lurker/spine_fire_1.ogg',
	'sound/effects/creatures/necromorph/lurker/spine_fire_2.ogg',
	'sound/effects/creatures/necromorph/lurker/spine_fire_3.ogg')

//Spines make wooshy sounds as they fly
/obj/item/projectile/bullet/spine/Move(var/new_loc, var/new_dir)
	playsound(src, pick(woosh_sounds), VOLUME_QUIET, 1, -2)
	.=..()


//The lurker launches up to three spines - one for each remaining tentacle. The first one flies true, the others have significant random dispersion
/mob/living/proc/lurker_spinelaunch(var/atom/A)
	set name = "Spine launch"
	set category = "Abilities"
	set desc = "A three-shot spread of bone spines, with varying accuracy. HK: Altclick"


	//Autoaim at enemies within one tile of clickpoint
	if (!isliving(A))
		A = autotarget_enemy_mob(A, 1, src, 999)

	var/datum/extension/retractable_cover/lurker/RL = get_extension(src, /datum/extension/retractable_cover)
	if (!RL.open)
		to_chat(src, SPAN_WARNING("You must retract your shell before you can launch spines!"))
		return

	var/numspines = 0
	for (var/organ_tag in list(BP_HEAD, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/E = get_organ(organ_tag)
		if (istype(E) && !E.is_stump() && !E.retracted)
			numspines++

	if (!numspines)
		to_chat(src, SPAN_WARNING("You have no tentacles left to launch with!"))
		return

	face_atom(A)
	.= shoot_ability(/datum/extension/shoot/lurker, A , /obj/item/projectile/bullet/spine, accuracy = 120, dispersion = list(0,2,2.5), num = numspines, windup_time = SPINE_WINDUP, fire_sound  = list('sound/effects/creatures/necromorph/lurker/spine_fire_1.ogg',
	'sound/effects/creatures/necromorph/lurker/spine_fire_2.ogg',
	'sound/effects/creatures/necromorph/lurker/spine_fire_3.ogg'), nomove = 0, cooldown = SPINE_COOLDOWN)
	if (.)
		//If we're targeting a mob, we'll do a shout sound. But with a cooldown
		if (isliving(A) && check_audio_cooldown(SOUND_SHOUT))
			play_species_audio(src, SOUND_SHOUT, VOLUME_MID, 1, 3)
			set_audio_cooldown(SOUND_SHOUT, 10 SECONDS)
		else
			//Normal attack sound otherwise
			play_species_audio(src, SOUND_ATTACK, VOLUME_MID, 1, 3)


/datum/extension/shoot/lurker
	base_type = /datum/extension/shoot/lurker
	var/fire_time = 0.25 SECONDS
	var/vector2/cached_pixels
	var/x_direction

/datum/extension/shoot/lurker/windup_animation()
	var/windup_anim_time = windup_time - fire_time

	//Here we start the windup.
	cached_pixels = new /vector2(user.pixel_x, user.pixel_y)

	x_direction = 0
	//If the target is offset on our X axis, we'll have an extra factor on the animation
	if (target.x > user.x)
		x_direction = 1
	else if (target.x < user.x)
		x_direction = -1


	//We do the windup animation. This involves the user slowly rising into the air, and tilting back if striking horizontally
	animate(user, transform=turn(matrix(), 20*(x_direction*-1)),pixel_y = cached_pixels.y + 14, time = windup_anim_time, flags = ANIMATION_PARALLEL)


	sleep(windup_anim_time)

/datum/extension/shoot/lurker/fire_animation()
	//Slam back down to the ground quickly to fire
	animate(user, transform=turn(matrix(), 30*x_direction), pixel_y = cached_pixels.y-6, pixel_x = cached_pixels.x + 22*x_direction, time = fire_time, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(transform=matrix(), pixel_y = cached_pixels.y, pixel_x = cached_pixels.x, time = 5)	//Afterwards, reset to normal position
	sleep(fire_time)




/*--------------------------------------

	Retracting
	User calls these procs, they tell the extension to do stuff.
	The extension manages the limbs, shell-clothing-item, and updating icons
----------------------------------------*/
/mob/living/carbon/human/proc/toggle_shell()
	var/datum/extension/retractable_cover/lurker/RL = get_extension(src, /datum/extension/retractable_cover)
	if (RL.open)
		close_shell()
	else
		retract_shell()

/mob/living/carbon/human/proc/retract_shell()
	set name = "Retract Shell"
	set category = "Abilities"
	set desc = "Retracts your protective plating, exposing your offensive tentacle weapons."
	shake_animation(30)
	var/datum/extension/retractable_cover/lurker/RL = get_extension(src, /datum/extension/retractable_cover)
	RL.start_opening()

/mob/living/carbon/human/proc/close_shell()
	set name = "Close Shell"
	set category = "Abilities"
	set desc = "Closes your protective plating,protecting the tentacles."
	user.shake_animation(20)
	var/datum/extension/retractable_cover/lurker/RL = get_extension(src, /datum/extension/retractable_cover)
	RL.start_closing()


/*

	Lurker's retractible armor plating is implemented as a clothing item, in the back slot

*/
/obj/item/clothing/lurker_shell
	name = "retractible shell"
	siemens_coefficient = 0.9
	species_restricted = FALSE
	permeability_threshold = 0.8	//As long as health is above this proportion of max health, reagent permeability is unaffected. Below that value it increases rapidly
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 50, rad = 50)
	icon = 'icons/mob/necromorph/lurker.dmi'
	icon_state = "lurker_shell"
	item_state = "lurker_shell"
	slot_flags = SLOT_BACK
	sprite_sheets = list(
		SPECIES_NECROMORPH_LURKER = 'icons/mob/necromorph/lurker.dmi'
		)

/obj/item/clothing/lurker_shell/proc/close()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
	armor = initial(armor)
	update_wear_icon()

/obj/item/clothing/lurker_shell/proc/open()
	icon_state = ""
	item_state = ""
	armor = list()
	update_wear_icon()

/datum/species/necromorph/lurker/handle_post_spawn(var/mob/living/carbon/human/H)
	.=..()

	var/obj/item/clothing/lurker_shell/shell = new(H)
	H.equip_to_slot_or_del(shell, slot_back)

	set_extension(H, /datum/extension/retractable_cover/lurker, shell, list(BP_HEAD, BP_L_ARM, BP_R_ARM))



/*

	Extension to manage the retracting

*/
/datum/extension/retractable_cover/lurker
	var/speed_delta = 0
	close_time = 0.5 SECONDS


/datum/extension/retractable_cover/lurker/close()
	var/obj/item/clothing/lurker_shell/LS = cover
	LS.close()
	.=..()
	user.verbs -= /mob/living/carbon/human/proc/close_shell
	user.verbs |= /mob/living/carbon/human/proc/retract_shell
	user.view_range = VIEW_RANGE_CLOSED
	user.view_offset = VIEW_OFFSET_CLOSED
	user.reset_view()

	//Reset movespeed
	user.move_speed_factor += speed_delta
	speed_delta = 0
	user.slow_turning = FALSE

	user.play_species_audio(user, SOUND_PAIN, VOLUME_MID, 1)


/datum/extension/retractable_cover/lurker/open()
	var/obj/item/clothing/lurker_shell/LS = cover
	LS.open()
	.=..()
	user.verbs |= /mob/living/carbon/human/proc/close_shell
	user.verbs -= /mob/living/carbon/human/proc/retract_shell
	user.view_range = VIEW_RANGE_OPEN
	user.view_offset = VIEW_OFFSET_OPEN
	user.reset_view()

	//Lets set the speed
	var/newspeed = user.move_speed_factor * MOVESPEED_OPEN
	speed_delta = user.move_speed_factor - newspeed
	user.move_speed_factor = newspeed
	user.slow_turning = TRUE

	//Loudly announce our presence
	user.play_species_audio(user, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 3)
	user.shake_animation(30)
	user.Stun(1)	//We are briefly vulnerable after opening



/*----------------------
	Footstep
----------------------*/
//Because the lurker is a quadruped, it plays a second footstep sound - after a brief delay, whenever one plays
//Twice as many legs, twice as many footstep sounds
/datum/species/necromorph/lurker/play_species_audio(var/atom/source, audio_type, vol as num, vary, extrarange as num, falloff, var/is_global, var/frequency, var/is_ambiance = 0)
	.=..()
	if (audio_type == SOUND_FOOTSTEP)
		spawn(3)
			var/soundin = get_species_audio(audio_type)
			if (soundin)
				playsound(source, soundin, vol, vary, extrarange, falloff, is_global, frequency, is_ambiance)

#undef VIEW_RANGE_CLOSED
#undef VIEW_OFFSET_CLOSED
#undef VIEW_RANGE_OPEN
#undef VIEW_OFFSET_OPEN