class_name HandBurnHandAction
extends HandAction

static func setup() -> HandBurnHandAction:
	var hbha := HandBurnHandAction.new()
	return hbha

func _init() -> void: pass

func _to_string() -> String:
	return "HandBurnHandAction(%s)" % self.player

func to_effect() -> HandBurnHandEffect:
	return HandBurnHandEffect.new(self, Router.backend.network_player_to_player[self.player])