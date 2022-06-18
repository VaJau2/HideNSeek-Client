extends Node2D

#-----
# Спавнит других игроков
#-----

var puppet_prefab = preload("res://objects/characters/puppet.tscn")

onready var puppets_parent = get_node("npc")


func _ready():
	var player_id = get_tree().network_peer.get_unique_id()
	G.network.rpc_id(1, "get_puppets", player_id)


func get_puppet_name(id) -> String: 
	return "puppet_" + String(id)


func get_puppet(id):
	var puppet_name = get_puppet_name(id)
	return puppets_parent.get_node_or_null(puppet_name)


func spawn_puppet(id, position, partsData):
	var new_puppet = puppet_prefab.instance()
	new_puppet.name = get_puppet_name(id)
	puppets_parent.add_child(new_puppet)
	new_puppet.position = position
	new_puppet.parts.load_from_server(partsData)


func despawn_puppet(id):
	var old_puppet = get_puppet(id)
	if old_puppet: old_puppet.queue_free()


func sync_puppet_movement(data):
	var sync_puppet = get_puppet(data.player_id)
	if sync_puppet: sync_puppet.sync_movement(data)


func sync_puppet_position(data):
	var sync_puppet = get_puppet(data.player_id)
	if sync_puppet: sync_puppet.sync_position(data)
