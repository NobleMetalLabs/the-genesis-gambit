class_name HandUI
extends Control

var client_ui : ClientUI

@onready var card_stack_container : HBoxContainer = $"CardStack"

func _setup(_client_ui : ClientUI) -> void:
	client_ui = _client_ui
	AuthoritySourceProvider.provider.reflect_action.connect(_handle_hand_action)

func _handle_hand_action(action : Dictionary) -> void:
	if action["type"] != "hand": return
	var action_type : String = action["action"]
	match action_type:
		"add_card":
			_handle_hand_update({
				"type": "add",
				"metadata": CardDB.get_card_by_id(action["data"]["metadata_id"]),
			})
		"burn_hand":
			_handle_hand_update({
				"type": "clear",
			})
		_:
			return

func _handle_hand_update(data : Dictionary) -> void:
	var event_type : String = data["type"]
	print(data)
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

