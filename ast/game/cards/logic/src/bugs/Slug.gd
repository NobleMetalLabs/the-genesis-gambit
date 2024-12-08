extends CardLogic

static var description : StringName = "Supported creature is covered in ooze. Attacks made against the creature inflict the attacker with slow."

var last_supported_creature : ICardInstance

func HANDLE_SUPPORTED(event : SupportedEvent) -> void:
	if last_supported_creature != null:
		last_supported_creature.logic.WAS_ATTACKED.disconnect(HANDLE_WAS_ATTACKED_ON_SUPPORTED)
	last_supported_creature = event.who
	last_supported_creature.logic.WAS_ATTACKED.connect(HANDLE_WAS_ATTACKED_ON_SUPPORTED)
	super(event)

func HANDLE_WAS_ATTACKED_ON_SUPPORTED(event : WasAttackedEvent) -> void:
	game_access.card_processor.request_event(
		GaveMoodEvent.new(owner, event.by_who, StatisticMood.SLOW(owner))
	)
