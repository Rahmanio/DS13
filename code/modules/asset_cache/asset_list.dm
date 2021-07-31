/*
Asset cache quick users guide:

Make a datum at the bottom of this file with your assets for your thing.
The simple subsystem will most like be of use for most cases.
Then call get_asset_datum() with the type of the datum you created and store the return
Then call .send(client) on that stored return value.

You can set verify to TRUE if you want send() to sleep until the client has the assets.
*/


// Amount of time(ds) MAX to send per asset, if this get exceeded we cancel the sleeping.
// This is doubled for the first asset, then added per asset after
#define ASSET_CACHE_SEND_TIMEOUT 7

//When sending mutiple assets, how many before we give the client a quaint little sending resources message
#define ASSET_CACHE_TELL_CLIENT_AMOUNT 8

/client
	var/list/cache = list() // List of all assets sent to this client by the asset cache.
	var/list/completed_asset_jobs = list() // List of all completed jobs, awaiting acknowledgement.
	var/list/sending = list()
	var/last_asset_job = 0 // Last job done.

//This proc sends the asset to the client, but only if it needs it.
//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset(var/client/client, var/asset_name, var/verify = TRUE, var/check_cache = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	if(check_cache && (client.cache.Find(asset_name) || client.sending.Find(asset_name)))
		return 0

	client << browse_rsc(asset_cache.cache[asset_name], asset_name)
	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if (client)
			client.cache += asset_name
		return 1
	if (!client)
		return 0

	client.sending |= asset_name
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = (ASSET_CACHE_SEND_TIMEOUT * client.sending.len) + ASSET_CACHE_SEND_TIMEOUT
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= asset_name
		client.cache |= asset_name
		client.completed_asset_jobs -= job

	return 1

//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset_list(var/client/client, var/list/asset_list, var/verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	var/list/unreceived = asset_list - (client.cache + client.sending)
	if(!unreceived || !unreceived.len)
		return 0
	if (unreceived.len >= ASSET_CACHE_TELL_CLIENT_AMOUNT)
		to_chat(client, "Sending Resources...")
	for(var/asset in unreceived)
		if (asset in asset_cache.cache)
			client << browse_rsc(asset_cache.cache[asset], asset)

	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if (client)
			client.cache += unreceived
		return 1
	if (!client)
		return 0
	client.sending |= unreceived
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = ASSET_CACHE_SEND_TIMEOUT * client.sending.len
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++


	if(client)
		client.sending -= unreceived
		client.cache |= unreceived
		client.completed_asset_jobs -= job

	return 1

//This proc will download the files without clogging up the browse() queue, used for passively sending files on connection start.
//The proc calls procs that sleep for long times.
/proc/getFilesSlow(var/client/client, var/list/files, var/register_asset = TRUE)
	for(var/file in files)
		if (!client)
			break
		if (register_asset)
			register_asset(file,files[file])
		send_asset(client,file)
		sleep(0) //queuing calls like this too quickly can cause issues in some client versions

//This proc "registers" an asset, it adds it to the cache for further use, you cannot touch it from this point on or you'll fuck things up.
//if it's an icon or something be careful, you'll have to copy it before further use.
/proc/register_asset(var/asset_name, var/asset)
	asset_cache.cache[asset_name] = asset


// will return filename for cached atom icon or null if not cached
// can accept atom objects or types
/proc/getAtomCacheFilename(var/atom/A)
	if(!A || (!istype(A) && !ispath(A)))
		return
	var/filename = "[ispath(A) ? A : A.type].png"
	filename = sanitizeFileName(filename)
	if(asset_cache.cache[filename])
		return filename











//These datums are used to populate the asset cache, the proc "register()" does this.

//all of our asset datums, used for referring to these later
GLOBAL_LIST_EMPTY(asset_datums)

/datum/asset
	var/_abstract = /datum/asset


//get a assetdatum or make a new one
/proc/get_asset_datum(type)
	return GLOB.asset_datums[type] || new type()

/datum/asset/New()
	GLOB.asset_datums[type] = src
	register()

/datum/asset/proc/get_url_mappings()
	return list()

/datum/asset/proc/register()
	return

/datum/asset/proc/send(client)
	return

/// If you don't need anything complicated.
/datum/asset/simple
	_abstract = /datum/asset/simple
	/// list of assets for this datum in the form of:
	/// asset_filename = asset_file. At runtime the asset_file will be
	/// converted into a asset_cache datum.
	var/assets = list()
	/// Set to true to have this asset also be sent via the legacy browse_rsc
	/// system when cdn transports are enabled?
	var/legacy = FALSE
	/// TRUE for keeping local asset names when browse_rsc backend is used
	var/keep_local_name = FALSE

/datum/asset/simple/register()
	for(var/asset_name in assets)
		var/datum/asset_cache_item/ACI = SSassets.transport.register_asset(asset_name, assets[asset_name])
		if (!ACI)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		if (legacy)
			ACI.legacy = legacy
		if (keep_local_name)
			ACI.keep_local_name = keep_local_name
		assets[asset_name] = ACI

/datum/asset/simple/send(client)
	. = SSassets.transport.send_assets(client, assets)

/datum/asset/simple/get_url_mappings()
	. = list()
	for (var/asset_name in assets)
		.[asset_name] = SSassets.transport.get_asset_url(asset_name, assets[asset_name])

/*
	Asset cache
*/
var/decl/asset_cache/asset_cache = new()

/decl/asset_cache
	var/list/cache

/decl/asset_cache/New()
	..()
	cache = new



/*
/hook/roundstart/proc/send_assets()
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()
		A.register()

	for(var/client/C in GLOB.clients)
		// Doing this to a client too soon after they've connected can cause issues, also the proc we call sleeps.
		spawn(10)
			getFilesSlow(C, asset_cache.cache, FALSE)

	return TRUE
*/

//DEFINITIONS FOR ASSET DATUMS START HERE.
/datum/asset/simple/craft/register()
	for(var/name in SScraft.categories)
		for(var/datum/craft_recipe/CR in SScraft.categories[name])
			if(CR.result)
				var/filename = sanitizeFileName("[CR.result].png")
				var/icon/I = getFlatTypeIcon(CR.result)
				register_asset(filename, I)
				assets[filename] = I

			var/list/steplist = CR.steps + CR.passive_steps

			for(var/datum/craft_step/CS in steplist)
				if(CS.icon_type)
					var/filename = sanitizeFileName("[CS.icon_type].png")
					var/icon/I = getFlatTypeIcon(CS.icon_type)
					register_asset(filename, I)
					assets[filename] = I



/datum/asset/simple/research_designs/register()
	for(var/R in subtypesof(/datum/design))
		var/datum/design/design = new R

		design.AssembleDesignInfo()

		if(!design.build_path)
			continue

		//Cache the icons
		var/filename = sanitizeFileName("[design.build_path].png")
		var/icon/I = getFlatTypeIcon(design.build_path)
		register_asset(filename, I)
		assets[filename] = I

		design.ui_data["icon"] = filename
		design.ui_data["icon_width"] = I.Width()
		design.ui_data["icon_height"] = I.Height()

		SSresearch.all_designs += design

		// Design ID is string
		SSresearch.design_ids["[design.id]"] = design

	SSresearch.generate_integrated_circuit_designs()

	for(var/D in SSresearch.design_ids)
		var/datum/design/design = SSresearch.design_ids[D]
		var/datum/computer_file/binary/design/design_file = new
		design_file.design = design
		design_file.on_design_set()
		design.file = design_file

	SSresearch.designs_initialized = TRUE

	// Initialize design files that were created before
	for(var/file in SSresearch.design_files_to_init)
		SSresearch.initialize_design_file(file)
	SSresearch.design_files_to_init = list()

	SSdatabase.update_store_designs()

// spritesheet implementation - coalesces various icons into a single .png file
// and uses CSS to select icons out of that file - saves on transferring some
// 1400-odd individual PNG files
#define SPR_SIZE 1
#define SPR_IDX 2
#define SPRSZ_COUNT 1
#define SPRSZ_ICON 2
#define SPRSZ_STRIPPED 3

/datum/asset/spritesheet
	_abstract = /datum/asset/spritesheet
	var/name
	var/list/sizes = list()    // "32x32" -> list(10, icon/normal, icon/stripped)
	var/list/sprites = list()  // "foo_bar" -> list("32x32", 5)

/datum/asset/spritesheet/register()
	if (!name)
		CRASH("spritesheet [type] cannot register without a name")
	ensure_stripped()
	for(var/size_id in sizes)
		var/size = sizes[size_id]
		SSassets.transport.register_asset("[name]_[size_id].png", size[SPRSZ_STRIPPED])
	var/res_name = "spritesheet_[name].css"
	var/fname = "data/spritesheets/[res_name]"
	fdel(fname)
	text2file(generate_css(), fname)
	SSassets.transport.register_asset(res_name, fcopy_rsc(fname))
	fdel(fname)

/datum/asset/spritesheet/send(client/C)
	if (!name)
		return
	var/all = list("spritesheet_[name].css")
	for(var/size_id in sizes)
		all += "[name]_[size_id].png"
	. = SSassets.transport.send_assets(C, all)

/datum/asset/spritesheet/get_url_mappings()
	if (!name)
		return
	. = list("spritesheet_[name].css" = SSassets.transport.get_asset_url("spritesheet_[name].css"))
	for(var/size_id in sizes)
		.["[name]_[size_id].png"] = SSassets.transport.get_asset_url("[name]_[size_id].png")



/datum/asset/spritesheet/proc/ensure_stripped(sizes_to_strip = sizes)
	for(var/size_id in sizes_to_strip)
		var/size = sizes[size_id]
		if (size[SPRSZ_STRIPPED])
			continue

		// save flattened version
		var/fname = "data/spritesheets/[name]_[size_id].png"
		fcopy(size[SPRSZ_ICON], fname)
		var/error = rustg_dmi_strip_metadata(fname)
		if(length(error))
			crash_with("Failed to strip [name]_[size_id].png: [error]")
		size[SPRSZ_STRIPPED] = icon(fname)
		fdel(fname)

/datum/asset/spritesheet/proc/generate_css()
	var/list/out = list()

	for (var/size_id in sizes)
		var/size = sizes[size_id]
		var/icon/tiny = size[SPRSZ_ICON]
		out += ".[name][size_id]{display:inline-block;width:[tiny.Width()]px;height:[tiny.Height()]px;background:url('[SSassets.transport.get_asset_url("[name]_[size_id].png")]') no-repeat;}"

	for (var/sprite_id in sprites)
		var/sprite = sprites[sprite_id]
		var/size_id = sprite[SPR_SIZE]
		var/idx = sprite[SPR_IDX]
		var/size = sizes[size_id]

		var/icon/tiny = size[SPRSZ_ICON]
		var/icon/big = size[SPRSZ_STRIPPED]
		var/per_line = big.Width() / tiny.Width()
		var/x = (idx % per_line) * tiny.Width()
		var/y = round(idx / per_line) * tiny.Height()

		out += ".[name][size_id].[sprite_id]{background-position:-[x]px -[y]px;}"

	return out.Join("\n")

/datum/asset/spritesheet/proc/Insert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE)
	I = icon(I, icon_state=icon_state, dir=dir, frame=frame, moving=moving)
	if (!I || !length(icon_states(I)))  // that direction or state doesn't exist
		return
	var/size_id = "[I.Width()]x[I.Height()]"
	var/size = sizes[size_id]

	if (sprites[sprite_name])
		CRASH("duplicate sprite \"[sprite_name]\" in sheet [name] ([type])")

	if (size)
		var/position = size[SPRSZ_COUNT]++
		var/icon/sheet = size[SPRSZ_ICON]
		size[SPRSZ_STRIPPED] = null
		sheet.Insert(I, icon_state=sprite_name)
		sprites[sprite_name] = list(size_id, position)
	else
		sizes[size_id] = size = list(1, I, null)
		sprites[sprite_name] = list(size_id, 0)

/datum/asset/spritesheet/proc/InsertAll(prefix, icon/I, list/directions)
	if (length(prefix))
		prefix = "[prefix]-"

	if (!directions)
		directions = list(SOUTH)

	for (var/icon_state_name in icon_states(I))
		for (var/direction in directions)
			var/prefix2 = (directions.len > 1) ? "[dir2text(direction)]-" : ""
			Insert("[prefix][prefix2][icon_state_name]", I, icon_state=icon_state_name, dir=direction)

/datum/asset/spritesheet/proc/css_tag()
	return {"<link rel="stylesheet" href="[css_filename()]" />"}

/datum/asset/spritesheet/proc/css_filename()
	return SSassets.transport.get_asset_url("spritesheet_[name].css")

/datum/asset/spritesheet/proc/icon_tag(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return {"<span class="[name][size_id] [sprite_name]"></span>"}

/datum/asset/spritesheet/proc/icon_class_name(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return {"[name][size_id] [sprite_name]"}

#undef SPR_SIZE
#undef SPR_IDX
#undef SPRSZ_COUNT
#undef SPRSZ_ICON
#undef SPRSZ_STRIPPED

/// Namespace'ed assets (for static css and html files)
/// When sent over a cdn transport, all assets in the same asset datum will exist in the same folder, as their plain names.
/// Used to ensure css files can reference files by url() without having to generate the css at runtime, both the css file and the files it depends on must exist in the same namespace asset datum. (Also works for html)
/// For example `blah.css` with asset `blah.png` will get loaded as `namespaces/a3d..14f/f12..d3c.css` and `namespaces/a3d..14f/blah.png`. allowing the css file to load `blah.png` by a relative url rather then compute the generated url with get_url_mappings().
/// The namespace folder's name will change if any of the assets change. (excluding parent assets)
/datum/asset/simple/namespaced
	_abstract = /datum/asset/simple/namespaced
	/// parents - list of the parent asset or assets (in name = file assoicated format) for this namespace.
	/// parent assets must be referenced by their generated url, but if an update changes a parent asset, it won't change the namespace's identity.
	var/list/parents = list()

/datum/asset/simple/namespaced/register()
	if (legacy)
		assets |= parents
	var/list/hashlist = list()
	var/list/sorted_assets = sortList(assets)

	for (var/asset_name in sorted_assets)
		var/datum/asset_cache_item/ACI = new(asset_name, sorted_assets[asset_name])
		if (!ACI?.hash)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		hashlist += ACI.hash
		sorted_assets[asset_name] = ACI
	var/namespace = md5(hashlist.Join())

	for (var/asset_name in parents)
		var/datum/asset_cache_item/ACI = new(asset_name, parents[asset_name])
		if (!ACI?.hash)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		ACI.namespace_parent = TRUE
		sorted_assets[asset_name] = ACI

	for (var/asset_name in sorted_assets)
		var/datum/asset_cache_item/ACI = sorted_assets[asset_name]
		if (!ACI?.hash)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		ACI.namespace = namespace

	assets = sorted_assets
	..()

/// Get a html string that will load a html asset.
/// Needed because byond doesn't allow you to browse() to a url.
/datum/asset/simple/namespaced/proc/get_htmlloader(filename)
	return url2htmlloader(SSassets.transport.get_asset_url(filename, assets[filename]))
