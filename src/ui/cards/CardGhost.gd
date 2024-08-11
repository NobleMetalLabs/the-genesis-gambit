class_name CardGhost
extends Control

#TODO: maybe rework this to use Control._get_drag_data()/set_data_preview()/_drop_data()

signal was_placed(global_position : Vector2)
signal was_canceled()
signal was_denied()

var hand_ui : HandUI
var card_frontend : CardFrontend
var card_backend : ICardInstance

func _init(card : ICardInstance, _hand_ui : HandUI) -> void:
	hand_ui = _hand_ui
	var card_in_hand : CardInHand = hand_ui._card_in_hand_map[card]
	card_backend = card_in_hand.card_backend

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
	var energy_cost : int = IStatisticPossessor.id(card_backend).get_statistic(Genesis.Statistic.ENERGY)
	var player_stats := IStatisticPossessor.id(card_backend.player)
	
	if player_stats.get_statistic(Genesis.Statistic.ENERGY) + energy_cost > player_stats.get_statistic(Genesis.Statistic.MAX_ENERGY):
		self.was_denied.emit()
		_cancel()
		return
	
	self.was_placed.emit(self.position - Router.client_ui.local_player_area.field_ui.get_rect().get_center())
	follow_cursor = false

func _is_in_hand_region() -> bool:
	var value : bool = Router.client_ui.local_player_area.hand_ui.get_global_rect().intersects(self.get_global_rect())
	return value

var follow_cursor : bool = true

func _process(_delta : float) -> void:
	if not follow_cursor: return
	position = get_parent().get_local_mouse_position()
	var is_vis : bool = _is_in_hand_region()
	visible = not is_vis
	hand_ui._card_in_hand_map[card_backend].visible = is_vis
