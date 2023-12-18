class_name CardInstance
extends Node2D

var gamefield : Gamefield
var metadata : CardMetadata
var logic : CardLogic
var player_owner : Player

@onready var area : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite2D
var dragging : bool = false
var dragging_offset : Vector2 = Vector2.ZERO

func _setup(_gamefield : Gamefield, _metadata : CardMetadata, _player_owner : Player) -> void:
	gamefield = _gamefield
	metadata = _metadata
	player_owner = _player_owner

var selecting_target : bool = false
var target : CardInstance = null

func _ready() -> void:
	area.input_event.connect(
		func (_viewport : Viewport, event : InputEvent, _shape_idx : int) -> void:
			if not event is InputEventMouseButton: return
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed: start_drag() 
				else: end_drag()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.pressed: start_target()
			get_viewport().set_input_as_handled()
	)
	sprite.texture = metadata.image
	logic = metadata.logic_script.new()
	logic.owner = self
	gamefield.event.emit("card_placement", {"card_instance": self})

func _process(_delta : float) -> void:
	if dragging:
		self.position = get_parent().get_local_mouse_position() + dragging_offset
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()
	
	if selecting_target:
		
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			end_target()

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
	#print(target)
	#if target != null: print(target.metadata)
