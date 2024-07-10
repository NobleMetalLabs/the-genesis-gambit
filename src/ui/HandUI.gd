class_name HandUI
extends Control

@onready var card_stack_container : HBoxContainer = $"CardStack"
@onready var my_player : Player = get_parent().get_parent().associated_player

func _refresh_hand() -> void:
	_clear_hand()
	for card : CardInHand in my_player.cards_in_hand:
		_add_card_to_hand(card)

var hovered_hand_card : ICardInstance = null

func _add_card_to_hand(card_in_hand : CardInHand) -> void:
	card_stack_container.add_child(card_in_hand, true)
	var card_face_is_visible : bool = false
	var card_rarity_is_visible : bool = false
	var card_type_is_visible : bool = false
	var my_player_stats := IStatisticPossessor.id(my_player)
	if my_player == Router.gamefield.local_player: 
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_RARITY_ONLY)
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	elif my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS):
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS_RARITY_ONLY)
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	elif Router.gamefield.local_player in my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_PLAYERS):
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS_RARITY_ONLY)
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	if card_face_is_visible:
		card_rarity_is_visible = true
		card_type_is_visible = true

	card_in_hand.card_frontend.set_visibility(
		card_face_is_visible,
		card_rarity_is_visible,
		card_type_is_visible
	)

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

