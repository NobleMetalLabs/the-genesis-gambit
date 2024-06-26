class_name CardInHand
extends Control

#implements ITargetable
func get_boundary_rectangle() -> Rect2:
	return card_frontend.texture_rect.get_global_rect()

var card_frontend : CardFrontend

func _init(provided_identifiers : Array[Identifier]) -> void:
	for identifier in provided_identifiers:
		var old_parent : Node = identifier.get_parent()
		if old_parent != null: 
			identifier.reparent(self)
			old_parent.add_child(identifier.clone())
		else: 
			self.add_child(identifier)

	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is ICardInstance):
		push_error("CardInHand must be provided with ICardInstance identifier.")
		return
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is ITargetable): 
		self.add_child(ITargetable.new())
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is IStatisticPossessor): 
		self.add_child(IStatisticPossessor.new())
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is IMoodPossessor): 
		self.add_child(IMoodPossessor.new())

	card_frontend = CardFrontend.instantiate()
	self.add_child(card_frontend)

	self.name = "CardInHand"

func _to_string() -> String:
	return "CardInHand<%s>" % ICardInstance.id(self)

func _gui_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return

	Router.client_ui._create_card_ghost(self)
