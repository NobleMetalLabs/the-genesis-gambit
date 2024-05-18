class_name HandUI
extends Control

@onready var card_stack_container : HBoxContainer = $"CardStack"

var client_ui : ClientUI #TODO: used for client_ui.request_card_ghost() LMAO

func _setup(_client_ui : ClientUI) -> void:
	client_ui = _client_ui
	AuthoritySourceProvider.authority_source.reflect_action.connect(_handle_hand_action)

func _handle_hand_action(action : Action) -> void:
	if not action is HandAction: return

	if action is HandAddCardAction:
		var add_action : HandAddCardAction = action as HandAddCardAction
		_add_card_to_hand(CardDB.get_card_by_id(add_action.card_metadata_id))
	
	if action is HandBurnHandAction:
		_clear_hand()

	if action is HandRemoveCardAction:
		var remove_action : HandRemoveCardAction = action as HandRemoveCardAction
		_remove_card_from_hand(remove_action.card)

var hovered_hand_card : CardInHand = null

func _add_card_to_hand(metadata : CardMetadata) -> void:
	var new_hand_card : CardInHand = ObjectDB._CardInHand.create(self, metadata)
	card_stack_container.add_child(new_hand_card, true)
	new_hand_card.mouse_entered.connect(
		func() -> void:
			hovered_hand_card = new_hand_card
	)
	new_hand_card.mouse_exited.connect(
		func() -> void:
			hovered_hand_card = null
	)

func _remove_card_from_hand(_instance : CardInHand) -> void:
	_instance.queue_free()

func _clear_hand() -> void:
	for child in card_stack_container.get_children():
		child.queue_free()

