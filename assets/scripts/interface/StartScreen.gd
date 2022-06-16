extends Control

onready var levelsLoader = get_node("/root/Main")
onready var input = get_node("input")


func _ready():
	levelsLoader.current_menu = self
	if G.settings.has("player_name"):
		load_main_menu()


func load_main_menu():
	levelsLoader.change_menu("res://objects/interface/MainMenu.tscn")


func set_player_name() -> bool:
	var player_name = input.text
	if player_name.empty():
		input.text = "Пожалуйста, введите нормальное имя"
		return false
	G.settings.set("player_name", player_name)
	return true


func _on_input_gui_input(event):
	if event is InputEventKey && event.pressed && event.scancode == KEY_ENTER:
		if set_player_name():
			load_main_menu()


func _on_Button_pressed():
	if set_player_name():
		load_main_menu()
