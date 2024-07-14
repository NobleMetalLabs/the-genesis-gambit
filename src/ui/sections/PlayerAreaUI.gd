class_name PlayerAreaUI
extends Panel

var associated_player : Player

@onready var hand_ui : HandUI = $"%HAND-UI"
@onready var field_ui : FieldUI = $"%FIELD-UI"

var flipped : bool :
	get: return flipped
	set(value): 
		flipped = value
		hand_ui.get_parent().set_anchors_preset(PRESET_CENTER_TOP if flipped else PRESET_CENTER_BOTTOM)
		hand_ui.get_parent().position.y = 0 #I LOVE GODOT ENGINE!!!!

func refresh_ui() -> void:
	hand_ui.refresh_hand()
	field_ui.refresh_field()
