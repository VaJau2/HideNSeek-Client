extends Control

const SHOW_CHAT_TIME = 5

@onready var chat = get_node("label")
var is_show = false
var show_chat_time = 0

var may_count_time = true


func add_message(player_name, message):
	if (player_name == null || message == null): return
	chat.text += "[u]{name}[/u]: {text} \n".format({
		"name": player_name, 
		"text": message
	})
	show_chat()


func update_chat(new_text):
	if (new_text == null): return
	chat.text = new_text
	show_chat()


func show_chat():
	is_show = true
	show_chat_time = SHOW_CHAT_TIME
	chat.visible = true
	chat.modulate.a = 1


func _process(delta):
	if is_show && may_count_time:
		if show_chat_time > 0:
			show_chat_time -= delta
		elif chat.modulate.a > 0:
			chat.modulate.a -= delta
		else:
			is_show = false
			chat.visible = false
