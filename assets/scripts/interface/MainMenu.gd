extends Control


onready var character = get_node("sprites/character") as Character


func _ready():
	character.changeAnimation("hide2")


func _on_exit_pressed():
	get_tree().quit()
