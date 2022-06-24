extends ColorRect

onready var fullscreenInput = get_node("back/fullscreen")
onready var soundSlider = get_node("back/sound")
onready var musicSlider = get_node("back/music")
var min_volume = 0


func _ready():
	min_volume = soundSlider.min_value
	
	if G.settings.has("fullscreen"):
		if G.settings.get("fullscreen") == 1:
			fullscreenInput.pressed = true
			if !OS.window_fullscreen:
				OS.window_fullscreen = true
	else:
		G.settings.set("fullscreen", 0)
	
	if G.settings.has("sound"):
		set_volume_value(1, float(G.settings.get("sound")), soundSlider)
	else:
		G.settings.set("sound", soundSlider.value)
	
	if G.settings.has("music"):
		set_volume_value(2, float(G.settings.get("music")), musicSlider)
	else:
		G.settings.set("music", musicSlider.value)


func set_volume_value(bus, value, input):
	if bus != 1 && bus != 2: return
	if value < min_volume || value > soundSlider.max_value: return
	_on_volume_value_changed(value, bus)
	input.value = value


func _on_back_pressed():
	visible = false


func _on_fullscreen_toggled(button_pressed):
	G.settings.set("fullscreen", 1 if button_pressed else 0)
	OS.window_fullscreen = button_pressed


func _on_volume_value_changed(value, bus):
	AudioServer.set_bus_mute(bus, value == min_volume)
	AudioServer.set_bus_volume_db(bus, value)
	if bus == 1:
		G.settings.set("sound", value)
	elif bus == 2:
		G.settings.set("music", value)
