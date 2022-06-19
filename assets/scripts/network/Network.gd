extends ClientNetwork

var timestamp = 0


func server_disconnected():
	force_disconnect("Сервер внезапно выключился")


remote func set_server_timestamp(timestamp):
	G.server_timestamp = timestamp


remote func force_disconnect(error = ""):
	disconnect_from_server()
	get_parent().load_level("")
	get_parent().change_menu("res://objects/interface/MainMenu.tscn")
	if error == "":
		error = "Вы были отключены от сервера"
	get_parent().current_error = error


remote func spawn_puppet(id, position, flipX, partsData):
	if (id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.spawn_puppet(id, position, flipX, partsData)


remote func despawn_puppet(id):
	if (id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.despawn_puppet(id)


remote func sync_puppet_movement(data):
	if (data.player_id == get_tree().network_peer.get_unique_id()): return
	if data.timestamp > self.timestamp:
		self.timestamp = data.timestamp
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_puppet_movement(data)


remote func sync_puppet_position(data):
	if (data.player_id == get_tree().network_peer.get_unique_id()): return
	if data.timestamp > self.timestamp:
		self.timestamp = data.timestamp
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_puppet_position(data)


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
		G.player.state = new_state
	else:
		var puppets_manager = get_node_or_null("/root/Main/Scene")
		if puppets_manager: puppets_manager.sync_state(player_id, new_state)
