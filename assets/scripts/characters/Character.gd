extends KinematicBody2D

#-----
# Базовый скрипт для игрока и неписей
#-----

class_name Character

export var is_player = false

#переменные состояния
const SEARCH_WAIT_TIME = 0.9

const NPC_ILDE_COLLISION = 2
const NPC_LOST_COLLISION = 4


enum waitStates {none, waiting, searching, hiding}
var waitState = waitStates.none
var waitTime = 0

var is_running = false
var is_hiding = false
var hiding_in_prop = false
var myProp = null

#переменные для перемещения
onready var audi = get_node("audi")
onready var anim = get_node("anim")
var velocity = Vector2()
var dir = Vector2()
var speed = 120
var run_speed = 200
var acceleration = 800

onready var seekArea = get_node("seekArea")
onready var messageLabel = get_node("labelNode/message")
var messageTimer = 0
var messageCount = false

const MATERIAL_ACCELS = {
	"snow": 1000,
	"ice": 400
}

const SEE_IDLE_INCREMENT   = 1.0
const SEE_HIDING_INCREMENT = 0.5


func changeCollision(layer: int) -> void:
	collision_layer = layer
	collision_mask = layer


func changeParent(new_parent) -> void:
	var pos = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = pos



func changeAnimation(newAnimation: String) -> void:
	anim.play(newAnimation)



func updateVelocity(delta: float) -> void:
	var temp_speed = run_speed if (is_running) else speed
	var temp_anim = "idle"
	if dir.length() > 0:
		temp_anim = "run" if (is_running) else "walk"
	
	if !is_hiding && (waitState == waitStates.none):
		velocity = velocity.move_toward(dir * temp_speed, acceleration * delta)
		changeAnimation(temp_anim)
	else:
		velocity = Vector2(0, 0)


func setFlipX(flipOn: bool) -> void:
	if $sprites.scale.x > 0 && !flipOn:
		seekArea.position.x *= -1
	$sprites.scale.x = -1 if flipOn else 1


func _process(delta):
	if messageCount:
		if messageTimer > 0:
			messageTimer -= delta
		else:
			messageCount = false
			messageLabel.text = ""


func _physics_process(_delta):
	if (velocity.length() > 0):
		velocity = move_and_slide(velocity)
