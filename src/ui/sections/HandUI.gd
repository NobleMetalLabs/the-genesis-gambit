class_name HandUI
extends Control

@onready var my_player : Player = get_parent().get_parent().associated_player

func force_refresh_ui() -> void:
	_refresh_hand()

func refresh_card(card : ICardInstance) -> void:
	if card in _displayed_cards:
		if card in my_player.cards_in_hand:
			_refresh_card_in_hand(_card_in_hand_map[card])
		else:
			_remove_card_in_hand(_card_in_hand_map[card])
	elif card in my_player.cards_in_hand:
		_add_card_to_hand(card)
	else:
		refresh_energy_bar()

func _refresh_hand() -> void:
	_clear_hand()
	for card : ICardInstance in my_player.cards_in_hand:
		_add_card_to_hand(card)
	refresh_energy_bar()

@onready var card_stack_container : HBoxContainer = $"CardStack"
var _displayed_cards : Array[ICardInstance] = []
var _card_in_hand_map : Dictionary = {} #[ICardInstance, CardInHand]

func _add_card_to_hand(card_instance : ICardInstance) -> void:
	_displayed_cards.append(card_instance)
	var card_in_hand := CardInHand.new(card_instance)
	card_stack_container.add_child(card_in_hand, true)

	_refresh_card_in_hand(card_in_hand)

	card_in_hand.mouse_entered.connect(
		func() -> void:
			Router.client_ui.hovered_card = card_in_hand.card_backend
	)
	card_in_hand.mouse_exited.connect(
		func() -> void:
			Router.client_ui.hovered_card = null
	)

	_card_in_hand_map[card_instance] = card_in_hand

func _refresh_card_in_hand(card_in_hand : CardInHand) -> void:
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

	card_in_hand.card_frontend.check_self_for_animation()

func _remove_card_in_hand(card_in_hand : CardInHand) -> void:
	_card_in_hand_map.erase(card_in_hand.card_backend)
	_displayed_cards.erase(card_in_hand.card_backend)
	card_in_hand.queue_free()

func _clear_hand() -> void:
	_displayed_cards.clear()
	_card_in_hand_map.clear()
	for child : CardInHand in card_stack_container.get_children():
		Router.client_ui.deassign_card_frontend(child.card_backend)
		child.queue_free()

func _create_card_ghost(hand_card : CardInHand) -> void:
	var new_card_ghost := CardGhost.new(hand_card.card_backend, self)
	Router.client_ui.local_player_area.field_ui.add_child(new_card_ghost, true)
	
	new_card_ghost.was_placed.connect(
		func(_position : Vector2) -> void:
			var card_instance : ICardInstance = hand_card.card_backend
			AuthoritySourceProvider.authority_source.request_action(
				HandPlayCardAction.setup(card_instance, _position)
			)
			new_card_ghost.queue_free()
	)
	
	new_card_ghost.was_canceled.connect(_refresh_hand)
	new_card_ghost.was_denied.connect(need_energy_animation)

@onready var energy_bar : ProgressBar = $"EnergyBar"
@onready var energy_value_label : Label = $"%ValueLabel"

func need_energy_animation() -> void:
	var flash_tween : Tween = get_tree().create_tween()
	flash_tween.tween_property(energy_value_label, "modulate", Color(1, 0, 0, 1), 0)
	flash_tween.tween_property(energy_value_label, "modulate", Color(1, 1, 1, 1), 0.5)
	
	var wiggle_tween : Tween = get_tree().create_tween()
	wiggle_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	wiggle_tween.tween_property(energy_value_label, "position:x", 5, 0.05)
	wiggle_tween.tween_property(energy_value_label, "position:x", -5, 0.05)
	wiggle_tween.tween_property(energy_value_label, "position:x", 5, 0.05)
	wiggle_tween.tween_property(energy_value_label, "position:x", -5, 0.05)
	wiggle_tween.tween_property(energy_value_label, "position:x", 0, 0.1)

func refresh_energy_bar() -> void:
	var player_stats := IStatisticPossessor.id(my_player)
	
	energy_bar.max_value = player_stats.get_statistic(Genesis.Statistic.MAX_ENERGY)
	energy_bar.value = player_stats.get_statistic(Genesis.Statistic.ENERGY)
	energy_bar.get_node("ValueLabel").text = "%d/%d" % [energy_bar.value, energy_bar.max_value]
