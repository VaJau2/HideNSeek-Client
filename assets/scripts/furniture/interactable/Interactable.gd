extends Node2D

class_name Interactable

export var may_interact = true


func interact(_character):
	pass


func change_may_interact(on: bool):
	may_interact = on
	if !on: _on_Area2D_body_exited(G.player)


func _on_Area2D_body_entered(body):
	if !may_interact: return
	if body == G.player:
		body.interact_node.add_interact_object(self)


func _on_Area2D_body_exited(body):
	if body == G.player:
		body.interact_node.remove_interact_object(self)
