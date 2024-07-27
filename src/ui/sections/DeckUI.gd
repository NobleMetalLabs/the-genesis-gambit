class_name DeckUI
extends Control


@onready var remaining_bar : ProgressBar = $"%REMAINING-BAR"
@onready var marked_bar : ProgressBar = $"%MARKED-BAR"
@onready var my_player : Player = get_parent().get_parent().get_parent().associated_player

var card_frontend : CardFrontend
func refresh_deck_ui() -> void:
	if card_frontend: card_frontend.queue_free()
	card_frontend = CardFrontend.instantiate()
	$"%CARD-HOLDER".add_child(card_frontend, true)

	card_frontend.set_card(my_player.cards_in_deck.front())

	var card_face_is_visible : bool = false
	var card_rarity_is_visible : bool = false
	var card_type_is_visible : bool = false
	var my_player_stats := IStatisticPossessor.id(my_player)
	if my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE):
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_RARITY_ONLY)
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	elif my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_TO_OPPONENTS):
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_TO_OPPONENTS_RARITY_ONLY)
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_TO_OPPONENTS_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	elif Router.backend.local_player in my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_PLAYERS):
		card_rarity_is_visible = my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_TO_OPPONENTS_RARITY_ONLY)
		card_type_is_visible = my_player_stats.get_statistic(Genesis.Statistic.DECK_TOPCARD_VISIBLE_TO_OPPONENTS_TYPE_ONLY)
		card_face_is_visible = not (card_rarity_is_visible or card_type_is_visible)
	if card_face_is_visible:
		card_rarity_is_visible = true
		card_type_is_visible = true

	card_frontend.set_visibility(
		card_face_is_visible,
		card_rarity_is_visible,
		card_type_is_visible
	)

	var player_stats := IStatisticPossessor.id(my_player)
	var num_cards : int = player_stats.get_statistic(Genesis.Statistic.NUM_CARDS)
	var num_marked : int = player_stats.get_statistic(Genesis.Statistic.NUM_CARDS_MARKED_IN_DECK)
	var num_remaining : int = player_stats.get_statistic(Genesis.Statistic.NUM_CARDS_LEFT_IN_DECK)
	remaining_bar.max_value = num_cards
	remaining_bar.value = num_remaining
	marked_bar.max_value = num_cards
	marked_bar.value = num_marked



