extends KinematicBody2D

#-----
# Базовый скрипт для игрока и неписей
#-----

class_name Character

const SEARCH_WAIT_TIME = 0.9

const MATERIAL_ACCELS = {
	"snow": 1000,
	"ice": 400
}

const SPEAK_NOT_ANIMATE_CHARS = ["*", "{", "[", "("]

enum states {none, wait, search, hide}
var state = states.none

var gender = null
var is_running = false
var is_hiding = false
var is_typing_in_chat = false
var hiding_in_prop = false
var my_prop = null
var idle_onetime = false

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

var found_messages = {
	"female": "Нашла!",
	"male": "Нашел!",
}

#метод вызывается, когда с персонажем взаимодействует другой персонаж
func interact(character):
	if state == states.hide:
		var found_message = found_messages[character.gender]
		character.show_message(found_message)
		
		set_state(states.none)
		if is_hiding: set_hide(false, "idle")


#для игрока и паппетов имеет разную реализацию
func set_state(new_state, _sync_state = true): 
	state = new_state
	match new_state:
		states.wait:
			change_animation("wait")
		states.search:
			change_animation("idle")


func is_waiting() -> bool:
	return state == states.wait


func set_hide(hide_on: bool, animation: String) -> void:
	is_hiding = hide_on
	change_animation(animation)


func set_hide_in_prop(hide_on: bool) -> void:
	hiding_in_prop = hide_on


func set_typing_in_chat(on: bool) -> void:
	is_typing_in_chat = on


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


func change_collision(_on: bool) -> void:
	pass


func change_parent(new_parent) -> void:
	var pos = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = pos


func change_animation(new_animation: String) -> void:
	idle_onetime = new_animation != "run" && new_animation != "walk"
	anim.current_animation = new_animation


func update_velocity(delta: float) -> void:
	var temp_speed = run_speed if (is_running) else speed
	if !is_hiding && (state != states.wait):
		velocity = velocity.move_toward(dir * temp_speed, acceleration * delta)
	else:
		velocity = Vector2(0, 0)
	
	if velocity.length() > 0:
		var temp_anim = "run" if (is_running) else "walk"
		change_animation(temp_anim)
	else:
		if !idle_onetime: change_animation("idle")


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
	
	if !anim.is_playing():
		change_animation("idle")


func _physics_process(_delta):
	if (velocity.length() > 0):
		velocity = move_and_slide(velocity)
