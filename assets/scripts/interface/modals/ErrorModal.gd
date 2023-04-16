extends ColorRect


func show_modal_error(text: String):
	if (!text.is_empty()):
		$block/text.text = text
	else:
		$block/text.text = "Неизвестная ошибка"
	visible = true


func hide_modal_error():
	visible = false
