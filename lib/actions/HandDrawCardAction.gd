class_name HandDrawCardAction
extends HandAction

static func setup() -> HandDrawCardAction:
	var hbha := HandDrawCardAction.new()
	return hbha

func _init() -> void: pass

func _to_string() -> String:
	return "HandDrawCardAction(%s)" % Router.backend.peer_id_to_player[self.player_peer_id]

func to_effect() -> DeckDrawCardEffect:
	return DeckDrawCardEffect.new(self, Router.backend.peer_id_to_player[self.player_peer_id])
