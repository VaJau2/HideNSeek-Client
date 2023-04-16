extends Node

class_name ClientNetwork

var peer = null
var timestamp = 0
var game_label = null
var search_list = null


func _ready() -> void:
	multiplayer.connected_to_server.connect(self.connected_ok)
	multiplayer.connection_failed.connect(self.connected_fail)
	multiplayer.server_disconnected.connect(self.server_disconnected)
	G.network = self


func disconnect_from_server() -> void:
	if (G.network.peer):
		G.network.peer.close()
		multiplayer.multiplayer_peer = null


func connect_to_server(ip, port) -> void:
	port = int(port)
	if (ip.is_empty() || port <= 0):
		return
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer


func connected_ok() -> void:
	var player_id = peer.get_unique_id()
	var player_name = G.settings.get_value("player_name")
	var character_gender = G.settings.get_value("gender")
	rpc_id(1, "add_player", player_id, player_name, character_gender)


func connected_fail() -> void:
	disconnect_from_server()


func server_disconnected() -> void:
	disconnect_from_server()
