extends ColorRect

@onready var fullscreenInput = get_node("back/fullscreen")
@onready var soundSlider = get_node("back/sound")
@onready var musicSlider = get_node("back/music")
var min_volume = 0


func _ready():
	min_volume = soundSlider.min_value
	
	if G.settings.has("fullscreen"):
		if G.settings.get_value("fullscreen") == 1:
			fullscreenInput.button_pressed = true
			if !((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)):
				get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (true) else Window.MODE_WINDOWED
	else:
		G.settings.set_value("fullscreen", 0)
	
	if G.settings.has("sound"):
		set_volume_value(1, float(G.settings.get_value("sound")), soundSlider)
	else:
		G.settings.set_value("sound", soundSlider.value)
	
	if G.settings.has("music"):
		set_volume_value(2, float(G.settings.get_value("music")), musicSlider)
	else:
		G.settings.set_value("music", musicSlider.value)


func set_volume_value(bus, value, input):
	if bus != 1 && bus != 2: return
	if value < min_volume || value > soundSlider.max_value: return
	_on_volume_value_changed(value, bus)
	input.value = value


func _on_back_pressed():
	visible = false


func _on_fullscreen_toggled(button_pressed):
	G.settings.set_value("fullscreen", 1 if button_pressed else 0)
	get_window().mode = Window.MODE_FULLSCREEN if (button_pressed) else Window.MODE_WINDOWED


func _on_volume_value_changed(value, bus):
	AudioServer.set_bus_mute(bus, value == min_volume)
	AudioServer.set_bus_volume_db(bus, value)
	if bus == 1:
		G.settings.set_value("sound", value)
	elif bus == 2:
		G.settings.set_value("music", value)
