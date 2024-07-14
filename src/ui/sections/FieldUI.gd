class_name FieldUI
extends Control

@onready var my_player : Player = get_parent().associated_player

var field_cards : Array[CardOnField]

func refresh_field() -> void:
	for card in field_cards:
		card.queue_free()
	field_cards.clear()
	for card in my_player.cards_on_field:
		var card_stats := IStatisticPossessor.id(card)
		var card_on_field : CardOnField = CardOnField.new(card)
		_place_card(card_on_field, card_stats.get_statistic(Genesis.Statistic.POSITION))
		field_cards.append(card_on_field)

func _place_card(card : CardOnField, at_position : Vector2) -> void:
	self.add_child(card, true)
	if get_parent().flipped:
		at_position.y = -at_position.y
	card.position = at_position + self.get_rect().get_center()
	card.card_frontend.mouse_entered.connect(
		func() -> void:
			Router.client_ui.hovered_card = ICardInstance.id(card)
	)
	card.card_frontend.mouse_exited.connect(
		func() -> void:
			Router.client_ui.hovered_card = null
	)
