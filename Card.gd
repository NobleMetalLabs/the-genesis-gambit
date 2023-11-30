class_name Card
extends Node

@onready var area = $Area2D
var dragging : bool = false

func _ready():
	area.input_event.connect(
		func (_viewport, event, _shape_idx):
			if not event is  InputEventMouseButton: return
			if not event.button_index == MOUSE_BUTTON_LEFT: return
			if event.pressed: start_drag() 
			else: end_drag()
	)

func _process(_delta):
	if dragging:
		self.position = get_parent().get_local_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			end_drag()

func start_drag():
	dragging = true
	print("drag")

func end_drag():
	dragging = false
	print("end drag")
