class_name HandAddCardEffect
extends HandEffect

var card : ICardInstance

func _init(_requester : Object, _player : Player, _card : ICardInstance) -> void:
	self.requester = _requester
	self.player = _player
	self.card = _card

func _to_string() -> String:
	return "HandAddCardEffect(%s,%s)" % [self.player, self.card]

func resolve(_effect_resolver : EffectResolver) -> void:
	self.player.cards_in_hand.append(card)
	var card_stats := IStatisticPossessor.id(card)
	card_stats.set_statistic(Genesis.Statistic.IS_IN_HAND, true)
	