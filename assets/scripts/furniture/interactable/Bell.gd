extends Interactable

const RING_TIME = 1

onready var anim = get_node("anim")
onready var audi = get_node("audi")
var is_ringing = false
var ring_timer = 0


func _ready():
	G.bell = self


func interact(character):
	if !is_ringing:
		character.change_animation("boop")
		anim.play("ring")
		audi.play()
		is_ringing = true
		ring_timer = RING_TIME
		if character == G.player:
			var player_id = get_tree().network_peer.get_unique_id()
			G.network.rpc_id(1, "start_game", player_id)


func _process(delta):
	if is_ringing:
		if ring_timer > 0:
			ring_timer -= delta
		else:
			anim.play("RESET")
			is_ringing = false
