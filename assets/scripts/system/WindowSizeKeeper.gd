extends Node

#блокирует ресайз окна на слишком большую величину, 
#чтобы не было видно всю карту по вертикали или горизонтали

const MIN_SIZE_SCALE = 1.2
const MAX_SIZE_SCALE = 2.2


var temp_size: Vector2


func _ready():
	get_node("/root").connect("size_changed", self, "resize")


func resize():
	if G.settings.get("fullscreen"):
		return
	var currentSize = OS.get_window_size()
	var sizeScale = currentSize.x / currentSize.y
	if sizeScale > MIN_SIZE_SCALE && sizeScale < MAX_SIZE_SCALE:
		temp_size = currentSize
	else:
		OS.window_size = temp_size

