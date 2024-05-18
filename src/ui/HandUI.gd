class_name HandUI
extends Control

var client_ui : ClientUI

@onready var card_stack_container : HBoxContainer = $"CardStack"

func _setup(_client_ui : ClientUI) -> void:
	client_ui = _client_ui
	AuthoritySourceProvider.authority_source.reflect_action.connect(_handle_hand_action)

func _handle_hand_action(action : Action) -> void:
	if not action is HandAction: return

	if action is HandAddCardAction:
		var add_action : HandAddCardAction = action as HandAddCardAction
		_handle_hand_update({
			"type": "add",
			"metadata": CardDB.get_card_by_id(add_action.card_metadata_id),
		})
	
	if action is HandBurnHandAction:
		_handle_hand_update({
			"type": "clear",
		})

	if action is HandRemoveCardAction:
		var remove_action : HandRemoveCardAction = action as HandRemoveCardAction
		_handle_hand_update({
			"type": "remove",
			"instance": remove_action.card,
		})

func _handle_hand_update(data : Dictionary) -> void:
	var event_type : String = data["type"]
	match event_type:
		"add":
			_add_card_to_hand(data["metadata"])
		"remove":
			_remove_card_from_hand(data["instance"])
		"clear":
			_clear_hand()

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

