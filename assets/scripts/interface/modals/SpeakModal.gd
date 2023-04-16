extends Window

const SPEAK_TITLE = "Enter - сказать"
const CHAT_TITLE = "Enter - отправить в чат"

@onready var input = get_node("LineEdit")
@onready var chat = get_node("../Chat")

enum modes {speak, chat}
var current_mode = modes.speak


func _process(_delta):
	if G.paused: return
	
	if visible:
		if Input.is_action_just_pressed("ui_accept"):
			if current_mode == modes.speak:
				G.player.show_message(input.text)
			elif current_mode == modes.chat:
				var player_name = G.settings.get_value("player_name")
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


func show_speak_modal(new_title):
	title = new_title
	show()
	input.grab_focus()
	G.player.set_may_move(false)
	G.player.set_typing_in_chat(true)


func _on_visibility_changed():
	if visible: return
	input.text = ""
	G.player.set_may_move(true)
	chat.may_count_time = true
	G.player.set_typing_in_chat(false)
