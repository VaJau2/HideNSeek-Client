extends Node2D

var current_level = null
var current_menu = null


func change_menu(menu_path):
	if menu_path == "" && current_menu:
		current_menu.queue_free()
		current_menu = null
		return
	
	if (ResourceLoader.exists(menu_path)):
		if current_menu: current_menu.queue_free()
		var menu_prefab = load(menu_path)
		var menu = menu_prefab.instance()
		$canvas.call_deferred("add_child", menu)
		current_menu = menu



func load_level(level_name: String):
	if !level_name.empty():
		var scene_path = "res://scenes/" + level_name + ".tscn"
		if (ResourceLoader.exists(scene_path)):
			var scene_prefab = load("res://scenes/" + level_name + ".tscn")
			var scene = scene_prefab.instance()
			call_deferred("add_child", scene)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		G.settings.save_settings()
		get_tree().quit()
