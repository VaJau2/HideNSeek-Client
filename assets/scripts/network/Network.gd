extends ClientNetwork


func server_disconnected():
	force_disconnect("Сервер внезапно выключился")


remote func force_disconnect(error):
	disconnect_from_server()
	get_parent().load_level("")
	get_parent().change_menu("res://objects/interface/MainMenu.tscn")
	if error: get_parent().current_error = error


remote func spawn_puppet(puppetData):
	if (puppetData.id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.spawn_puppet(puppetData)


remote func despawn_puppet(id):
	if (id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.despawn_puppet(id)


remote func sync_puppet_movement(player_id, dir, is_running, timestamp):
	if (player_id == get_tree().network_peer.get_unique_id()): return
	if timestamp > self.timestamp:
		self.timestamp = timestamp
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_puppet_movement(player_id, dir, is_running)


remote func sync_puppet_position(player_id, position, timestamp):
	if (player_id == get_tree().network_peer.get_unique_id()): return
	if timestamp > self.timestamp:
		self.timestamp = timestamp
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_puppet_position(player_id, position)


remote func say_message(player_id, message):
	if (player_id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.show_message(player_id, message)


remote func add_message_to_chat(name, message):
	var chat = get_node_or_null("/root/Main/canvas/PauseMenu/Chat")
	if (chat == null || name == null || message == null): return
	chat.add_message(name, message)


remote func update_chat_text(new_text):
	var chat = get_node_or_null("/root/Main/canvas/PauseMenu/Chat")
	if (chat == null || new_text == null): return
	chat.update_chat(new_text)


remote func sync_interact(player_id, object_path):
	if (player_id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.sync_interact(player_id, object_path)


remote func sync_state(player_id, new_state):
	if (player_id == get_tree().network_peer.get_unique_id()): 
		G.player.set_state(new_state, false)
	else:
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_state(player_id, new_state)


remote func sync_hiding(player_id, hiding_on, animation):
	if (player_id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.sync_hiding(player_id, hiding_on, animation)


remote func teleport(start_point_id):
	var startPoints = get_node("/root/Main/Scene/startPoints")
	startPoints.teleport_to_point(start_point_id)
	if G.bell: G.bell.change_may_interact(false)


remote func start_game(is_searcher):
	G.player.block_may_move = false
	G.player.set_may_move(true)
	if is_searcher:
		G.player.set_state(Character.states.wait)
	else:
		G.player.set_state(Character.states.hide)
		game_label.show_hide_message = true


remote func start_searching(hiders_names):
	if G.player.state == Character.states.wait:
		G.player.set_state(Character.states.search)
		if search_list: search_list.show_list(hiders_names)
	
	if G.player.state == Character.states.hide:
		game_label.show_hide_message = false


remote func player_found(found_id):
	if search_list: search_list.player_found(found_id)


remote func count_timer(time):
	if game_label: game_label.show_time(time)


remote func game_finished(searcher_name, hiders_names, is_error):
	G.player.block_may_move = false
	G.player.set_may_move(true)
	G.player.set_state(Character.states.none)
	game_label.show_game_results(searcher_name, hiders_names, is_error)
	if G.bell: G.bell.change_may_interact(true)
	if search_list: search_list.text = ""


#если игрок присоединился на середине игры
remote func make_bell_disabled():
	if G.bell: G.bell.change_may_interact(false)
