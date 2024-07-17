class_name HandUI
extends Control

@onready var card_stack_container : HBoxContainer = $"CardStack"
@onready var my_player : Player = get_parent().get_parent().associated_player

func _create_card_ghost(hand_card : CardInHand) -> void:
	var new_card_ghost := CardGhost.new(hand_card)
	Router.client_ui.local_player_area.field_ui.add_child(new_card_ghost, true)
	
	new_card_ghost.was_placed.connect(
		func(_position : Vector2) -> void:
			var card_instance : ICardInstance = hand_card.card_backend
			AuthoritySourceProvider.authority_source.request_action(
				HandPlayCardAction.setup(card_instance, _position)
			)
			new_card_ghost.queue_free()
	)

func refresh_hand() -> void:
	_clear_hand()
	for card : ICardInstance in my_player.cards_in_hand:
		_add_card_to_hand(card)

func _add_card_to_hand(card_instance : ICardInstance) -> void:
	var card_in_hand := CardInHand.new(card_instance)
	card_stack_container.add_child(card_in_hand, true)
	var card_face_is_visible : bool = false
	var card_rarity_is_visible : bool = false
	var card_type_is_visible : bool = false
	var my_player_stats := IStatisticPossessor.id(my_player)
	if my_player == Router.backend.local_player: 
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_RARITY_ONLY)
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	elif my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS):
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS_RARITY_ONLY)
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_TO_OPPONENTS_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	elif Router.backend.local_player in my_player_stats.get_statistic(Genesis.Statistic.HAND_VISIBLE_PLAYERS):
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

	var card_stats := IStatisticPossessor.id(card_instance)	
	card_in_hand.card_frontend.set_overlays(
		card_stats.get_statistic(Genesis.Statistic.IS_MARKED),
		card_stats.get_statistic(Genesis.Statistic.IS_FROZEN)
	)	

	check_card_for_animation(card_instance, card_in_hand)

	card_in_hand.mouse_entered.connect(
		func() -> void:
			Router.client_ui.hovered_card = ICardInstance.id(card_in_hand)
	)
	card_in_hand.mouse_exited.connect(
		func() -> void:
			Router.client_ui.hovered_card = null
	)
	
func check_card_for_animation(card : ICardInstance, hand_card : CardInHand) -> void:
	var card_stats := IStatisticPossessor.id(card)
	if card_stats.get_statistic(Genesis.Statistic.WAS_JUST_BURNED):
		var burn_tween : Tween = Router.get_tree().create_tween()
		burn_tween.tween_property(hand_card, "modulate", Color(1, 0.4, 0, 1), 0.2)
		burn_tween.parallel().tween_interval(0.1)
		burn_tween.tween_property(hand_card, "modulate", Color(0, 0, 0, 1), 0.3)
		burn_tween.tween_property(hand_card, "modulate", Color(0, 0, 0, 0), 1)


func _clear_hand() -> void:
	for child in card_stack_container.get_children():
		card_stack_container.remove_child(child)

