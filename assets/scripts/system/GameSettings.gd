class_name GameSettings


var settings = {}


func _init():
	load_settings()


func has(key) -> bool:
	return settings.has(key)


func set(key, value):
	settings[key] = value


func get(key):
	if has(key):
		return settings[key]
	return false


func save_settings():
	if settings.size() == 0: return
	var config = ConfigFile.new()
	for key in settings:
		config.set_value("settings", key, settings[key])
	config.save("res://settings.cfg")


func load_settings():
	var config = ConfigFile.new()
	var err = config.load("res://settings.cfg")
	if err != OK:
		return
	
	settings = {}
	for key in config.get_section_keys("settings"):
		settings[key] = config.get_value("settings", key)

