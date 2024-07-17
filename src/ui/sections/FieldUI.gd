class_name FieldUI
extends Control

@onready var my_player : Player = get_parent().associated_player
@onready var cursor : PlayerCursorUI = $"%PLAYER-CURSOR"

var field_cards : Array[CardOnField]
var instance_to_field_card : Dictionary = {} #[ICardInstance, CardOnField]

func refresh_field() -> void:
	for card in field_cards:
		card.queue_free()
	field_cards.clear()
	for card in my_player.cards_on_field:
		var card_stats := IStatisticPossessor.id(card)
		var card_on_field : CardOnField = CardOnField.new(card)
		_place_card(card_on_field, card_stats.get_statistic(Genesis.Statistic.POSITION))
		field_cards.append(card_on_field)
		instance_to_field_card[card] = card_on_field
		check_card_for_animation(card, card_on_field)

func check_card_for_animation(card : ICardInstance, field_card : CardOnField) -> void:
	var card_stats := IStatisticPossessor.id(card)

	if card_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		var flash_tween : Tween = Router.get_tree().create_tween()
		flash_tween.tween_property(field_card, "modulate", Color(0, 1, 0, 1), 0)
		flash_tween.tween_property(field_card, "modulate", Color(1, 1, 1, 1), 0.5)

# TODO?: Convert positions to fractional coordinates to guarantee half-decent scaling at any res?
func _place_card(card : CardOnField, at_position : Vector2) -> void:
	self.add_child(card, true)
	if get_parent().flipped:
		at_position.y = -at_position.y
	card.position = at_position
	card.card_frontend.mouse_entered.connect(
		func() -> void:
			Router.client_ui.hovered_card = card.card_backend
	)
	card.card_frontend.mouse_exited.connect(
		func() -> void:
			Router.client_ui.hovered_card = null
	)
