extends Character

onready var cameraBlock = get_node("/root/Main/cameraBlock")
onready var hidingCamera = cameraBlock.get_node("cameraBody/camera")
onready var mainCamera = get_node("camera")
onready var interactArea = get_node("interactArea")
var mayMove = true


func updateKeys():
	if mayMove:
		if (Input.is_action_pressed("ui_shift")):
			is_running = true
		
		if (Input.is_action_pressed("ui_up")):
			dir.y = -1
		elif (Input.is_action_pressed("ui_down")):
			dir.y = 1
		
		if (Input.is_action_pressed("ui_left")):
			dir.x = -1
			setFlipX(true)
		elif (Input.is_action_pressed("ui_right")):
			dir.x = 1
			setFlipX(false)


func _ready():
	G.player = self
	G.currentCamera = mainCamera


func _process(delta):
	dir = Vector2(0, 0)
	is_running = false
	
	if waitTime > 0:
		velocity = Vector2(0, 0)
		waitTime -= delta
		return
	
	updateKeys()
	updateVelocity(delta)

