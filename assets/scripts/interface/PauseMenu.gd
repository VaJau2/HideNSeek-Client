extends Control


@onready var back = get_node("MenuBack")
@onready var speak_modal = get_node("SpeakModal")
@onready var settings = get_node("Setting")


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_continue_pressed()


func _on_continue_pressed():
	back.visible = !back.visible
	G.paused = back.visible
	if !back.visible:
		if speak_modal.visible:
			speak_modal.hide()
		if settings.visible:
			settings.hide()


func _on_exit_pressed():
	G.network.force_disconnect(false)
	G.paused = false


func _on_settings_pressed():
	settings.visible = true
