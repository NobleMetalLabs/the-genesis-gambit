class_name HandDrawCardAction
extends HandAction

static func setup() -> HandDrawCardAction:
	var hbha := HandDrawCardAction.new()
	return hbha

func _init() -> void: pass

func _to_string() -> String:
	return "HandDrawCardAction(%s)" % self.player

func to_effect() -> HandAddCardEffect:
	print(self.player)
	print(Router.gamefield.network_player_to_player.keys())
	print(self.player in Router.gamefield.network_player_to_player.keys())
	return HandAddCardEffect.new(self, Router.gamefield.network_player_to_player[self.player])