extends Node

const USE_ACTION = "ui_use"

var interactObjectsArray = []
var tempInteractObj = null
var interactLabel = null
var hideLabels = false


func _process(_delta):
	if tempInteractObj && !G.player.is_waiting() && !G.player.is_typing_in_chat:
		show_labels()
		if Input.is_action_just_pressed(USE_ACTION):
			G.network.rpc_id(1, "sync_interact", tempInteractObj.get_path())
			tempInteractObj.interact(get_parent())
	else:
		hide_labels()


func add_interact_object(newObject) -> void:
	if tempInteractObj == null:
		tempInteractObj = newObject
	interactObjectsArray.append(newObject)
	spawn_labels()


func remove_interact_object(object) -> void:
	if !object in interactObjectsArray: return
	var deleteObjI = interactObjectsArray.find(object)
	interactObjectsArray.remove_at(deleteObjI)
	if interactObjectsArray.size() > 0:
		set_temp_interactObj(0)
	else:
		hide_labels()
		tempInteractObj = null


func clear_interact_objects() -> void:
	interactObjectsArray.clear()
	hide_labels()
	tempInteractObj = null


func spawn_labels() -> void:
	interactLabel = tempInteractObj.get_node("hints/leftLabel")
	var actionEvents = InputMap.action_get_events(USE_ACTION)
	interactLabel.text = OS.get_keycode_string(actionEvents[0].keycode)


func show_labels() -> void:
	interactLabel.visible = !hideLabels


func hide_labels() -> void:
	if tempInteractObj != null && interactLabel != null:
		interactLabel.visible = false


func set_temp_interactObj(objI: int) -> void:
	hide_labels()
	tempInteractObj = interactObjectsArray[objI]
	spawn_labels()
