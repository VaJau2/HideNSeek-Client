extends AudioStreamPlayer2D

#-----
# Озучивает шаги для всех Character
#-----

const STEP_COOLDOWN = 0.5
const STEP_RUN_COOLDOWN = 0.55

const STEP_SOUNDS_COUNT = 3

var timer = 0
var stepI = 0

var land_material = "dirt"
@onready var parent = get_parent()
@onready var tile_map = get_node_or_null("/root/Main/Scene/tiles/map") as TileMap

@export var stepsArray = {
	"snow": [],
	"wood": [],
	"dirt": [],
	"ice": []
}
@export var stepsRunArray = {
	"snow": [],
	"wood": [],
	"dirt": [],
	"ice": []
}

func _process(delta):
	if parent.velocity.length() > 0:
		if timer > 0:
			timer -= delta
		else:
			update_land_material()
			sound_step()


func update_land_material():
	if tile_map == null: return
	
	var local_pos = tile_map.to_local(global_position)
	var cell_pos = tile_map.local_to_map(local_pos)
	for i in [3,2,1,0]:
		var data = tile_map.get_cell_tile_data(i, cell_pos)
		if data: 
			var new_material = data.get_custom_data("material")
			set_land_material(new_material)
			return


func set_land_material(new_material: String):
	if new_material.is_empty(): return
	land_material = new_material
	parent.set_land_material(new_material)



func sound_step():
	if parent.is_running:
		parent.audi.stream = stepsRunArray[land_material][stepI]
		timer = STEP_RUN_COOLDOWN
	else:
		parent.audi.stream = stepsArray[land_material][stepI]
		timer = STEP_COOLDOWN
	parent.audi.play()
	
	var oldI = stepI
	stepI = randi() % stepsArray[land_material].size()
	while oldI == stepI:
		stepI = randi() % stepsArray[land_material].size()
