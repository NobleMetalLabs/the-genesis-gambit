class_name CardGhost
extends Control

#TODO: maybe rework this to use Control._get_drag_data()/set_data_preview()/_drop_data()

signal was_placed(global_position : Vector2)
signal was_canceled()

var card_in_hand_mirror : CardInHand
var card_frontend : CardFrontend

func _init(card_in_hand : CardInHand) -> void:
	card_in_hand_mirror = card_in_hand
	self.add_child(ICardInstance.id(card_in_hand).clone())

	card_frontend = card_in_hand.card_frontend.duplicate()
	self.add_child(card_frontend)
	card_frontend.modulate = Color(1, 1, 1, 0.5)

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
	follow_cursor = false

func _is_in_hand_region() -> bool:
	var value : bool = Router.client_ui.local_player_area.hand_ui.get_global_rect().intersects(self.get_global_rect())
	return value

var follow_cursor : bool = true

func _process(_delta : float) -> void:
	if not follow_cursor: return
	position = get_global_mouse_position()
	var is_vis : bool = _is_in_hand_region()
	visible = not is_vis
	card_in_hand_mirror.visible = is_vis
