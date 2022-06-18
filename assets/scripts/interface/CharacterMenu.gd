extends ColorRect

const GENDERS = {
	0: "female",
	1: "male"
}


onready var levelsLoader = get_node("/root/Main")
onready var character = get_node("characterBack/character")
onready var partsList = get_node("parts")
onready var mainColorPicker = get_node("mainColor")
onready var eyesColorPicker = get_node("eyesColor")
onready var partColorPicker = get_node("parts_more/part_color")
onready var partIdInput = get_node("parts_more/part_id")


var temp_body_part = null
var ignore_type_check = false


func _ready():
	character.change_animation("idle")
	character.parts.load_variants()
	character.parts.load_from_settings()
	mainColorPicker.color = character.get_node("sprites/Base").modulate
	eyesColorPicker.color = character.get_node("sprites/Eyes").modulate
	load_body_parts()
	load_name()
	load_gender()


func load_body_parts():
	var parts = get_tree().get_nodes_in_group("body_part")
	for part in parts:
		if part.get_node("../../") != character: continue
		partsList.add_item(part.name_ru, part.get_instance_id())


func load_name():
	$name.text = G.settings.get("player_name")


func load_gender():
	var gender_name = G.settings.get("gender")
	for gender_id in GENDERS:
		if GENDERS[gender_id] == gender_name:
			$gender.selected = gender_id
			return


func _on_parts_item_selected(index):
	var itemId = partsList.get_item_id(index)
	$parts_more.visible = itemId != 0
	if itemId == 0:
		temp_body_part = null
	else:
		temp_body_part = instance_from_id(itemId)
		ignore_type_check = true
		partIdInput.max_value = character.parts.variants.keys().size() - 1
		partIdInput.value = temp_body_part.part_id
		partColorPicker.color = temp_body_part.modulate
		ignore_type_check = false


func _on_mainColor_color_changed(color):
	character.get_node("sprites/Base").modulate = color


func _on_eyesColor_color_changed(color):
	character.get_node("sprites/Eyes").modulate = color


func _on_part_color_color_changed(color):
	temp_body_part.modulate = color


func _on_part_id_value_changed(value):
	if ignore_type_check: return
	temp_body_part.set_part_id(int(value))


func _on_gender_item_selected(index):
	if GENDERS.has(index):
		G.settings.set("gender", GENDERS[index])


func _on_save_pressed():
	G.settings.set("player_name", $name.text) 
	character.parts.save_to_settings()
	_on_back_pressed()


func _on_back_pressed():
	levelsLoader.change_menu("res://objects/interface/MainMenu.tscn")


func _on_random_pressed():
	character.parts.randomize_variants()
	mainColorPicker.color = character.get_node("sprites/Base").modulate
	eyesColorPicker.color = character.get_node("sprites/Eyes").modulate
	if temp_body_part:
		partColorPicker.color = temp_body_part.modulate
		partIdInput.value = temp_body_part.part_id
		
