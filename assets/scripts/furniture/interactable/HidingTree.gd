extends "res://assets/scripts/furniture/interactable/HideSpot.gd"

@export var shadow_size = Vector2(1,1)
var shadow_texture = preload("res://assets/sprites/shadows/treeShadow.png")


func _ready():
	super._ready()
	spawnShadow()


func spawnShadow():
	var my_shadow = Sprite2D.new()
	await get_tree().process_frame
	var root = get_node("/root/Main/Scene/shadows")
	root.add_child(my_shadow)
	
	my_shadow.texture = shadow_texture
	my_shadow.global_position = global_position
	my_shadow.scale = shadow_size
	my_shadow.modulate.a = 0.42
