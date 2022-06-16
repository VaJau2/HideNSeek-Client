extends Node2D


var player_prefab = preload("res://objects/characters/player.tscn")
var randomPoints = []


func _ready():
	randomize()
	randomPoints = get_children()
	var randI = randi() % get_children().size()
	var point = randomPoints[randI]
	
	var player = player_prefab.instance()
	get_node("../npc").call_deferred("add_child", player)
	player.position = point.position
