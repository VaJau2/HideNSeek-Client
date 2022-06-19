extends Node2D

class_name Interactable

export var may_interact = true


func interact(_character):
	pass


func _on_Area2D_body_entered(body):
	if !may_interact: return
	if body == G.player:
		body.interact.add_interact_object(self)


func _on_Area2D_body_exited(body):
	if !may_interact: return
	if body == G.player:
		body.interact.remove_interact_object(self)
