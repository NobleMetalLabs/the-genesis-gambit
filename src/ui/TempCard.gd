class_name TempCard
extends CardInstance

signal was_placed(global_position : Vector2)
signal was_canceled()

@onready var texture_rect : TextureRect = $TextureRect
var card_instance_in_hand_mirror : CardInstanceInHand

func _ready() -> void:
	texture_rect.texture = metadata.image

func _setup(_hand_mirror : CardInstanceInHand, _metadata : CardMetadata) -> void:
	card_instance_in_hand_mirror = _hand_mirror
	metadata = _metadata

func _input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		if visible: _place()
		else: _cancel()
	if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_cancel()

func _cancel() -> void:
	self.was_canceled.emit()
	self.queue_free()

func _place() -> void:
	self.was_placed.emit(self.global_position)
	self.queue_free()

func _is_in_hand_region() -> bool:
	var value : bool = card_instance_in_hand_mirror.hand_ui.get_global_rect().intersects(self.get_global_rect())
	return value

func _process(_delta : float) -> void:
	position = get_global_mouse_position()
	var is_vis : bool = _is_in_hand_region()
	visible = not is_vis
	card_instance_in_hand_mirror.visible = is_vis
