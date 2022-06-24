extends Control


onready var back = get_node("MenuBack")
onready var speak_modal = get_node("SpeakModal")


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_continue_pressed()


func _on_continue_pressed():
	back.visible = !back.visible
	G.paused = back.visible
	if !back.visible && speak_modal.visible:
		speak_modal.hide()
		get_node("Setting").visible = false


func _on_exit_pressed():
	G.network.force_disconnect(false)
	G.paused = false


func _on_settings_pressed():
	get_node("Setting").visible = true
