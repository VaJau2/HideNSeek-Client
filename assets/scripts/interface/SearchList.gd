extends Label

var players_list = {}


func _ready():
	G.network.search_list = self


func update_text():
	if players_list.size() == 0:
		text = ""
		return
	
	text = "Осталось найти:"
	for key in players_list:
		text += "\n" + players_list[key]


func show_list(players):
	self.players_list = players
	update_text()


func player_found(found_id):
	var player_id = get_tree().network_peer.get_unique_id()
	if found_id == player_id:
		text = "Вас успешно нашли!"
		yield(get_tree().create_timer(1.5), "timeout")
		text = ""
	
	if G.player.state == Character.states.search:
		players_list.erase(found_id)
		update_text()
