class_name HandPlayCardAction
extends HandAction

var card : CardInHand

static func setup(_card : CardInHand) -> HandPlayCardAction:
	var hpca := HandPlayCardAction.new()
	hpca.card = _card
	return hpca

func _init() -> void: pass

func _to_string() -> String:
	return "HandPlayCardAction(%s,%s)" % [self.player, self.card]

func to_effect() -> HandRemoveCardEffect:
	return null
