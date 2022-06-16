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


remote func spawn_puppet(id, position):
	if (id == get_tree().network_peer.get_unique_id()): return
	var puppets_manager = get_node_or_null("/root/Main/Scene")
	if puppets_manager: puppets_manager.spawn_puppet(id, position)


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


remote func add_message_to_chat(name, message):
	pass


remote func update_chat_text(new_text):
	pass
