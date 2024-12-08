@icon("res://lib/CardLogic.png")
class_name CardLogic
extends RefCounted

var game_access : GameAccess
var owner : ICardInstance
var verbose : bool = false

func _init(_owner : ICardInstance) -> void:
	WAS_CREATED.connect(HANDLE_WAS_CREATED)
	ENTERED_DECK.connect(HANDLE_ENTERED_DECK)
	LEFT_DECK.connect(HANDLE_LEFT_DECK)
	ENTERED_HAND.connect(HANDLE_ENTERED_HAND)
	LEFT_HAND.connect(HANDLE_LEFT_HAND)
	ENTERED_FIELD.connect(HANDLE_ENTERED_FIELD)
	LEFT_FIELD.connect(HANDLE_LEFT_FIELD)
	WAS_BURNED.connect(HANDLE_WAS_BURNED)
	WAS_MARKED.connect(HANDLE_WAS_MARKED)
	WAS_UNMARKED.connect(HANDLE_WAS_UNMARKED)
	WAS_DISCARDED.connect(HANDLE_WAS_DISCARDED)
	ATTACKED.connect(HANDLE_ATTACKED)
	WAS_ATTACKED.connect(HANDLE_WAS_ATTACKED)
	WAS_ACTIVATED.connect(HANDLE_WAS_ACTIVATED)
	TARGETED.connect(HANDLE_TARGETED)
	WAS_TARGETED.connect(HANDLE_WAS_TARGETED)
	SUPPORTED.connect(HANDLE_SUPPORTED)
	WAS_SUPPORTED.connect(HANDLE_WAS_SUPPORTED)
	KILLED.connect(HANDLE_KILLED)
	WAS_KILLED.connect(HANDLE_WAS_KILLED)
	GAVE_MOOD.connect(HANDLE_GAVE_MOOD)
	GAINED_MOOD.connect(HANDLE_GAINED_MOOD)
	TOOK_MOOD.connect(HANDLE_TOOK_MOOD)
	LOST_MOOD.connect(HANDLE_LOST_MOOD)
	PLAYED_CARD.connect(HANDLE_PLAYED_CARD)
	BURNED_HAND.connect(HANDLE_BURNED_HAND)
	BEGAN_DECK_MAINTENANCE.connect(HANDLE_BEGAN_DECK_MAINTENANCE)
	ENDED_DECK_MAINTENANCE.connect(HANDLE_ENDED_DECK_MAINTENANCE)

signal WAS_CREATED(event : WasCreatedEvent)
func HANDLE_WAS_CREATED(event : WasCreatedEvent) -> void:
	if verbose: print("%s was created" % [event.card])
	return

signal ENTERED_DECK(event : EnteredDeckEvent)
func HANDLE_ENTERED_DECK(event : EnteredDeckEvent) -> void:
	if verbose: print("%s entered deck of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_DECK, true)
	return

signal LEFT_DECK(event : LeftDeckEvent)
func HANDLE_LEFT_DECK(event : LeftDeckEvent) -> void:
	if verbose: print("%s left deck of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_DECK, false)
	return

signal ENTERED_HAND(event : EnteredHandEvent)
func HANDLE_ENTERED_HAND(event : EnteredHandEvent) -> void:
	if verbose: print("%s entered hand of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_HAND, true)
	return

signal LEFT_HAND(event : LeftHandEvent)
func HANDLE_LEFT_HAND(event : LeftHandEvent) -> void:
	if verbose: print("%s left hand of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_IN_HAND, false)
	return

signal ENTERED_FIELD(event : EnteredFieldEvent)
func HANDLE_ENTERED_FIELD(event : EnteredFieldEvent) -> void:
	if verbose: print("%s entered field of %s" % [event.card, event.card.player])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_ON_FIELD, true)
	return

signal LEFT_FIELD(event : LeftFieldEvent)
func HANDLE_LEFT_FIELD(event : LeftFieldEvent) -> void:
	if verbose: print("%s left field of %s" % [event.card, event.card.player])
	var card_stats := IStatisticPossessor.id(event.card)
	card_stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, false)
	game_access.card_processor.request_event(WasMarkedEvent.new(event.card))
	game_access.card_processor.request_event(EnteredDeckEvent.new(event.card))
	return

signal WAS_BURNED(event : WasBurnedEvent)
func HANDLE_WAS_BURNED(event : WasBurnedEvent) -> void:
	if verbose: print("%s was burned" % [event.card])
	game_access.card_processor.request_event(LeftHandEvent.new(event.card))
	return

signal WAS_MARKED(event : WasMarkedEvent)
func HANDLE_WAS_MARKED(event : WasMarkedEvent) -> void:
	if verbose: print("%s was marked" % [event.card])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_MARKED, true)
	return

signal WAS_UNMARKED(event : WasUnmarkedEvent)
func HANDLE_WAS_UNMARKED(event : WasUnmarkedEvent) -> void:
	if verbose: print("%s was unmarked" % [event.card])
	IStatisticPossessor.id(event.card).set_statistic(Genesis.Statistic.IS_MARKED, false)
	return

signal WAS_DISCARDED(event : WasDiscardedEvent)
func HANDLE_WAS_DISCARDED(event : WasDiscardedEvent) -> void:
	if verbose: print("%s was discarded" % [event.card])
	game_access.card_processor.request_event(LeftHandEvent.new(event.card))
	return

signal ATTACKED(event : AttackedEvent)
func HANDLE_ATTACKED(event : AttackedEvent) -> void:
	if verbose: print("%s attacked %s for %s" % [event.card, event.who, event.damage])
	game_access.card_processor.request_event(WasAttackedEvent.new(event.who, event.card, event.damage))
	return

signal WAS_ATTACKED(event : WasAttackedEvent)
func HANDLE_WAS_ATTACKED(event : WasAttackedEvent) -> void:
	if verbose: print("%s was attacked by %s for %s" % [event.card, event.by_who, event.damage])
	var health : int = IStatisticPossessor.id(event.card).get_statistic(Genesis.Statistic.HEALTH)
	var new_health : int = health - event.damage
	IStatisticPossessor.id(event.by_who).set_statistic(Genesis.Statistic.HEALTH, new_health)
	if new_health <= 0:
		game_access.card_processor.request_event(KilledEvent.new(event.by_who, event.card))
	return

signal WAS_ACTIVATED(event : WasActivatedEvent)
func HANDLE_WAS_ACTIVATED(event : WasActivatedEvent) -> void:
	if verbose: print("%s was activated" % [event.card])
	var card_stats := IStatisticPossessor.id(event.card)
	if card_stats.get_statistic(Genesis.Statistic.CHARGES): return
	card_stats.modify_statistic(Genesis.Statistic.CHARGES, -1)
	return

signal TARGETED(event : TargetedEvent)
func HANDLE_TARGETED(event : TargetedEvent) -> void:
	if verbose: print("%s targeted %s" % [event.card, event.who])
	
	var card_stats := IStatisticPossessor.id(event.card)
	card_stats.set_statistic(Genesis.Statistic.HAS_TARGET, true)
	card_stats.set_statistic(Genesis.Statistic.TARGET, event.who)

	if event.card.metadata.type == Genesis.CardType.SUPPORT:
		if game_access.are_two_cards_friendly(event.card, event.who):
			game_access.card_processor.request_event(SupportedEvent.new(event.card, event.who))
			return
	game_access.card_processor.request_event(WasTargetedEvent.new(event.who, event.card))
	return

signal WAS_TARGETED(event : WasTargetedEvent)
func HANDLE_WAS_TARGETED(event : WasTargetedEvent) -> void:
	if verbose: print("%s was targeted by %s" % [event.card, event.by])
	return

signal SUPPORTED(event : SupportedEvent)
func HANDLE_SUPPORTED(event : SupportedEvent) -> void:
	if verbose: print("%s supported %s" % [event.card, event.who])
	game_access.card_processor.request_event(WasSupportedEvent.new(event.who, event.card))
	return

signal WAS_SUPPORTED(event : WasSupportedEvent)
func HANDLE_WAS_SUPPORTED(event : WasSupportedEvent) -> void:
	if verbose: print("%s was supported by %s" % [event.card, event.by])
	return

signal KILLED(event : KilledEvent)
func HANDLE_KILLED(event : KilledEvent) -> void:
	if verbose: print("%s killed %s" % [event.card, event.who])
	game_access.card_processor.request_event(WasKilledEvent.new(event.who, event.card))
	return

signal WAS_KILLED(event : WasKilledEvent)
func HANDLE_WAS_KILLED(event : WasKilledEvent) -> void:
	if verbose: print("%s was killed by %s" % [event.card, event.by])
	game_access.card_processor.request_event(LeftFieldEvent.new(event.card))
	return

signal GAVE_MOOD(event : GaveMoodEvent)
func HANDLE_GAVE_MOOD(event : GaveMoodEvent) -> void:
	if verbose: print("%s gave %s mood %s" % [event.card, event.who, event.mood])
	game_access.card_processor.request_event(GainedMoodEvent.new(event.who, event.card, event.mood))
	return

signal GAINED_MOOD(event : GainedMoodEvent)
func HANDLE_GAINED_MOOD(event : GainedMoodEvent) -> void:
	if verbose: print("%s gained mood %s from %s" % [event.card, event.mood, event.from])
	IMoodPossessor.id(event.card).apply_mood(event.mood)
	return

signal TOOK_MOOD(event : TookMoodEvent)
func HANDLE_TOOK_MOOD(event : TookMoodEvent) -> void:
	if verbose: print("%s took mood %s from %s" % [event.card, event.mood, event.who])
	game_access.card_processor.request_event(LostMoodEvent.new(event.who, event.card, event.mood))
	return

signal LOST_MOOD(event : LostMoodEvent)
func HANDLE_LOST_MOOD(event : LostMoodEvent) -> void:
	if verbose: print("%s lost mood %s from %s" % [event.card, event.mood, event.by])
	IMoodPossessor.id(event.card).remove_mood(event.mood)
	return

signal PLAYED_CARD(event : PlayedCardEvent)
func HANDLE_PLAYED_CARD(event : PlayedCardEvent) -> void:
	if verbose: print("%s played card %s" % [event.card.player, event.card])
	game_access.card_processor.request_event(LeftHandEvent.new(event.card))
	game_access.card_processor.request_event(EnteredFieldEvent.new(event.card))
	return

signal BURNED_HAND(event : BurnedHandEvent)
func HANDLE_BURNED_HAND(event : BurnedHandEvent) -> void:
	if verbose: print("%s burned hand" % [event.card.player])
	return

signal BEGAN_DECK_MAINTENANCE(event : BeganDeckMaintenanceEvent)
func HANDLE_BEGAN_DECK_MAINTENANCE(event : BeganDeckMaintenanceEvent) -> void:
	if verbose: print("%s began deck maintenance" % [event.card.player])
	return

signal ENDED_DECK_MAINTENANCE(event : EndedDeckMaintenanceEvent)
func HANDLE_ENDED_DECK_MAINTENANCE(event : EndedDeckMaintenanceEvent) -> void:
	if verbose: print("%s ended deck maintenance" % [event.card.player])
	return
