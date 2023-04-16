extends Sprite2D

@export var name_ru = ""
@export var trigger_change_path: NodePath
@export var check_part_path: NodePath

var part_id = 0
var trigger_change = null #часть, которая будет меняться сразу после этой
var check_part = null #часть, которая проверяется на наличие (если включено, добавляется в название через "_")


func _ready():
	if trigger_change_path: trigger_change = get_node(trigger_change_path)
	if check_part_path: check_part = get_node(check_part_path)


func set_part_id(new_id = 0, force = false):
	if part_id == new_id && !force: return
	part_id = new_id
	if new_id == 0: 
		texture = null
	else:
		var part_name = name
		if check_part && check_part.part_id > 0:
			part_name += "_" + check_part.name
		var path = "res://assets/sprites/characters/" + part_name + "/" + str(new_id) + ".png"
		if !ResourceLoader.exists(path): return
		texture = load(path)
		
	if trigger_change:
		trigger_change.reload_part()


func reload_part():
	set_part_id(
part_id, true)
