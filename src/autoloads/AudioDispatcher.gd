#class_name AudioDispatcher
extends Node

var sound_path : String = "res://ast/sound/"

func dispatch_audio(audio : StringName) -> AudioStreamPlayer:
	var new_player : AudioStreamPlayer = AudioStreamPlayer.new()
	
	if FileAccess.file_exists("%s/%s.tres" % [sound_path, audio]):
		new_player.stream = ResourceLoader.load("%s/%s.tres" % [sound_path, audio])
	elif FileAccess.file_exists("%s/%s.wav" % [sound_path, audio]):
		new_player.stream = ResourceLoader.load("%s/%s.wav" % [sound_path, audio])
	else:
		push_error("Audio file not found: %s" % audio)
		return null

	self.add_child(new_player)
	new_player.finished.connect(func() -> void:
		new_player.queue_free()
	)
	new_player.play()
	return new_player

func dispatch_positional_audio(position : Vector2, audio : StringName) -> AudioStreamPlayer2D:
	var new_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	if FileAccess.file_exists("%s/%s.tres" % [sound_path, audio]):
		new_player.stream = ResourceLoader.load("%s/%s.tres" % [sound_path, audio])
	elif FileAccess.file_exists("%s/%s.wav" % [sound_path, audio]):
		new_player.stream = ResourceLoader.load("%s/%s.wav" % [sound_path, audio])
	else:
		push_error("Audio file not found: %s" % audio)
		return null

	self.add_child(new_player)
	new_player.global_position = position
	new_player.finished.connect(func() -> void:
		new_player.queue_free()
	)
	new_player.play()
	return new_player
