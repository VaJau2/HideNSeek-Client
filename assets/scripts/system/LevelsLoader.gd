extends Node

var current_level = null
var current_menu = null
var current_error = false


func change_menu(menu_path: String):
	if menu_path == "" && current_menu:
		current_menu.queue_free()
		current_menu = null
		return
	
	if (ResourceLoader.exists(menu_path)):
		if current_menu: current_menu.queue_free()
		var menu_prefab = load(menu_path)
		var menu = menu_prefab.instantiate()
		$canvas.call_deferred("add_child", menu)
		current_menu = menu


func load_level(level_name: String):
	if level_name == "" && current_level:
		current_level.queue_free()
		current_level = null
		return
	
	var scene_path = "res://scenes/" + level_name + ".tscn"
	if (ResourceLoader.exists(scene_path)):
		var scene_prefab = load("res://scenes/" + level_name + ".tscn")
		var scene = scene_prefab.instantiate()
		call_deferred("add_child", scene)
		current_level = scene


#сохранение настроек перед выходом из игры
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		G.settings.save_settings()
		get_tree().quit()
