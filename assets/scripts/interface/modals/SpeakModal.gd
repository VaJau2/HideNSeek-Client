extends WindowDialog

const SPEAK_TITLE = "Enter - сказать"
const CHAT_TITLE = "Enter - отправить в чат"

onready var input = get_node("LineEdit")
onready var chat = get_node("../Chat")

enum modes {speak, chat}
var current_mode = modes.speak


func _process(_delta):
	if visible:
		if Input.is_action_just_pressed("ui_accept"):
			if current_mode == modes.speak:
				G.player.show_message(input.text)
			elif current_mode == modes.chat:
				var player_name = G.settings.get("player_name")
				G.network.rpc_id(1, "add_message_to_chat_from_user", player_name, input.text)
				chat.may_count_time = true
			visible = false
	else:
		if Input.is_action_just_pressed("ui_speak"):
			current_mode = modes.speak
			show_speak_modal(SPEAK_TITLE)
		if Input.is_action_just_pressed("ui_chat"):
			current_mode = modes.chat
			show_speak_modal(CHAT_TITLE)
			chat.show_chat()
			chat.may_count_time = false


func show_speak_modal(title):
	window_title = title
	show_modal()
	input.grab_focus()
	G.player.may_move = false


func _on_SpeakModal_hide():
	input.text = ""
	G.player.may_move = true
	chat.may_count_time = true
