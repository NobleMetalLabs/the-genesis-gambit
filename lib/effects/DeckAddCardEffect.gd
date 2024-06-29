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
	var previous_object_owner : Object = self.card.get_object()
	
	var idents : Array[Identifier] = [card]
	if keep_stats:
		idents.append(IStatisticPossessor.id(self.card))
	if keep_moods:
		idents.append(IMoodPossessor.id(self.card))
	var card_in_deck := CardInDeck.new(idents)
	if at_index == 999:
		self.player.cards_in_deck.append(card_in_deck)
	else:
		self.player.cards_in_deck.insert(at_index, card_in_deck)

	var card_stats := IStatisticPossessor.id(card)

	if previous_object_owner != null:
		if previous_object_owner is CardInHand:
			self.player.cards_in_hand.erase(previous_object_owner)
			card_stats.set_statistic(Genesis.Statistic.IS_IN_HAND, false)
		if previous_object_owner is CardOnField:
			self.player.cards_on_field.erase(previous_object_owner)
			card_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, false)
		previous_object_owner.queue_free()
	card_stats.set_statistic(Genesis.Statistic.IS_IN_DECK, true)
	
	if self.as_marked:
		card_stats.set_statistic(Genesis.Statistic.IS_MARKED, true)
		card_stats.set_statistic(Genesis.Statistic.WAS_JUST_MARKED, true)
		_effect_resolver.request_effect(SetStatisticEffect.new(
			self.requester, card_stats, Genesis.Statistic.WAS_JUST_MARKED, false
		))