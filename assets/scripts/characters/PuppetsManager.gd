extends Node2D

#-----
# Спавнит других игроков
#-----

var puppet_prefab = preload("res://objects/characters/puppet.tscn")

onready var puppets_parent = get_node("npc")
var hidden_puppets = {}


func _ready():
	var player_id = get_tree().network_peer.get_unique_id()
	G.network.rpc_id(1, "get_puppets", player_id)


func get_puppet_name(id) -> String: 
	return "puppet_" + String(id)


func get_puppet(id):
	if hidden_puppets.has(id): 
		return hidden_puppets[id]
	
	var puppet_name = get_puppet_name(id)
	return puppets_parent.get_node_or_null(puppet_name)


func spawn_puppet(puppetData):
	if get_puppet(puppetData.id) != null: return
	var new_puppet = puppet_prefab.instance()
	new_puppet.name = get_puppet_name(puppetData.id)
	new_puppet.gender = puppetData.gender
	puppets_parent.add_child(new_puppet)
	new_puppet.position = puppetData.position
	new_puppet.set_flip_x(puppetData.flip_x)
	new_puppet.parts.load_from_server(puppetData.parts_data)
	new_puppet.set_state(puppetData.state, false)
	if puppetData.is_hiding:
		new_puppet.set_hide(true, puppetData.hiding_animation)
	if puppetData.my_prop_path != "":
		var prop = get_node(puppetData.my_prop_path)
		prop.load_hidden_puppet(new_puppet)


func despawn_puppet(id):
	var old_puppet = get_puppet(id)
	if old_puppet: old_puppet.queue_free()


func sync_puppet_movement(player_id, dir, is_running):
	var sync_puppet = get_puppet(player_id)
	if sync_puppet: sync_puppet.sync_movement(dir, is_running)


func sync_puppet_position(player_id, position):
	var sync_puppet = get_puppet(player_id)
	if sync_puppet: sync_puppet.sync_position(position)


func show_message(puppet_id, message):
	var message_puppet = get_puppet(puppet_id)
	message_puppet.show_message(message)


#игрок для другого игрока отображается как паппет, с которым он может взаимодействовать
func check_interact_with_player(obj_path):
	var player_puppet_name = get_puppet_name(get_tree().network_peer.get_unique_id())
	if str(obj_path).ends_with(player_puppet_name):
		return G.player
	return false


func sync_interact(puppet_id, obj_path):
	var obj = get_node_or_null(obj_path)
	if obj == null: obj = check_interact_with_player(obj_path)
	
	if obj && obj.has_method("interact"):
		var interact_puppet = get_puppet(puppet_id)
		obj.interact(interact_puppet)


func sync_state(puppet_id, new_state):
	var state_puppet = get_puppet(puppet_id)
	state_puppet.set_state(new_state, false)


func sync_hiding(puppet_id, hiding_on, animation):
	var hide_puppet = get_puppet(puppet_id)
	hide_puppet.set_hide(hiding_on, animation)
