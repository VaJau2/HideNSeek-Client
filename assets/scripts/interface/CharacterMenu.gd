extends ColorRect

onready var character = get_node("characterBack/character")
onready var partsList = get_node("parts")
onready var mainColorPicker = get_node("mainColor")
onready var partColorPicker = get_node("parts_more/part_color")
onready var partIdInput = get_node("parts_more/part_id")


var body_parts = {}
var temp_body_part = null
var ignore_type_check = false


func load_body_parts():
	var parts = get_tree().get_nodes_in_group("body_part")
	var dir = Directory.new()
	for part in parts:
		partsList.add_item(part.name_ru, part.get_instance_id())
		
		var path = "res://assets/sprites/characters/" + part.name
		if dir.open(path) != OK: continue
		body_parts[part.name] = { 0: "" }
		
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "": break
			elif !file_name.begins_with(".") && !file_name.ends_with(".import"):
				var part_name = file_name.split(".")[0]
				body_parts[part.name][part_name] = path + "/" + file_name
		dir.list_dir_end()


func load_name():
	$name.text = G.settings.get("player_name")


func _ready():
	character.changeAnimation("idle")
	mainColorPicker.color = character.get_node("sprites/Base").modulate
	load_body_parts()
	load_name()


func _on_parts_item_selected(index):
	var itemId = partsList.get_item_id(index)
	$parts_more.visible = itemId != 0
	if itemId == 0:
		temp_body_part = null
	else:
		temp_body_part = instance_from_id(itemId)
		var part_variants = body_parts[temp_body_part.name]
		ignore_type_check = true
		partIdInput.max_value = part_variants.keys().size() - 1
		partIdInput.value = temp_body_part.part_id
		partColorPicker.color = temp_body_part.modulate
		ignore_type_check = false


func _on_mainColor_color_changed(color):
	character.get_node("sprites/Base").modulate = color


func _on_part_color_color_changed(color):
	temp_body_part.modulate = color


func _on_part_id_value_changed(value):
	if ignore_type_check: return
	temp_body_part.set_part_id(int(value))
