extends Control


onready var character = get_node("sprites/character") as Character


func _ready():
	character.changeAnimation("hide2")
	
	var mainNode = get_node("/root/Main")
	if mainNode.current_error:
		$ErrorModalBack.show_modal_error(mainNode.current_error)
		mainNode.current_error = false


func _on_exit_pressed():
	get_tree().quit()
