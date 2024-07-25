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
		_make_card(card)

func refresh_card(ci : ICardInstance) -> void:
	var cof : CardOnField = instance_to_field_card.get(ci)
	if cof != null: 
		field_cards.erase(cof)
		cof.queue_free()
	var new_card : CardOnField = _make_card(ci)
	instance_to_field_card[ci] = new_card 

func _make_card(card : ICardInstance) -> CardOnField:
	var card_on_field : CardOnField = CardOnField.new(card)
	_place_card(
		card_on_field, 
		IStatisticPossessor.id(card)\
			.get_statistic(Genesis.Statistic.POSITION)
	)
	field_cards.append(card_on_field)
	instance_to_field_card[card] = card_on_field
	card_on_field.card_frontend.check_self_for_animation()
	return card_on_field

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
