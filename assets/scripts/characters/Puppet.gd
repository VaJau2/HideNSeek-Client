extends Character

#-----
# Паппет другого игрока
#-----

const SYNC_WAIT_TIME = 1

var sync_wait_timer = SYNC_WAIT_TIME


func sync_position(data):
	self.position = data.position


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
	
	if waitTime > 0:
		velocity = Vector2(0, 0)
		waitTime -= delta
		return
	
	update_velocity(delta)
