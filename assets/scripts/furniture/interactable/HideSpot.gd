extends Interactable

const OPEN_TIMER = 0.5

var my_character = null

export var open_sprite: Resource
export var hide_animation = "hide1"
export var free_camera_scale = 1

onready var sprite = get_node("Sprite")
onready var hide_place = get_node("hidePlace")
onready var npc_manager = get_node("/root/Main/Scene/npc")
var oldPlace = Vector2()
var close_sprite


func _ready():
	close_sprite = sprite.texture


func _on_Area2D_body_entered(body):
	if body is Character:
		if body.state == Character.states.hide || body.state == Character.states.search:
			._on_Area2D_body_entered(body)


func _on_Area2D_body_exited(body):
	if body is Character:
		if body.state == Character.states.hide || body.state == Character.states.search:
			._on_Area2D_body_exited(body)


func search(searchingChar) -> void:
	searchingChar.change_animation("boop")
	sprite.texture = open_sprite
	
	if my_character:
		interact(my_character)
	
	may_interact = false
	yield(get_tree().create_timer(OPEN_TIMER), "timeout")
	may_interact = true
	sprite.texture = close_sprite


func interact(character):
	if !may_interact: return 
	
	if character.state == Character.states.search:
		search(character)
		return
	
	if character.state != Character.states.hide: return
	
	var hide_character = !character.is_hiding
	
	#если в пропе кто-то уже прячется
	if hide_character && my_character != null:
		return
	
	if character == G.player:
		G.player.interact_node.hideLabels = hide_character
	character.set_hide_in_prop(hide_character)
	
	if hide_character: #если персонаж собирается спрятаться
		if character == G.player:
			character.camera_block.global_position = global_position
			character.hiding_camera.setCurrent(free_camera_scale)
		
		my_character = character
		character.my_prop = self
		character.set_hide(true, hide_animation)
		character.change_collision(false)
		character.change_parent(hide_place)
		oldPlace = character.global_position
		character.global_position = hide_place.global_position
		sprite.texture = open_sprite
		yield(get_tree().create_timer(OPEN_TIMER), "timeout")
		sprite.texture = close_sprite
	else: #если персонаж выходит из пропа
		if oldPlace != Vector2.ZERO:
			character.global_position = oldPlace
		
		character.set_hide(false, "idle")
		character.change_collision(true)
		character.change_parent(npc_manager)
		character.my_prop = null
		my_character = null
	
	if character == G.player:
		G.player.interact_node.tempInteractObj = self if character.is_hiding else null
		
		var player_id = get_tree().network_peer.get_unique_id()
		G.network.rpc_id(1, "save_hide_in_prop", character.is_hiding, get_path())


func load_hidden_puppet(character):
	if character.state != Character.states.hide: return
	if !character.is_hiding: return
	if my_character != null: return
	character.set_hide_in_prop(character.is_hiding)
	my_character = character
	character.my_prop = self
	character.change_collision(false)
	character.change_parent(hide_place)
	oldPlace = character.global_position
	character.global_position = hide_place.global_position
