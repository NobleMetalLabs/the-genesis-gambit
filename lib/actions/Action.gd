class_name Action
extends Serializeable

# TODO: (like years from now) replays and huh button.

var player : NetworkPlayer = MultiplayerManager.network_player

func _init() -> void:
	assert(false, "Action is an abstract class and should not be instantiated.")