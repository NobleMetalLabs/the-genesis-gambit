extends CardLogic

static var description : StringName = "Supported creature gains 2 Angry."

var last_supported_creature : ICardInstance

func HANDLE_TARGETED(event: TargetedEvent) -> void:
	if last_supported_creature != null:
		game_access.card_processor.request_event(
			TookMoodEvent.new(owner, last_supported_creature, StatisticMood.ANGRY(owner, 2))
		)
	super(event)

func HANDLE_SUPPORTED(event : SupportedEvent) -> void:
	last_supported_creature = event.who
	
	game_access.card_processor.request_event(
		GaveMoodEvent.new(owner, last_supported_creature, StatisticMood.ANGRY(owner, 2))
	)
	
	super(event)
