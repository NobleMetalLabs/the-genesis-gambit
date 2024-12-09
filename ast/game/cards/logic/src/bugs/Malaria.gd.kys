extends CardLogic

static var description : StringName = "Targeted creature is inflicted with Sick."

var targeted_creature : ICardInstance
func HANDLE_ENTERED_FIELD(event: EnteredFieldEvent) -> void:
	if targeted_creature != null: CAST()
	super(event)

func HANDLE_TARGETED(event: TargetedEvent) -> void:
	targeted_creature = event.who
	
	var my_stats := IStatisticPossessor.id(owner)
	if my_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD): CAST()
	super(event)

func CAST() -> void:
	game_access.card_processor.request_event(
		GaveMoodEvent.new(owner, targeted_creature, StatisticMood.SICK(owner))
	)
	
	game_access.card_processor.request_event(
		KilledEvent.new(owner, owner)
	)
