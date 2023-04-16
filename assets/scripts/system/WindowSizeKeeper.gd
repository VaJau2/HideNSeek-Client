extends Node

#блокирует ресайз окна на слишком большую величину, 
#чтобы не было видно всю карту по вертикали или горизонтали

const MIN_SIZE_SCALE = 1.2
const MAX_SIZE_SCALE = 2.2


var temp_size: Vector2


func _ready():
	pass
	#get_node("/root").connect("size_changed", Callable(self, "resize"))


func resize():
	if G.settings.get_value("fullscreen"):
		return
	var currentSize = get_window().get_size()
	var sizeScale = currentSize.x / currentSize.y
	if sizeScale > MIN_SIZE_SCALE && sizeScale < MAX_SIZE_SCALE:
		temp_size = currentSize
	else:
		get_window().size = temp_size

