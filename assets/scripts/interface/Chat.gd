extends Control

const SHOW_CHAT_TIME = 5

onready var chat = get_node("label")
var show_chat = false
var show_chat_time = 0

var may_count_time = true


func add_message(name, message):
	if (name == null || message == null): return
	chat.bbcode_text += "[u]{name}[/u]: {text} \n".format({
		"name": name, 
		"text": message
	})
	show_chat()


func update_chat(new_text):
	if (new_text == null): return
	chat.bbcode_text = new_text
	show_chat()


func show_chat():
	show_chat = true
	show_chat_time = SHOW_CHAT_TIME
	chat.visible = true
	chat.modulate.a = 1


func _process(delta):
	if show_chat && may_count_time:
		if show_chat_time > 0:
			show_chat_time -= delta
		elif chat.modulate.a > 0:
			chat.modulate.a -= delta
		else:
			show_chat = false
			chat.visible = false
