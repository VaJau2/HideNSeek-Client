extends Node2D

var variants = {}


#загружает все варианты частей из папок
#названия спрайтов должны соответствовать папкам
func load_variants() -> void:
	var parts = get_children()
	var dir = Directory.new()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		
		var path = "res://assets/sprites/characters/" + part.name
		if dir.open(path) != OK: continue
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
	if variants.empty(): load_variants()
	randomize()

	var body_color = _get_random_color()
	var hair_color = _get_random_color()
	var outfut_color = _get_random_color()
	var outfut2_color = outfut_color
	if (rand_range(0, 1) > 0.5):
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
			"Socks", "Jacket":
				part.modulate = outfut2_color


func _get_random_color() -> Color:
	return Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))


func save_to_settings() -> void:
	G.settings.set("body_color", $Base.modulate.to_html())
	G.settings.set("eyes_color", $Eyes.modulate.to_html())
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		var key = "part_" + part.name
		G.settings.set(key + "_color", part.modulate.to_html())
		G.settings.set(key + "_id", part.part_id)


func load_from_settings() -> void:
	var body_color = G.settings.get("body_color")
	if !body_color: return
	$Base.modulate = Color(body_color)
	
	var eyes_color = G.settings.get("eyes_color")
	if !eyes_color: return
	$Eyes.modulate = Color(eyes_color)
	
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		
		var key = "part_" + part.name
		var part_color = G.settings.get(key + "_color")
		if !part_color: return
		part.modulate = Color(part_color)
		
		var part_id = int(G.settings.get(key + "_id"))
		if part_id <= 0: continue
		part.set_part_id(part_id)


func get_data_to_server() -> Dictionary:
	var data = {}
	data.body_color = G.settings.get("body_color")
	data.eyes_color = G.settings.get("eyes_color")
	
	var parts = get_children()
	for part in parts:
		if !part.is_in_group("body_part"): continue
		var key = "part_" + part.name
		data[key + "_id"] = int(G.settings.get(key + "_id"))
		data[key + "_color"] = G.settings.get(key + "_color")
	
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
