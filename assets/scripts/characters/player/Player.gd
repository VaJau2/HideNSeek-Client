extends Character

const SYNC_POSITION_TIME = 1

onready var cameraBlock = get_node("/root/Main/Scene/cameraBlock")
onready var hidingCamera = cameraBlock.get_node("cameraBody/camera")
onready var mainCamera = get_node("camera")
onready var interact = get_node("interact")
var mayMove = true
var sync_position_timer = SYNC_POSITION_TIME
var sync_stop_onetime = false


func change_state(new_state):
	.change_state(new_state)
	var player_id = get_tree().network_peer.get_unique_id()
	rpc_id(1, "sync_state", player_id, new_state)


func show_message(message):
	.show_message(message)
	var player_id = get_tree().network_peer.get_unique_id()
	G.network.rpc_id(1, "say_message", player_id, message)


func sync_movement():
	var is_stopped = velocity.length() == 0
	
	if is_stopped && sync_stop_onetime:
		return
	
	var data = {
		"player_id": get_tree().network_peer.get_unique_id(),
		"dir": dir,
		"flip_x": flipX,
		"is_running": is_running,
		"timestamp": OS.get_ticks_msec()
	}
	G.network.rpc_unreliable_id(1, "sync_player_movement", data)
	sync_stop_onetime = is_stopped


func sync_position():
	var data = {
		"player_id": get_tree().network_peer.get_unique_id(),
		"position": position,
		"timestamp": OS.get_ticks_msec()
	}
	
	G.network.rpc_unreliable_id(1, "sync_player_position", data)


func update_keys():
	if mayMove:
		if (Input.is_action_pressed("ui_shift")):
			is_running = true
		
		if (Input.is_action_pressed("ui_up")):
			dir.y = -1
		elif (Input.is_action_pressed("ui_down")):
			dir.y = 1
		
		if (Input.is_action_pressed("ui_left")):
			dir.x = -1
			set_flip_x(true)
		elif (Input.is_action_pressed("ui_right")):
			dir.x = 1
			set_flip_x(false)


func _ready():
	parts.load_from_settings()
	G.player = self
	G.currentCamera = mainCamera
	
	var player_id = get_tree().network_peer.get_unique_id()
	G.network.rpc_id(1, "spawn_player_in_map", player_id, position, flipX, parts.get_data_to_server())


func _process(delta):
	dir = Vector2(0, 0)
	is_running = false
	
	if waitTime > 0:
		velocity = Vector2(0, 0)
		waitTime -= delta
		return
	
	if sync_position_timer > 0:
		sync_position_timer -= delta
	else:
		sync_position_timer = SYNC_POSITION_TIME
		sync_position()
	
	update_keys()
	update_velocity(delta)
	sync_movement()

