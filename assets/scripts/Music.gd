extends AudioStreamPlayer

export var idle_music: AudioStream
export var action_music: AudioStream


func _ready():
	play_idle_music()


func play_idle_music():
	stream = idle_music
	play()


func play_action_music():
	stream = action_music
	play()
