/// Updates the client side stored json file used to keep track of what assets the client has between restarts/reconnects.
/client/proc/asset_cache_update_json()
	if (world.time - connection_time < 10 SECONDS) //don't override the existing data file on a new connection
		return

	src << browse(json_encode(sent_assets), "file=asset_data.json&display=0")


/// Blocks until all currently sending browse and browse_rsc assets have been sent.
/// Due to byond limitations, this proc will sleep for 1 client round trip even if the client has no pending asset sends.
/// This proc will return an untrue value if it had to return before confirming the send, such as timeout or the client going away.
/client/proc/browse_queue_flush(timeout = 50)
	var/job = ++last_asset_job
	var/t = 0
	var/timeout_time = timeout
	src << browse({"<script>window.location.href="?asset_cache_confirm_arrival=[job]"</script>"}, "window=asset_cache_browser&file=asset_cache_send_verify.htm")

	while(!completed_asset_jobs["[job]"] && t < timeout_time) // Reception is handled in Topic()
		stoplag(1) // Lock up the caller until this is received.
		t++
	if (t < timeout_time)
		return TRUE
