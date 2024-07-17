class_name HandBurnHandAction
extends HandAction

static func setup() -> HandBurnHandAction:
	var hbha := HandBurnHandAction.new()
	return hbha

func _init() -> void: pass

func _to_string() -> String:
	return "HandBurnHandAction()"

func to_effect() -> HandBurnHandEffect:
	return HandBurnHandEffect.new(self, Router.backend.peer_id_to_player[self.player_peer_id])