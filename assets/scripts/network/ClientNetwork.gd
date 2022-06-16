extends Node

class_name ClientNetwork


func _ready():
	get_tree().connect("connected_to_server", self, "connected_ok")
	get_tree().connect("connection_failed", self, "connected_fail")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	G.network = self


func disconnect_from_server():
	if (get_tree().network_peer):
		get_tree().network_peer.close_connection()


func connect_to_server(ip, port):
	port = int(port)
	if (ip.empty() || port <= 0):
		return
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().network_peer = peer


func connected_ok():
	var player_id = get_tree().network_peer.get_unique_id()
	var player_name = G.settings.get("player_name")
	rpc("add_player", player_id, player_name)


func connected_fail():
	disconnect_from_server()


func server_disconnected():
	disconnect_from_server()
