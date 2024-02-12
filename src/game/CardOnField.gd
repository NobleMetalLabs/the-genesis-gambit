class_name CardOnField
extends Control

var metadata : CardMetadata :
	get:
		return ICardInstance.id(self).metadata
	set(value):
		ICardInstance.id(self).metadata = value

var logic : CardLogic
var gamefield : Gamefield
var player_owner : Player

@onready var texture_rect : TextureRect = $TextureRect
@onready var border_component : CardBorderComponent = $TextureRect/CardBorderComponent

func _setup(_gamefield: Gamefield, _metadata : CardMetadata, _player_owner: Player) -> void:
	metadata = _metadata
	logic = metadata.logic_script.new()
	logic.owner = ICardInstance.id(self)
	gamefield = _gamefield
	player_owner = _player_owner

func _ready() -> void:
	texture_rect.texture = metadata.image
	border_component.set_rarity(metadata.rarity)
	
	gui_input.connect(
		func (event : InputEvent) -> void:
			if not event is InputEventMouseButton: return
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed: start_drag() 
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.pressed: start_target()
			get_viewport().set_input_as_handled()
	)
	gamefield.event.emit("card_placement", {"card_instance": self})
	
	target_arrow.z_index = 2
	target_arrow.modulate = Color.RED
	add_child(target_arrow)
	
var dragging : bool = false
var dragging_offset : Vector2 = Vector2.ZERO

var selecting_target : bool = false
var target : ICardInstance = null
var target_arrow : Arrow2D = Arrow2D.new()

func _process(_delta : float) -> void:
	if dragging:
		self.position = get_parent().get_local_mouse_position() + dragging_offset
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()
	
	target_arrow.visible = (target != null or selecting_target)
	
	var target_obj : Node = target.get_object() if target != null else null

	if selecting_target:
		target_arrow.position = Utils.get_vector_to_rectangle_edge_at_angle(self.get_rect(), get_local_mouse_position().angle())
		target_arrow.end_position = get_parent().get_local_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			end_target()
	elif target != null: 
		var target_dir_angle : float = self.global_position.angle_to_point(target_obj.global_position)
		var to_edge : Vector2 = Utils.get_vector_to_rectangle_edge_at_angle(target_obj.get_rect(), target_dir_angle)
		target_arrow.position = Utils.get_vector_to_rectangle_edge_at_angle(self.get_rect(), target_dir_angle)
		target_arrow.end_position = (target_obj.global_position - to_edge)

func start_drag() -> void:
	dragging = true
	dragging_offset = self.position - get_parent().get_local_mouse_position()

func end_drag() -> void:
	dragging = false

func start_target() -> void:
	selecting_target = true
	target = null

func end_target() -> void:
	selecting_target = false
	target = gamefield.get_hovered_card()
