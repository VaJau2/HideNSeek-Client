extends Area2D

#-----
# Делает дома полупрозрачными
# Когда туда заходит игрок
#-----

@onready var sprite: Sprite2D = get_node("../Sprite2D")


func _on_opacityArea_body_entered(body):
	if body == G.player:
		sprite.modulate.a = 0.6


func _on_opacityArea_body_exited(body):
	if body == G.player:
		sprite.modulate.a = 1
