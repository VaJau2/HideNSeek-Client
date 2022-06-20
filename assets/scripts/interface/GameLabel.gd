extends Label


func show_time(time):
	if time == 0:
		text = ""
		return
	
	match G.player.state:
		Character.states.none, Character.states.wait:
			text = String(time)
		Character.states.hide:
			text = "Прячься! Осталось: " + String(time) + " сек."


func _ready():
	G.network.game_label = self
