class_name PlayerAreaUI
extends Panel

var associated_player : Player

@onready var hand_ui : HandUI = $"%HAND-UI"
@onready var field_card_holder : Control = $"%FIELD-HOLDER"

var flipped : bool :
	get: return flipped
	set(value): 
		flipped = value
		hand_ui.get_parent().set_anchors_preset(PRESET_CENTER_TOP if flipped else PRESET_CENTER_BOTTOM)
		hand_ui.get_parent().position.y = 0 #I LOVE GODOT ENGINE!!!!

func place_card(card : CardOnField, at_position : Vector2) -> void:
	field_card_holder.add_child(card, true)
	card.position = at_position - field_card_holder.get_rect().get_center()

	card.card_frontend.mouse_entered.connect(
		func() -> void:
			Router.client_ui.hovered_card = ICardInstance.id(card)
	)
	card.card_frontend.mouse_exited.connect(
		func() -> void:
			Router.client_ui.hovered_card = null
	)

func get_leader_position() -> Vector2:
	return self.get_rect().get_center()

func refresh_hand_ui() -> void:
	hand_ui._refresh_hand()