extends Control

onready var levelsLoader = get_node("/root/Main")
onready var character = get_node("sprites/character") as Character


func _ready():
	character.changeAnimation("hide2")
	if G.settings.has("body_color"):
		character.parts.load_from_settings()
	else:
		character.parts.randomize_variants()
		character.parts.save_to_settings()
	
	var mainNode = get_node("/root/Main")
	if mainNode.current_error:
		$ErrorModalBack.show_modal_error(mainNode.current_error)
		mainNode.current_error = false


func _on_exit_pressed():
	G.settings.save_settings()
	get_tree().quit()


func _on_character_settings_pressed():
	levelsLoader.change_menu("res://objects/interface/CharacterMenu.tscn")
