extends Area2D


@onready var parent = get_parent()
var see_players = []
var temp_see_players = []
var obj_i = 0


func check_temp_see_players():
	if temp_see_players.size() > 0:
		for player in temp_see_players:
			_on_seekArea_body_entered(player)
		temp_see_players.clear()


func _on_seekArea_body_entered(body):
	if body == G.player: return
	if body is Character:
		if parent.state != Character.states.search: 
			temp_see_players.append(body)
		else:
			see_players.append(body)
			if get_parent().has_method("check_see_body"):
				get_parent().check_see_body(body)


func _on_seekArea_body_exited(body):
	if get_parent() != G.player: return
	if temp_see_players.has(body):
		temp_see_players.erase(body)
	if see_players.has(body):
		see_players.erase(body)
		if get_parent().has_method("lost_body"):
			get_parent().lost_body(body)


func _process(_delta):
	if parent.state != Character.states.search: return
	if see_players.size() == 0: return
	
	if see_players[obj_i].state != Character.states.hide:
		_on_seekArea_body_exited(see_players[obj_i])
		obj_i = 0
	
	if obj_i < see_players.size() - 1:
		obj_i += 1
	else:
		obj_i = 0
