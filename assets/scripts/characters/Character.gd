extends KinematicBody2D

#-----
# Базовый скрипт для игрока и неписей
#-----

class_name Character

const SEARCH_WAIT_TIME = 0.9

const NPC_ILDE_COLLISION = 2
const NPC_LOST_COLLISION = 4


const MATERIAL_ACCELS = {
	"snow": 1000,
	"ice": 400
}

const SEE_IDLE_INCREMENT   = 1.0
const SEE_HIDING_INCREMENT = 0.5

const SPEAK_NOT_ANIMATE_CHARS = ["*", "{", "[", "("]

enum states {none, wait, search, hide}
var state = states.none

var is_running = false
var is_hiding = false
var hiding_in_prop = false
var my_prop = null

#переменные для перемещения
onready var audi = get_node("audi")
onready var anim = get_node("anim")
onready var parts = get_node("sprites")
var velocity = Vector2()
var dir = Vector2()
var flipX = false
var speed = 120
var run_speed = 200
var acceleration = 800

onready var seekArea = get_node("seekArea")
onready var messageLabel = get_node("labelNode/message")
var messageTimer = 0
var messageCount = false


#для игрока и паппетов имеет разную реализацию
func set_state(new_state): 
	state = new_state
	if new_state == states.search:
		show_message("Я иду искать!")


func is_waiting() -> bool:
	return state == states.wait


func show_message(message):
	var messageTime = 2 + message.length() / 10
	messageLabel.text = message
	messageTimer = messageTime
	messageCount = true
	
	var animate = true
	for notAnimateChar in SPEAK_NOT_ANIMATE_CHARS:
		if message.begins_with(notAnimateChar): 
			animate = false
			break
	
	if animate: parts.animateMouth(messageTime)


func change_collision(layer: int) -> void:
	collision_layer = layer
	collision_mask = layer


func change_parent(new_parent) -> void:
	var pos = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = pos


func change_animation(newAnimation: String) -> void:
	anim.play(newAnimation)


func update_velocity(delta: float) -> void:
	var temp_speed = run_speed if (is_running) else speed
	if !is_hiding && (state != states.wait):
		velocity = velocity.move_toward(dir * temp_speed, acceleration * delta)
	else:
		velocity = Vector2(0, 0)
	
	var temp_anim = "idle"
	if velocity.length() > 0:
		temp_anim = "run" if (is_running) else "walk"
	
	if state == states.wait:
		temp_anim = "wait"
	
	change_animation(temp_anim)


func set_flip_x(flipOn: bool) -> void:
	if flipX == flipOn: return
	seekArea.position.x *= -1
	$sprites.scale.x = -1 if flipOn else 1
	flipX = flipOn


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
