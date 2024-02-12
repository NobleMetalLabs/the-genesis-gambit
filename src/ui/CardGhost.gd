class_name CardGhost
extends Control

signal was_placed(global_position : Vector2)
signal was_canceled()

var metadata : CardMetadata :
	get:
		return ICardInstance.id(self).metadata
	set(value):
		ICardInstance.id(self).metadata = value

@onready var texture_rect : TextureRect = $TextureRect
@onready var border_component : CardBorderComponent = $TextureRect/CardBorderComponent
var card_in_hand_mirror : CardInHand

func _ready() -> void:
	texture_rect.texture = metadata.image
	border_component.set_rarity(metadata.rarity)

func _setup(_hand_mirror : CardInHand, _metadata : CardMetadata) -> void:
	card_in_hand_mirror = _hand_mirror
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
	var value : bool = card_in_hand_mirror.hand_ui.get_global_rect().intersects(self.get_global_rect())
	return value

func _process(_delta : float) -> void:
	position = get_global_mouse_position()
	var is_vis : bool = _is_in_hand_region()
	visible = not is_vis
	card_in_hand_mirror.visible = is_vis
