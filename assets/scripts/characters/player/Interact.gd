extends Node

const USE_ACTION = "ui_use"

var interactObjectsArray = []
var tempInteractObj = null
var interactLabel = null
var hideLabels = false


func _process(_delta):
	if tempInteractObj && !G.player.is_waiting():
		show_labels()
		if Input.is_action_just_pressed(USE_ACTION):
			var player_id = get_tree().network_peer.get_unique_id()
			G.network.rpc_id(1, "sync_interact", player_id, tempInteractObj.get_path())
			tempInteractObj.interact(self)
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
	interactObjectsArray.remove(deleteObjI)
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
	var actionEvents = InputMap.get_action_list(USE_ACTION)
	interactLabel.text = OS.get_scancode_string(actionEvents[0].scancode)


func show_labels() -> void:
	interactLabel.visible = !hideLabels


func hide_labels() -> void:
	if tempInteractObj != null && interactLabel != null:
		interactLabel.visible = false


func set_temp_interactObj(objI: int) -> void:
	hide_labels()
	tempInteractObj = interactObjectsArray[objI]
	spawn_labels()
