class_name CardOnField
extends Node2D

#implements ITargetable
func get_boundary_rectangle() -> Rect2:
	return card_frontend.get_global_rect()

var gamefield : Gamefield
var card_frontend : CardFrontend

func _init(provided_identifiers : Array[Identifier]) -> void:
	for identifier in provided_identifiers:
		var old_parent : Node = identifier.get_parent()
		if old_parent != null: 
			identifier.reparent(self)
			old_parent.add_child(identifier.clone())
		else: 
			self.add_child(identifier)

	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is ICardInstance):
		push_error("CardOnField must be provided with ICardInstance identifier.")
		return
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is ITargetable): 
		self.add_child(ITargetable.new())
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is IStatisticPossessor): 
		self.add_child(IStatisticPossessor.new())
	if not provided_identifiers.any(func(i : Identifier) -> bool: return i is IMoodPossessor): 
		self.add_child(IMoodPossessor.new())

	self.gamefield = Router.gamefield

	card_frontend = CardFrontend.instantiate()
	self.add_child(card_frontend)

	self.name = "CardOnField"
	
func _to_string() -> String:
	return "CardOnField<%s>" % ICardInstance.id(self)

func _ready() -> void:
	card_frontend.gui_input.connect(
		func (event : InputEvent) -> void:
			if not event is InputEventMouseButton: return
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed: start_drag() 
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.pressed: start_target()
			get_viewport().set_input_as_handled()
	)
	
	target_arrow.z_index = 2
	target_arrow.modulate = Color.RED
	add_child(target_arrow)
	
var dragging : bool = false
var dragging_offset : Vector2 = Vector2.ZERO

var selecting_target : bool = false
var target : ITargetable = null
var target_arrow : Arrow2D = Arrow2D.new()

func _process(_delta : float) -> void:
	if dragging:
		self.position = get_parent().get_local_mouse_position() + dragging_offset
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()
	
	target_arrow.visible = (target != null or selecting_target)
	
	var self_rect : Rect2 = self.get_boundary_rectangle()
	if selecting_target:
		target_arrow.position = Utils.get_vector_to_rectangle_edge_at_angle(self_rect, get_local_mouse_position().angle())
		target_arrow.end_position = get_parent().get_local_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			end_target()
	elif target != null:
		var target_rect : Rect2 = target.get_boundary_rectangle()
		var target_dir_angle : float = self_rect.get_center().angle_to_point(target_rect.get_center())
		var to_edge : Vector2 = Utils.get_vector_to_rectangle_edge_at_angle(target_rect, target_dir_angle)
		target_arrow.position = Utils.get_vector_to_rectangle_edge_at_angle(self_rect, target_dir_angle)
		target_arrow.end_position = (target_rect.get_center() - to_edge)

func start_drag() -> void:
	dragging = true
	dragging_offset = self.position - get_parent().get_local_mouse_position()

func end_drag() -> void:
	dragging = false

func start_target() -> void:
	selecting_target = true

func end_target() -> void:
	selecting_target = false
	var hovered : ICardInstance = gamefield.client_ui.get_hovered_card()
	AuthoritySourceProvider.authority_source.request_action(
		CreatureTargetAction.new(
			ICardInstance.id(self), ITargetable.id(hovered)
		)
	)
