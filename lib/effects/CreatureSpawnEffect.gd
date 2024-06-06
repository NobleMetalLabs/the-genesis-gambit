class_name CreatureSpawnEffect
extends GamefieldEffect #TODO: Hack! Creature*Effect.creature should be ICardInstance

var card : ICardInstance
var keep_stats : bool
var keep_moods : bool

func _init(_card : ICardInstance,  _keep_stats : bool = true, _keep_moods : bool = true) -> void:
	self.card = _card
	self.keep_stats = _keep_stats
	self.keep_moods = _keep_moods

func _to_string() -> String:
	return "CreatureSpawnEffect(%s,%s,%s)" % [self.card, self.keep_stats, self.keep_moods]

func resolve(effect_resolver : EffectResolver) -> void:
	var previous_object_owner : Object = self.card.get_object()
	var previous_stats := IStatisticPossessor.id(self.card)

	var position : Vector2 = previous_stats.get_statistic(Genesis.Statistic.POSITION)

	var idents : Array[Identifier] = [card]
	if keep_stats:
		idents.append(previous_stats)
	if keep_moods:
		idents.append(IMoodPossessor.id(self.card))
	var creature := CardOnField.new(idents)

	var player_owner : Player = self.card.player
	var creature_stats := IStatisticPossessor.id(card)
	if previous_object_owner != null:
		if previous_object_owner is CardInHand:
			player_owner.cards_in_hand.erase(previous_object_owner)
			#creature_stats.set_statistic(Genesis.Statistic.IS_IN_HAND, false)
		if previous_object_owner is CardInDeck:
			player_owner.deck.remove_card(previous_object_owner)
		previous_object_owner.queue_free()
	creature_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, true)

	player_owner.cards_on_field.append(creature)
	Router.gamefield.place_card(creature, position)

	if Router.client_ui.current_card_ghost != null:
		Router.client_ui.current_card_ghost.queue_free()

	creature_stats.set_statistic(Genesis.Statistic.WAS_JUST_PLAYED, true)
	var just_played_expire_effect := SetStatisticEffect.new(creature_stats, Genesis.Statistic.WAS_JUST_PLAYED, false)
	just_played_expire_effect.requester = self.requester
	effect_resolver.request_effect(just_played_expire_effect)
