extends CardLogic

static var description : StringName = "Each first attack made by a creature against Moth deals no damage."

var has_been_attacked_by : Array[ICardInstance] = []

func HANDLE_ENTERED_FIELD(event : EnteredFieldEvent) -> void:
	has_been_attacked_by.clear()
	super(event)

func HANDLE_WAS_ATTACKED(event : WasAttackedEvent) -> void:
	if not has_been_attacked_by.has(event.by_who):
		event.damage = 0
		has_been_attacked_by.append(event.by_who)
	super(event)
