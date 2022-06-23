extends Label

var show_hide_message = false


func show_game_results(searcher_name, hiders_list, is_error):
	if is_error:
		text = "Невозможно продолжить игру, не хватает игроков"
	elif hiders_list.size() == 0:
		text = "Игрок " + searcher_name + " победил, все игроки были найдены!"
	else:
		text = "Игрок " + searcher_name + " проиграл, не были найдены:"
		for hider_name in hiders_list:
			text += "\n" + hider_name
	yield(get_tree().create_timer(2), "timeout")
	text = ""


func show_time(time):
	if time == 0:
		text = ""
		return
	
	match G.player.state:
		Character.states.none, Character.states.wait, Character.states.search:
			text = str(time)
		Character.states.hide:
			text = "Прячься! Осталось: " + str(time) + " сек." if show_hide_message else str(time)


func _ready():
	G.network.game_label = self
