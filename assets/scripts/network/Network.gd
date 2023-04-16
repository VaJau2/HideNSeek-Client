extends ClientNetwork


func server_disconnected():
	force_disconnect("Сервер внезапно выключился")


@rpc("any_peer") 
func force_disconnect(error) -> void:
	disconnect_from_server()
	get_parent().load_level("")
	get_parent().change_menu("res://objects/interface/MainMenu.tscn")
	if error: get_parent().current_error = error


@rpc("any_peer") 
func spawn_puppet(puppetData) -> void:
	if (puppetData.id == multiplayer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.spawn_puppet(puppetData)


@rpc("any_peer") 
func despawn_puppet(id) -> void:
	if (id == multiplayer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.despawn_puppet(id)


@rpc("any_peer", "unreliable") 
func sync_puppet_movement(player_id, dir, is_running, temp_timestamp) -> void:
	if (player_id == multiplayer.get_unique_id()): return
	if temp_timestamp > self.timestamp:
		self.timestamp = temp_timestamp
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_puppet_movement(player_id, dir, is_running)


@rpc("any_peer", "unreliable") 
func sync_puppet_position(player_id, position, temp_timestamp) -> void:
	if (player_id == multiplayer.get_unique_id()): return
	if temp_timestamp > self.timestamp:
		self.timestamp = temp_timestamp
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_puppet_position(player_id, position)


@rpc("any_peer") 
func say_message(player_id, message) -> void:
	if (player_id == multiplayer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.show_message(player_id, message)


@rpc("any_peer") 
func add_message_to_chat(player_name, message) -> void:
	var chat = get_node_or_null("/root/Main/canvas/PauseMenu/Chat")
	if (chat == null || player_name == null || message == null): return
	chat.add_message(player_name, message)


@rpc("any_peer") 
func update_chat_text(new_text) -> void:
	var chat = get_node_or_null("/root/Main/canvas/PauseMenu/Chat")
	if (chat == null || new_text == null): return
	chat.update_chat(new_text)


@rpc("any_peer") 
func sync_interact(player_id, object_path) -> void:
	if (player_id == multiplayer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.sync_interact(player_id, object_path)


@rpc("any_peer") 
func sync_state(player_id, new_state) -> void:
	if (player_id == multiplayer.get_unique_id()): 
		G.player.set_state(new_state, false)
	else:
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_state(player_id, new_state)


@rpc("any_peer") 
func sync_hiding(player_id, hiding_on, animation) -> void:
	if (player_id == multiplayer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.sync_hiding(player_id, hiding_on, animation)


@rpc("any_peer") 
func teleport(start_point_id) -> void:
	var startPoints = get_node("/root/Main/Scene/startPoints")
	startPoints.teleport_to_point(start_point_id)
	if G.bell: G.bell.change_may_interact(false)


@rpc("any_peer") 
func start_game(is_searcher) -> void:
	G.player.block_may_move = false
	G.player.set_may_move(true)
	if is_searcher:
		G.player.set_state(Character.states.wait)
	else:
		G.player.set_state(Character.states.hide)
		game_label.show_hide_message = true


@rpc("any_peer") 
func start_searching(hiders_names) -> void:
	if G.player.state == Character.states.wait:
		G.player.set_state(Character.states.search)
		if search_list: search_list.show_list(hiders_names)
	
	if G.player.state == Character.states.hide:
		game_label.show_hide_message = false


@rpc("any_peer") 
func player_found(found_id) -> void:
	if search_list: search_list.player_found(found_id)


@rpc("any_peer") 
func count_timer(time) -> void:
	if game_label: game_label.show_time(time)


@rpc("any_peer") 
func game_finished(searcher_name, hiders_names, is_error) -> void:
	G.player.block_may_move = false
	G.player.set_may_move(true)
	G.player.set_state(Character.states.none)
	game_label.show_game_results(searcher_name, hiders_names, is_error)
	if G.bell: G.bell.change_may_interact(true)
	if search_list: search_list.text = ""


#если игрок присоединился на середине игры
@rpc("any_peer") 
func make_bell_disabled() -> void:
	if G.bell: G.bell.change_may_interact(false)


#функции сервера (без них жодот не хочет их отправлять)
@rpc func add_player(_id, _player_name, _gender) -> void: pass
@rpc func add_message_to_chat_from_user(_user_name, _message) -> void: pass
@rpc func spawn_player_in_map(_player_id, _position, _flip_x, _partsData) -> void: pass
@rpc func get_puppets(_player_id) -> void: pass
@rpc func sync_player_movement(_dir, _is_running, _temp_timestamp) -> void: pass
@rpc func sync_player_position(_position, _temp_timestamp) -> void: pass
@rpc func save_hide_in_prop(_is_hiding, _prop_path) -> void: pass
