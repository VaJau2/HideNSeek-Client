extends Node2D

@onready var background = get_node("/root/Main/Scene/canvas/background")
var searcher_point = null
var hider_points = []


func _ready():
	for child in get_children():
		if searcher_point == null:
			searcher_point = child
		else:
			hider_points.append(child)


func teleport_to_point(point_id):
	G.player.set_may_move(false)
	G.player.block_may_move = true
	
	while background.setBackgroundOn():
		await get_tree().process_frame
	
	if point_id == -1:
		G.player.position = searcher_point.position
		G.player.set_flip_x(true)
	else:
		G.player.position = hider_points[point_id].position
		G.player.set_flip_x(false)
	
	while background.setBackgroundOff():
		await get_tree().process_frame
