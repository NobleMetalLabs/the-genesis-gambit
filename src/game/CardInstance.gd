class_name CardInstance
extends Node2D

var gamefield : Gamefield
var metadata : CardMetadata
var logic : CardLogic
var player_owner : Player

@onready var area : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape : CollisionShape2D = area.get_node("CollisionShape2D")
var dragging : bool = false
var dragging_offset : Vector2 = Vector2.ZERO

func _setup(_gamefield : Gamefield, _metadata : CardMetadata, _player_owner : Player) -> void:
	gamefield = _gamefield
	metadata = _metadata
	player_owner = _player_owner

var selecting_target : bool = false
var target : CardInstance = null
var target_arrow : Arrow2D = Arrow2D.new()

func get_vector_to_edge_at_angle(angle : float) -> Vector2:
	# TODO: Make this shit better
	var half_bounds : Vector2 = collision_shape.shape.get_rect().size / 2
	var tri_angle : float = abs(Vector2.from_angle(angle)).angle()
	var bleed : float = 0.2
	var to_edge : Vector2
	if half_bounds.angle() < tri_angle:
	 	#Vertical Edge
		to_edge = Vector2.from_angle(angle) * Vector2(half_bounds.y, tan((PI / 2) - tri_angle) * half_bounds.y).length()
	else:
		#Horizontal Edge
		to_edge = Vector2.from_angle(angle) * Vector2(half_bounds.x, tan(tri_angle) * half_bounds.x).length()
	return to_edge * (1 - bleed)

func _ready() -> void:
	area.input_event.connect(
		func (_viewport : Viewport, event : InputEvent, _shape_idx : int) -> void:
			if not event is InputEventMouseButton: return
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed: start_drag() 
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.pressed: start_target()
			get_viewport().set_input_as_handled()
	)
	sprite.texture = metadata.image
	logic = metadata.logic_script.new()
	logic.owner = self
	gamefield.event.emit("card_placement", {"card_instance": self})
	
	target_arrow.z_index = 2
	target_arrow.modulate = Color.RED
	add_child(target_arrow)

func _process(_delta : float) -> void:
	if dragging:
		self.position = get_parent().get_local_mouse_position() + dragging_offset
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()
	
	target_arrow.visible = (target != null or selecting_target)

	if selecting_target:
		target_arrow.position = self.get_vector_to_edge_at_angle(get_local_mouse_position().angle())
		target_arrow.end_position = get_parent().get_local_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			end_target()
	elif target != null: 
		var target_dir_angle : float = self.global_position.angle_to_point(target.global_position)
		var to_edge : Vector2 = target.get_vector_to_edge_at_angle(target_dir_angle)
		target_arrow.position = self.get_vector_to_edge_at_angle(target_dir_angle)
		target_arrow.end_position = (target.global_position - to_edge)

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
