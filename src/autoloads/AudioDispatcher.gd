#class_name AudioDispatcher
extends Node

func dispatch_audio(audio : StringName) -> AudioStreamPlayer:
	var new_player : AudioStreamPlayer = AudioStreamPlayer.new()
	new_player.stream = ResourceLoader.load(audio)
	self.add_child(new_player)
	new_player.finished.connect(func() -> void:
		new_player.queue_free()
	)
	new_player.play()
	return new_player
	
func dispatch_positional_audio(source : Node2D, audio : StringName) -> AudioStreamPlayer2D:
	var new_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	new_player.stream = ResourceLoader.load(audio)
	source.add_child(new_player)
	new_player.finished.connect(func() -> void:
		new_player.queue_free()
	)
	new_player.play()
	return new_player
