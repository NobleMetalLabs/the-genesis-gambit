class_name PlayerAreaUI
extends Panel

var associated_player : Player

@onready var hand_ui : HandUI = $"%HAND-UI"
@onready var field_card_holder : Control = $"FIELD-HOLDER"

var flipped : bool :
	get: return flipped
	set(value): 
		flipped = value
		hand_ui.get_parent().set_anchors_preset(PRESET_CENTER_TOP if flipped else PRESET_CENTER_BOTTOM)
		hand_ui.get_parent().position.y = 0 #I LOVE GODOT ENGINE!!!!

func get_leader_position() -> Vector2:
	var r : Rect2i = self.get_rect()
	var c : Vector2 = r.get_center()
	return c + (Vector2(0, r.size.y / 2) * (-1 if flipped else 1))

func get_hovered_card() -> ICardInstance:
	var gamefield := Router.gamefield #why do this?
	var gc : ICardInstance = ICardInstance.id(gamefield.get_hovered_card())
	var hnd : ICardInstance = ICardInstance.id(hand_ui.hovered_hand_card)
	if gc != null: return gc
	if hnd != null: return hnd
	return null

func refresh_hand_ui() -> void:
	hand_ui._refresh_hand()