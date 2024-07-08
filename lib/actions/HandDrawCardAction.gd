class_name HandDrawCardAction
extends HandAction

static func setup() -> HandDrawCardAction:
	var hbha := HandDrawCardAction.new()
	print(MultiplayerManager.network_player)
	print(hbha.player)
	return hbha

func _init() -> void: pass

func _to_string() -> String:
	return "HandDrawCardAction(%s)" % self.player

func to_effect() -> HandAddCardEffect:
	return HandAddCardEffect.new(self, Router.gamefield.network_player_to_player[self.player])