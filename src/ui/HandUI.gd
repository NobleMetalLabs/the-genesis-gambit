class_name HandUI
extends Control

@onready var card_stack_container : HBoxContainer = $"CardStack"

func _ready() -> void:
	UIEventBus.reflect_action.connect(_handle_ui_event)

func _handle_ui_event(action : Action) -> void:
	if not action is CustomAction: return
	var custom_action := action as CustomAction
	if custom_action.name != "player_hand_changed": return
	_refresh_hand(custom_action.data["player"])

func _refresh_hand(player : Player) -> void:
	_clear_hand()
	for card : CardInHand in player.cards_in_hand:
		_add_card_to_hand(card)

var hovered_hand_card : CardInHand = null

func _add_card_to_hand(card_in_hand : CardInHand) -> void:
	card_stack_container.add_child(card_in_hand, true)
	card_in_hand.mouse_entered.connect(
		func() -> void:
			hovered_hand_card = card_in_hand
	)
	card_in_hand.mouse_exited.connect(
		func() -> void:
			hovered_hand_card = null
	)

func _clear_hand() -> void:
	for child in card_stack_container.get_children():
		card_stack_container.remove_child(child)

