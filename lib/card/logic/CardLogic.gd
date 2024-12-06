@icon("res://lib/CardLogic.png")
class_name CardLogic
extends RefCounted

var game_access : GameAccess
var verbose : bool = false

func _init(_owner : ICardInstance) -> void:
	pass
	#self.instance_owner = _owner

func WAS_CREATED(event : WasCreatedEvent) -> void:
	if verbose: print("%s was created" % [event.card])
	return

func ENTERED_DECK(event : EnteredDeckEvent) -> void:
	if verbose: print("%s entered deck of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_DECK, true)
	return

func LEFT_DECK(event : LeftDeckEvent) -> void:
	if verbose: print("%s left deck of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_DECK, false)
	return

func ENTERED_HAND(event : EnteredHandEvent) -> void:
	if verbose: print("%s entered hand of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_HAND, true)
	return

func LEFT_HAND(event : LeftHandEvent) -> void:
	if verbose: print("%s left hand of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_HAND, false)
	return

func ENTERED_FIELD(event : EnteredFieldEvent) -> void:
	if verbose: print("%s entered field of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_ON_FIELD, true)
	return

func LEFT_FIELD(event : LeftFieldEvent) -> void:
	if verbose: print("%s left field of %s" % [event.card, event.card.player])
	var card_stats := IStatisticPossessor.id(event.card)
	card_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, false)
	game_access.card_processor.request_event(WasMarkedEvent.new(event.card))
	game_access.card_processor.request_event(EnteredDeckEvent.new(event.card))
	return

func WAS_BURNED(event : WasBurnedEvent) -> void:
	if verbose: print("%s was burned" % [event.card])
	game_access.card_processor.request_event(LeftHandEvent.new(event.card))
	return

func WAS_MARKED(event : WasMarkedEvent) -> void:
	if verbose: print("%s was marked" % [event.card])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_MARKED, true)
	return

func WAS_UNMARKED(event : WasUnmarkedEvent) -> void:
	if verbose: print("%s was unmarked" % [event.card])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_MARKED, false)
	return

func WAS_DISCARDED(event : WasDiscardedEvent) -> void:
	if verbose: print("%s was discarded" % [event.card])
	game_access.card_processor.request_event(LeftHandEvent.new(event.card))
	return

func ATTACKED(event : AttackedEvent) -> void:
	if verbose: print("%s attacked %s for %s" % [event.card, event.who, event.damage])
	game_access.card_processor.request_event(WasAttackedEvent.new(event.who, event.card, event.damage))
	return

func WAS_ATTACKED(event : WasAttackedEvent) -> void:
	if verbose: print("%s was attacked by %s for %s" % [event.card, event.by_who, event.damage])
	var health : int = IStatisticPossessor.id(event.card).get_statistic(Genesis.Statistic.HEALTH)
	var new_health : int = health - event.damage
	IStatisticPossessor.id(event.by_who).set_statistic(Genesis.Statistic.HEALTH, new_health)
	if new_health <= 0:
		game_access.card_processor.request_event(KilledEvent.new(event.by_who, event.card))
	return

func WAS_ACTIVATED(event : WasActivatedEvent) -> void:
	if verbose: print("%s was activated" % [event.card])
	var card_stats := IStatisticPossessor.id(event.card)
	if card_stats.get_statistic(Genesis.Statistic.CHARGES): return
	card_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
	return

func TARGETED(event : TargetedEvent) -> void:
	if verbose: print("%s targeted %s" % [event.card, event.who])
	
	var card_stats := IStatisticPossessor.id(event.card)
	card_stats.set_statistic(Genesis.Statistic.HAS_TARGET, true)
	card_stats.set_statistic(Genesis.Statistic.TARGET, event.who)

	if event.card.meta.type == Genesis.CardType.SUPPORT:
		if game_access.are_two_cards_friendly(event.card, event.who):
			game_access.card_processor.request_event(SupportedEvent.new(event.card, event.who))
			return
	game_access.card_processor.request_event(WasTargetedEvent.new(event.who, event.card))
	return

func WAS_TARGETED(event : WasTargetedEvent) -> void:
	if verbose: print("%s was targeted by %s" % [event.card, event.by])
	return

func SUPPORTED(event : SupportedEvent) -> void:
	if verbose: print("%s supported %s" % [event.card, event.who])
	return

func WAS_SUPPORTED(event : WasSupportedEvent) -> void:
	if verbose: print("%s was supported by %s" % [event.card, event.by])
	return

func KILLED(event : KilledEvent) -> void:
	if verbose: print("%s killed %s" % [event.card, event.who])
	game_access.card_processor.request_event(WasKilledEvent.new(event.who, event.card))
	return

func WAS_KILLED(event : WasKilledEvent) -> void:
	if verbose: print("%s was killed by %s" % [event.card, event.by])
	game_access.card_processor.request_event(LeftFieldEvent.new(event.card))
	return

func GAVE_MOOD(event : GaveMoodEvent) -> void:
	if verbose: print("%s gave %s mood %s" % [event.card, event.who, event.mood])
	game_access.card_processor.request_event(GainedMoodEvent.new(event.who, event.card, event.mood))
	return

func GAINED_MOOD(event : GainedMoodEvent) -> void:
	if verbose: print("%s gained mood %s from %s" % [event.card, event.mood, event.from])
	IMoodPossessor.id(event.card).apply_mood(event.mood)
	return

func TOOK_MOOD(event : TookMoodEvent) -> void:
	if verbose: print("%s took mood %s from %s" % [event.card, event.mood, event.who])
	game_access.card_processor.request_event(LostMoodEvent.new(event.who, event.card, event.mood))
	return

func LOST_MOOD(event : LostMoodEvent) -> void:
	if verbose: print("%s lost mood %s from %s" % [event.card, event.mood, event.from])
	IMoodPossessor.id(event.card).remove_mood(event.mood)
	return

func PLAYED_CARD(event : PlayedCardEvent) -> void:
	if verbose: print("%s played card %s" % [event.card.player, event.card])
	game_access.card_processor.request_event(LeftHandEvent.new(event.card))
	game_access.card_processor.request_event(EnteredFieldEvent.new(event.card))
	return

func BURNED_HAND(event : BurnedHandEvent) -> void:
	if verbose: print("%s burned hand" % [event.card.player])
	return

func BEGAN_DECK_MAINTENANCE(event : BeganDeckMaintenanceEvent) -> void:
	if verbose: print("%s began deck maintenance" % [event.card.player])
	return

func ENDED_DECK_MAINTENANCE(event : EndedDeckMaintenanceEvent) -> void:
	if verbose: print("%s ended deck maintenance" % [event.card.player])
	return
