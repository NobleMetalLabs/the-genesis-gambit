extends CardLogic

static var description : StringName = "Targeted creature is covered in ooze. Attacks made against the creature inflict the attacker with slow."

var last_targeted_creature : ICardInstance

func HANDLE_TARGETED(event : TargetedEvent) -> void:
	if last_targeted_creature != null:
		last_targeted_creature.logic.WAS_ATTACKED.disconnect(HANDLE_WAS_ATTACKED_ON_TARGET)
	last_targeted_creature = event.target
	last_targeted_creature.logic.WAS_ATTACKED.connect(HANDLE_WAS_ATTACKED_ON_TARGET)
	super(event)

func HANDLE_WAS_ATTACKED_ON_TARGET(event : WasAttackedEvent) -> void:
	game_access.card_processor.request_event(
		GaveMoodEvent.new(event.by_who, owner, StatisticMood.SLOW(owner))
	)
