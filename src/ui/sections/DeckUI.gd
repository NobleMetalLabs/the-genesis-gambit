class_name DeckUI
extends Control

@onready var remaining_bar : ProgressBar = $"%REMAINING-BAR"
@onready var marked_bar : ProgressBar = $"%MARKED-BAR"
@onready var burn_cooldown_bar : ProgressBar = $"%BURN-COOLDOWN-BAR"
@onready var my_player : Player = get_parent().get_parent().get_parent().associated_player

func _ready() -> void:
	AuthoritySourceProvider.authority_source.new_frame_index.connect(update_burn_cooldown)

func force_refresh_ui() -> void:
	_refresh_deck_ui()

func set_flipped(flipped: bool = false) -> void:
	var bar_fill_mode : int = (ProgressBar.FILL_TOP_TO_BOTTOM if flipped else ProgressBar.FILL_BOTTOM_TO_TOP)
	remaining_bar.fill_mode = bar_fill_mode
	marked_bar.fill_mode = bar_fill_mode
	burn_cooldown_bar.fill_mode = bar_fill_mode

func refresh_card(card_instance : ICardInstance) -> void:
	if card_instance == current_top_card:
		_refresh_deck_ui()
	elif card_instance in my_player.cards_in_deck:
		_refresh_deck_ui()
	else:
		# TODO: these conditions do not cover the end of burning for some reason
		# Heres the hack
		_refresh_deck_ui()

var current_top_card : ICardInstance
var top_card_frontend : CardFrontend

func _refresh_deck_ui() -> void:
	if top_card_frontend: top_card_frontend.queue_free()
	top_card_frontend = CardFrontend.instantiate()
	$"%CARD-HOLDER".add_child(top_card_frontend, true)

	current_top_card = my_player.cards_in_deck.front()
	top_card_frontend.set_card(current_top_card)

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

	top_card_frontend.set_visibility(
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

func update_burn_cooldown(_lol: int) -> void:
	var player_stats := IStatisticPossessor.id(my_player)
	# var burn_cooldown_effect : CooldownEffect = player_stats.get_cooldown_of_type(Genesis.CooldownType.BURN)
	
	# if burn_cooldown_effect == null: return
	# burn_cooldown_bar.max_value = burn_cooldown_effect.total_frames
	# burn_cooldown_bar.value = burn_cooldown_effect.total_frames - burn_cooldown_effect.frames
