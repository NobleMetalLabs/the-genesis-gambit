class_name HandUI
extends Control

@onready var card_stack_container : HBoxContainer = $"CardStack"

var client_ui : ClientUI #TODO: used for client_ui.request_card_ghost() LMAO

func _setup(_client_ui : ClientUI) -> void:
	client_ui = _client_ui
	UIEventBus.reflect_action.connect(_handle_ui_event)

func _handle_ui_event(action : Action) -> void:
	if not action is CustomAction: return
	var custom_action := action as CustomAction
	if custom_action.name != "player_hand_changed": return
	_refresh_hand(custom_action.data["player"])

func _refresh_hand(player : Player) -> void:
	_clear_hand()
	for card in player.hand:
		print("Adding card to hand: ", card.name)
		_add_card_to_hand(card)

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

func _clear_hand() -> void:
	for child in card_stack_container.get_children():
		child.queue_free()

