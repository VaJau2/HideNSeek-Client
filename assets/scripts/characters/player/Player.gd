extends Character

const SYNC_POSITION_TIME = 0.5
const SYNC_MOVEMENT_TIME = 0.01

onready var black_screen = get_node("/root/Main/Scene/canvas/background")
onready var camera_block = get_node("/root/Main/Scene/cameraBlock")
onready var hiding_camera = camera_block.get_node("cameraBody/camera")
onready var main_camera = get_node("camera")
onready var interact_node = get_node("interact")
var may_move = true
var block_may_move = false
var sync_position_timer = SYNC_POSITION_TIME
var sync_movement_timer = SYNC_MOVEMENT_TIME
var sync_stop_onetime = false

var music = null


func set_may_move(may: bool):
	if block_may_move: return
	may_move = may


func check_see_body(body):
	interact_node.add_interact_object(body)


func lost_body(body):
	interact_node.remove_interact_object(body)


func set_state(new_state, sync_state = true):
	if state == new_state: return
	
	if sync_state:
		var player_id = get_tree().network_peer.get_unique_id()
		G.network.rpc_id(1, "sync_state", player_id, new_state)
	
	#если до этого ожидал с черным экраном
	if state == states.wait:
		while black_screen.setBackgroundOff():
			yield(get_tree(), "idle_frame")
	
	.set_state(new_state, sync_state)
	
	if new_state == states.search:
		show_message("Я иду искать!")
		seekArea.is_working = true
	else:
		seekArea.is_working = false
	
	if new_state == states.none:
		interact_node.clear_interact_objects()
	
	if music:
		if state == states.hide || state == states.search:
			music.play_action_music()
		if state == states.none:
			music.play_idle_music()


func set_hide(hide_on: bool, animation: String) -> void:
	.set_hide(hide_on, animation)
	
	var player_id = get_tree().network_peer.get_unique_id()
	G.network.rpc_id(1, "sync_hiding", hide_on, animation)
	
	may_move = !is_hiding
	if is_hiding:
		camera_block.global_position = main_camera.global_position
		hiding_camera.setCurrent()
		G.currentCamera = hiding_camera
	else:
		main_camera.global_position = camera_block.global_position
		main_camera.current = true
		hiding_camera.set_process(false)
		G.currentCamera = main_camera


func show_message(message):
	.show_message(message)
	var player_id = get_tree().network_peer.get_unique_id()
	G.network.rpc_id(1, "say_message", message)


func sync_movement():
	var is_stopped = velocity.length() == 0
	
	if is_stopped && sync_stop_onetime:
		return
	
	G.network.rpc_unreliable_id(1, "sync_player_movement", dir, is_running, OS.get_ticks_msec())
	sync_stop_onetime = is_stopped


func sync_position():
	G.network.rpc_unreliable_id(1, "sync_player_position", position, OS.get_ticks_msec())


func change_collision(on: bool) -> void:
	collision_layer = 1 if on else 0


func update_keys():
	if G.paused: return
	
	if state == states.hide:
		if Input.is_action_just_pressed("ui_hide"):
			var new_anim = "hide1" if !is_hiding else "idle" 
			set_hide(!is_hiding, new_anim)
	
	if may_move:
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
	gender = G.settings.get("gender")
	G.currentCamera = get_node("camera")
	
	var player_id = get_tree().network_peer.get_unique_id()
	G.network.rpc_id(1, "spawn_player_in_map", player_id, position, flipX, parts.get_data_to_server())
	
	music = get_node_or_null("/root/Main/Scene/music")


func _process(delta):
	dir = Vector2(0, 0)
	is_running = false
	
	if sync_position_timer > 0:
		sync_position_timer -= delta
	else:
		sync_position_timer = SYNC_POSITION_TIME
		sync_position()
	
	if is_waiting():
		black_screen.setBackgroundOn()
	
	update_keys()
	update_velocity(delta)
	
	if sync_movement_timer > 0:
		sync_movement_timer -= delta
	else:
		sync_movement_timer = SYNC_MOVEMENT_TIME
		sync_movement()
		
	._process(delta)
