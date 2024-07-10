class_name HandDrawCardAction
extends HandAction

static func setup() -> HandDrawCardAction:
	var hbha := HandDrawCardAction.new()
	return hbha

func _init() -> void: pass

func _to_string() -> String:
	return "HandDrawCardAction(%s)" % Router.gamefield.peer_id_to_player[self.player_peer_id]

func to_effect() -> HandAddCardEffect:
	return HandAddCardEffect.new(self, Router.gamefield.peer_id_to_player[self.player_peer_id])