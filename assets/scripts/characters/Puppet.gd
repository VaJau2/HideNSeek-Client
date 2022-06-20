extends Character

#-----
# Паппет другого игрока
#-----

const SYNC_WAIT_TIME = 1

var sync_wait_timer = SYNC_WAIT_TIME


func set_state(new_state):
	.set_state(new_state)
	var puppet_id = name.split("_")[1]
	G.network.rpc_id(1, "sync_state", puppet_id, new_state)


func sync_position(data):
	self.position = data.position
	set_flip_x(data.flip_x)


func sync_movement(data):
	self.dir = data.dir
	self.is_running = data.is_running
	set_flip_x(data.flip_x)
	sync_wait_timer = SYNC_WAIT_TIME


func _process(delta):
	#если игрок завис, через секунду его паппет встанет
	if sync_wait_timer > 0:
		sync_wait_timer -= delta
	elif dir.length() > 0:
		dir = Vector2(0, 0)
	
	update_velocity(delta)
