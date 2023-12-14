class_name CardInstance
extends Node

@onready var area = $Area2D
var dragging : bool = false
var dragging_offset : Vector2 = Vector2.ZERO

func _ready():
	area.input_event.connect(
		func (_viewport, event, _shape_idx):
			if not event is  InputEventMouseButton: return
			if not event.button_index == MOUSE_BUTTON_LEFT: return
			if event.pressed: start_drag() 
			else: end_drag()
			get_viewport().set_input_as_handled()
	)

func _process(_delta):
	if dragging:
		self.position = get_parent().get_local_mouse_position() + dragging_offset
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()

func start_drag():
	dragging = true
	dragging_offset = self.position - get_parent().get_local_mouse_position()
	print("drag")

func end_drag():
	dragging = false
	print("end drag")
