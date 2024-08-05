class_name DeckAddCardEffect
extends PlayerEffect

var card : ICardInstance
var as_marked : bool
var keep_stats : bool
var keep_moods : bool
var at_index : int

func _init(_requester : Object, _player : Player, _card : ICardInstance, _as_marked : bool = true, _keep_stats : bool = false, _keep_moods : bool = false, _at_index : int = 999) -> void:
	self.requester = _requester
	self.player = _player
	self.card = _card
	self.as_marked = _as_marked
	self.keep_stats = _keep_stats
	self.keep_moods = _keep_moods
	self.at_index = _at_index
	
func _to_string() -> String:
	return "DeckAddCardEffect(%s,%s,%s,%s)" % [self.player, self.card, self.keep_stats, self.keep_moods]

func resolve(_effect_resolver : EffectResolver) -> void:
	if at_index == 999:
		self.player.cards_in_deck.append(card)
	else:
		if at_index < 0:
			at_index = self.player.cards_in_deck.size() + at_index
		self.player.cards_in_deck.insert(at_index, card)

	var card_stats := IStatisticPossessor.id(card)
	card_stats.set_statistic(Genesis.Statistic.IS_IN_DECK, true)
	
	IStatisticPossessor.id(player).modify_statistic(Genesis.Statistic.NUM_CARDS_LEFT_IN_DECK, 1)

	if self.as_marked:
		IStatisticPossessor.id(player).modify_statistic(Genesis.Statistic.NUM_CARDS_MARKED_IN_DECK, 1)
		
		card_stats.set_statistic(Genesis.Statistic.IS_MARKED, true)
		card_stats.set_statistic(Genesis.Statistic.WAS_JUST_MARKED, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, card_stats, Genesis.Statistic.WAS_JUST_MARKED, false
		))