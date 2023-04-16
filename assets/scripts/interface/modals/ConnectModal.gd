extends ColorRect

@onready var network = get_node("/root/Main/Network")


func _ready():
	multiplayer.connected_to_server.connect(self.connected_ok)
	multiplayer.connection_failed.connect(self.connected_fail)
	
	if G.settings.has("server_port"):
		$block/port.text = G.settings.get_value("server_port")
	
	if G.settings.has("server_ip"):
		$block/ip.text = G.settings.get_value("server_ip")


func show_connect_modal():
	$block/name.text = "Подключиться к серверу"
	visible = true


func hide_connect_modal():
	network.disconnect_from_server()
	show_connecting_message(false)
	visible = false


func show_connecting_message(on = true):
	$block/name.visible = !on
	$block/ip.visible = !on
	$block/port.visible = !on
	$block/connect.visible = !on
	$block/process.visible = on


func _on_connect_pressed():
	var ip = $block/ip.text
	var port = $block/port.text
	if (ip.is_empty() || port.is_empty()):
		return
	
	show_connecting_message()
	G.settings.set_value("server_ip", ip)
	G.settings.set_value("server_port", port)
	network.connect_to_server(ip, port)


func connected_fail():
	show_connecting_message(false)
	$block/name.text = "Ошибка подключения"


func connected_ok():
	var levelsLoader = get_node("/root/Main")
	levelsLoader.change_menu("res://objects/interface/PauseMenu.tscn")
	levelsLoader.load_level("Level1")
