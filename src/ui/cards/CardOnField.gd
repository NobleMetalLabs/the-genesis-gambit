class_name CardOnField
extends Control

var card_frontend : CardFrontend
var card_backend : ICardInstance

func _init(backend : ICardInstance) -> void:
	self.card_backend = backend

	card_frontend = CardFrontend.instantiate()
	self.add_child(card_frontend)
	self.set_anchors_preset(PRESET_FULL_RECT)
	self.set_size(Vector2.ZERO)
	self.name = "CardOnField"

	Router.client_ui.assign_card_frontend(card_backend, card_frontend)
	
func _to_string() -> String:
	return "CardOnField<%s>" % card_backend

func _ready() -> void:
	self.mouse_filter = MOUSE_FILTER_IGNORE

	if IStatisticPossessor.id(card_backend).get_statistic(Genesis.Statistic.CAN_TARGET):
		if card_backend.player == Router.backend.local_player:
			card_frontend.gui_input.connect(
				func (event : InputEvent) -> void:
					if not event is InputEventMouseButton: return
					if event.button_index == MOUSE_BUTTON_LEFT:
						if event.pressed: start_drag()
						get_viewport().set_input_as_handled()
					if event.button_index == MOUSE_BUTTON_RIGHT:
						if event.pressed: start_target()
						get_viewport().set_input_as_handled()
			)
	
	target_arrow.z_index = 2
	target_arrow.modulate = Genesis.COLOR_BY_CARDTYPE[card_backend.metadata.type]
	add_child(target_arrow)
	
var dragging : bool = false

var selecting_target : bool = false
var target_arrow : Arrow2D = Arrow2D.new()

func _process(_delta : float) -> void:
	if dragging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()
	
	var target : ICardInstance = IStatisticPossessor.id(card_backend).get_statistic(Genesis.Statistic.TARGET)
	target_arrow.visible = (target != null or selecting_target)

	target_arrow.start_position = card_frontend.get_rect().get_center()
	if selecting_target:
		target_arrow.end_position = get_global_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			end_target()
	elif target != null:
		var target_frontend : CardFrontend = Router.client_ui.get_card_frontend(target)
		if target_frontend == null:
			push_warning("No registered frontend for target card %s" % target)
			return
		var target_rect : Rect2 = target_frontend.get_global_rect()
		target_arrow.end_position = target_rect.get_center()

func start_drag() -> void:
	dragging = true

func end_drag() -> void:
	dragging = false

func start_target() -> void:
	selecting_target = true

func end_target() -> void:
	selecting_target = false
	AuthoritySourceProvider.authority_source.request_action(
		CreatureTargetAction.setup(
			card_backend, Router.client_ui.hovered_card
		)
	)
