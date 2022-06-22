extends Area2D


var is_working = false #активируется, когда игрок переходит в состояние ищущего
var see_players = []
var obj_i = 0


func _on_seekArea_body_entered(body):
	if !is_working: return
	if body == G.player: return
	if body is Character:
		if body.state != Character.states.hide: return
		see_players.append(body)
		if get_parent().has_method("check_see_body"):
			get_parent().check_see_body(body)


func _on_seekArea_body_exited(body):
	if !is_working: return
	if get_parent() != G.player: return
	if see_players.has(body):
		see_players.erase(body)
		if get_parent().has_method("lost_body"):
			get_parent().lost_body(body)


func _process(_delta):
	if !is_working: return
	if see_players.size() == 0: return
	
	if see_players[obj_i].state != Character.states.hide:
		_on_seekArea_body_exited(see_players[obj_i])
		obj_i = 0
	
	if obj_i < see_players.size() - 1:
		obj_i += 1
	else:
		obj_i = 0
