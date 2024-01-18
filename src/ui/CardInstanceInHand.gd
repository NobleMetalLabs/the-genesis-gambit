class_name CardInstanceInHand
extends CardInstance

@onready var texture_rect : TextureRect = $TextureRect
@onready var hand_ui : HandUI = self.get_parent()

func _ready() -> void:
	texture_rect.texture = metadata.image

func _setup(_metadata : CardMetadata) -> void:
	metadata = _metadata

func _input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return

	var new_temp_card : TempCard = hand_ui.client_ui.request_temp_card(metadata)
	self.visible = false

	new_temp_card.was_placed.connect(
		func() -> void:
			hand_ui._remove_card_from_hand(self)
	)
	new_temp_card.was_canceled.connect(
		func() -> void:
			self.visible = true
	)
