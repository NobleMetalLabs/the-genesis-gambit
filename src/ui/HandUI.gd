class_name HandUI
extends Control

@onready var card_stack_container : HBoxContainer = $"CardStack"

func _refresh_hand() -> void:
	_clear_hand()
	for card : CardInHand in get_parent().get_parent().associated_player.cards_in_hand:
		_add_card_to_hand(card)

var hovered_hand_card : ICardInstance = null

func _add_card_to_hand(card_in_hand : CardInHand) -> void:
	card_stack_container.add_child(card_in_hand, true)
	card_in_hand.mouse_entered.connect(
		func() -> void:
			hovered_hand_card = ICardInstance.id(card_in_hand)
	)
	card_in_hand.mouse_exited.connect(
		func() -> void:
			hovered_hand_card = null
	)

func _clear_hand() -> void:
	for child in card_stack_container.get_children():
		card_stack_container.remove_child(child)

