#define NEST_RESIST_TIME 1200

/obj/structure/bed/nest/arachna_nest
	name = "arachna nest"
	desc = "It's a gruesome pile of thick, sticky web shaped like a nest."
	icon = 'code/modules/mob/living/carbon/arachna/arachna_stuff.dmi'
	icon_state = "nest"

/obj/structure/bed/nest/arachna_nest/user_unbuckle_mob(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"<span class='notice'>[user.name] pulls [buckled_mob.name] free from the sticky nest!</span>",\
					"<span class='notice'>[user.name] pulls you free from the gelatinous web.</span>",\
					"<span class='notice'>You hear squelching...</span>")
				buckled_mob.pixel_y = 0
				buckled_mob.old_y = 0
				unbuckle_mob()
			else
				if(world.time <= buckled_mob.last_special+NEST_RESIST_TIME)
					return
				buckled_mob.last_special = world.time
				buckled_mob.visible_message(\
					"<span class='warning'>[buckled_mob.name] struggles to break free of the sticky web...</span>",\
					"<span class='warning'>You struggle to break free from the sticky web...</span>",\
					"<span class='notice'>You hear squelching...</span>")
				spawn(NEST_RESIST_TIME)
					if(user && buckled_mob && user.buckled == src)
						buckled_mob.last_special = world.time
						buckled_mob.pixel_y = 0
						buckled_mob.old_y = 0
						unbuckle_mob()
			src.add_fingerprint(user)
	return

/obj/structure/bed/nest/arachna_nest/user_buckle_mob(mob/M as mob, mob/user as mob)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || usr.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	unbuckle_mob()

	var/mob/living/carbon/arachna = user
	var/mob/living/carbon/victim = M

	if(istype(victim) && locate(/obj/item/organ/arachna/silk_gland) in victim.internal_organs)
		return

	if(istype(arachna) && !(locate(/obj/item/organ/arachna/silk_gland) in arachna.internal_organs))
		return

	if(M == usr)
		return
	else
		M.visible_message(\
			"<span class='notice'>[user.name] secretes a thick vile web, securing [M.name] into [src]!</span>",\
			"<span class='warning'>[user.name] drenches you in a foul-smelling web, trapping you in the [src]!</span>",\
			"<span class='notice'>You hear squelching...</span>")
	M.buckled = src
	M.loc = src.loc
	M.set_dir(src.dir)
	M.update_canmove()
	M.pixel_y = 6
	M.old_y = 6
	src.buckled_mob = M
	src.add_fingerprint(user)
	return