class_name FieldUI
extends Control

@onready var my_player : Player = get_parent().associated_player
@onready var cursor : PlayerCursorUI = $"%PLAYER-CURSOR"

func force_refresh_ui() -> void:
	_refresh_field()

func refresh_card(ci : ICardInstance) -> void:
	if ci in _instance_to_field_card.keys():
		if ci in my_player.cards_on_field:
			_instance_to_field_card[ci].card_frontend.check_self_for_animation()
		else:
			_remake_card(ci)
	elif ci in my_player.cards_on_field:
		_remake_card(ci)

var _field_cards : Array[CardOnField]
var _instance_to_field_card : Dictionary = {} #[ICardInstance, CardOnField]

func _refresh_field() -> void:
	for card in _field_cards:
		card.queue_free()
	_field_cards.clear()
	for card in my_player.cards_on_field:
		_make_card(card)

func _remake_card(card : ICardInstance) -> void:
	var cof : CardOnField = _instance_to_field_card.get(card)
	if cof != null: 
		_field_cards.erase(cof)
		cof.queue_free()
	var new_card : CardOnField = _make_card(card)
	_instance_to_field_card[card] = new_card

func _make_card(card : ICardInstance) -> CardOnField:
	var card_on_field : CardOnField = CardOnField.new(card)
	_place_card(
		card_on_field, 
		IStatisticPossessor.id(card)\
			.get_statistic(Genesis.Statistic.POSITION)
	)
	_field_cards.append(card_on_field)
	_instance_to_field_card[card] = card_on_field
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
