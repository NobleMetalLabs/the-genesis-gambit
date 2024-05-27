class_name CardInHand
extends Control

#implements ITargetable
func get_boundary_rectangle() -> Rect2:
	return card_frontend.texture_rect.get_global_rect()

var card_frontend : CardFrontend

func _init(provided_identifiers : Array[Identifier]) -> void:
	for identifier in provided_identifiers:
		print("added identifier: %s" % identifier)
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
	
func _gui_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return

	# var new_card_ghost : CardGhost = hand_ui.client_ui.request_card_ghost(ICardInstance.id(self))
	# new_card_ghost.was_placed.connect(
	# 	func(_position : Vector2) -> void:
	# 		var gamefield : Gamefield = hand_ui.client_ui.gamefield
	# 		var new_card : CardOnField = ObjectDB._CardOnField.create(gamefield, new_card_ghost.metadata)
	# 		AuthoritySourceProvider.authority_source.request_action(
	# 			CreatureSpawnAction.new(
	# 				new_card,
	# 				_position,
	# 			)
	# 		)
	# 		AuthoritySourceProvider.authority_source.request_action(
	# 			HandRemoveCardAction.new(
	# 				Player.new(),
	# 				self,
	# 				HandRemoveCardAction.LeaveReason.PLAYED,
	# 				HandRemoveCardAction.CardRemoveAnimation.PLAY,
	# 			)
	# 		)
	# )
