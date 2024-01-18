class_name CardInstanceInHand
extends CardInstance

@onready var texture_rect : TextureRect = $TextureRect
var hand_ui : HandUI

func _ready() -> void:
	texture_rect.texture = metadata.image

func _setup(_hand_ui : HandUI, _metadata : CardMetadata) -> void:
	hand_ui = _hand_ui
	metadata = _metadata

func _input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return

	var new_temp_card : TempCard = hand_ui.client_ui.request_temp_card(self)
	new_temp_card.was_placed.connect(
		func(_position : Vector2) -> void:
			var gamefield : Gamefield = hand_ui.client_ui.gamefield
			gamefield.place_card(gamefield.get_own_player(), new_temp_card.metadata, _position)
			hand_ui._remove_card_from_hand(self)
	)
	new_temp_card.was_canceled.connect(
		func() -> void:
			self.visible = true
	)
