extends CardLogic

static var description : StringName = "Each first attack made by a creature against Moth deals no damage."

var has_been_attacked_by : Array[ICardInstance] = []

func ENTERED_FIELD(event : EnteredFieldEvent) -> void:
	has_been_attacked_by.clear()
	super(event)

func ATTACKED(event : AttackedEvent) -> void:
	if has_been_attacked_by.has(event.who): return
	event.damage = 0
	has_been_attacked_by.append(event.who)
	super(event)
