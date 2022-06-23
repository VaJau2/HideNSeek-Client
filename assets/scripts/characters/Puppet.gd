extends Character

#-----
# Паппет другого игрока
#-----

const SYNC_WAIT_TIME = 1

var puppets_manager = null
var sync_wait_timer = SYNC_WAIT_TIME


func get_id(): return int(name.split("_")[1])


func set_hide_in_prop(hide_on) -> void:
	if hide_on:
		puppets_manager.hidden_puppets[get_id()] = self
	else:
		puppets_manager.hidden_puppets.erase(get_id())


func change_collision(on: bool) -> void:
	collision_layer = 1 if on else 0
	collision_mask = 2 if on else 0


func set_state(new_state, sync_state = true):
	if state == new_state: return
	
	.set_state(new_state, sync_state)
	if sync_state:
		G.network.rpc_id(1, "sync_state", get_id(), new_state)


func sync_position(position):
	self.position = position


func sync_movement(dir, is_running):
	self.dir = dir
	self.is_running = is_running
	if dir.x != 0: set_flip_x(dir.x < 0)
	sync_wait_timer = SYNC_WAIT_TIME


func _ready():
	puppets_manager = get_node("/root/Main/Scene")


func _process(delta):
	#если игрок завис, через секунду его паппет встанет
	if sync_wait_timer > 0:
		sync_wait_timer -= delta
	elif dir.length() > 0:
		dir = Vector2(0, 0)
	
	update_velocity(delta)
	._process(delta)
