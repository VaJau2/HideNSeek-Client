extends Node2D

var variants = {}

const OPEN_MOUTH_TIME = 0.25

var isAnimatingMouth = false
var animateMouthTimer = 0
var openMouth = false
var openMouthTimer = 0


#загружает все варианты частей из папок
#названия спрайтов должны соответствовать папкам
func load_variants() -> void:
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		
		var path = "res://assets/sprites/characters/" + part.name
		var dir = DirAccess.open(path)
		variants[part.name] = { 0: "" }
		
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "": break
			#судя по всему, в билде dir видит только ".import" файлы
			elif !file_name.begins_with(".") && file_name.ends_with(".import"):
				var part_name = file_name.split(".")[0]
				variants[part.name][part_name] = part_name
		dir.list_dir_end()


func randomize_variants() -> void:
	if variants.is_empty(): load_variants()
	randomize()

	var body_color = _get_random_color()
	var hair_color = _get_random_color()
	var outfut_color = _get_random_color()
	var outfut2_color = outfut_color
	if (randf_range(0, 1) > 0.5):
		outfut2_color = _get_random_color()
	
	$Base.modulate = body_color
	$Eyes.modulate = _get_random_color()
	
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		var new_part_id = randi() % variants[part.name].size()
		part.set_part_id(new_part_id)
		match part.name:
			"Wings", "Horn":
				part.modulate = body_color
			"Mane", "Tail":
				part.modulate = hair_color
			"Boots", "Scarf", "Hat":
				part.modulate = outfut_color
			"Socks", "Jacket", "Bow":
				part.modulate = outfut2_color


func _get_random_color() -> Color:
	return Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))


func save_to_settings() -> void:
	G.settings.set_value("body_color", $Base.modulate.to_html())
	G.settings.set_value("eyes_color", $Eyes.modulate.to_html())
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		var key = "part_" + part.name
		G.settings.set_value(key + "_color", part.modulate.to_html())
		G.settings.set_value(key + "_id", part.part_id)


func load_from_settings() -> void:
	if !G.settings.has("body_color"): return
	$Base.modulate = Color(G.settings.get_value("body_color"))
	
	if !G.settings.has("eyes_color"): return
	$Eyes.modulate = Color(G.settings.get_value("eyes_color"))
	
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		
		var key = "part_" + part.name
		if !G.settings.has(key + "_color"): return
		part.modulate = Color(G.settings.get_value(key + "_color"))
		
		if !G.settings.has(key + "_id"): return
		var part_id = int(G.settings.get_value(key + "_id"))
		part.set_part_id(part_id)


func get_data_to_server() -> Dictionary:
	var data = {}
	data.body_color = G.settings.get_value("body_color")
	data.eyes_color = G.settings.get_value("eyes_color")
	
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		var key = "part_" + part.name
		data[key + "_id"] = int(G.settings.get_value(key + "_id"))
		data[key + "_color"] = G.settings.get_value(key + "_color")
	
	return data


func load_from_server(data: Dictionary) -> void:
	$Base.modulate = Color(data.body_color)
	$Eyes.modulate = Color(data.eyes_color)
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		var key = "part_" + part.name
		part.set_part_id(data[key + "_id"])
		part.modulate = Color(data[key + "_color"])


func animateMouth(time):
	isAnimatingMouth = true
	animateMouthTimer = time


func _process(delta):
	if isAnimatingMouth:
		if animateMouthTimer > 0:
			animateMouthTimer -= delta
			
			if (openMouthTimer > 0):
				openMouthTimer -= delta
			else:
				$Base/OpenMouth.visible = openMouth
				openMouth = !openMouth
				openMouthTimer = OPEN_MOUTH_TIME
		else:
			openMouth = false
			$Base/OpenMouth.visible = false
			isAnimatingMouth = false
