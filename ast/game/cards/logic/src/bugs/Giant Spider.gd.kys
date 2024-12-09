extends CardLogic

static var description : StringName = "When Giant Spider damages an attacker, that attacker receives Slow."

func HANDLE_ATTACKED(event: AttackedEvent):
	if event.who.metadata.type == Genesis.CardType.ATTACKER:
		game_access.card_processor.request_event(
			GaveMoodEvent.new(owner, event.who, StatisticMood.SLOW(owner))
		)
	
	super(event)
