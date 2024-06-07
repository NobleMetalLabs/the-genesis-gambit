class_name CBEditorGraphEdit
extends GraphEdit

func _ready() -> void:
	setup_input_actions()
	setup_node_creation()
	setup_node_connection()
	return

func _input(_event : InputEvent) -> void:
	poll_node_selection()
	poll_node_creation()
	poll_node_movement()
	poll_node_navigation()
	return

func load_visual_card_behavior(vcb : VisualCardBehavior) -> void:
	for node_idx in range(vcb.nodes.size()):
		var node_instance : CardBehaviorNodeInstance = vcb.nodes[node_idx]
		var node_position : Rect2 = vcb.node_positions[node_idx]
		var _ui_node : CBEditorGraphNode = create_node(node_instance, node_position)
	# connect nodes

@export var targeted_node : CBEditorGraphNode : 
	get: return targeted_node
	set(value):
		if targeted_node != null: 
			targeted_node.targeted = false
		targeted_node = value
		targeted_node.targeted = true

func poll_node_selection() -> void:
	if targeted_node == null: return
	if Input.is_action_just_pressed("ui_cancel"):
		targeted_node.push_navigation_direction("NONE")
	elif Input.is_action_just_pressed("ui_node_navigate_input"):
		targeted_node.push_navigation_direction("INPUT")
	elif Input.is_action_just_pressed("ui_node_navigate_output"):
		targeted_node.push_navigation_direction("OUTPUT")

func poll_node_movement() -> void:
	if targeted_node == null: return
		
	if not Input.is_action_pressed("ui_alternate"): return
	if Input.is_action_just_pressed("ui_up"):
		targeted_node.position_offset += Vector2(0, -self.snap_distance)
	if Input.is_action_just_pressed("ui_down"):
		targeted_node.position_offset += Vector2(0, self.snap_distance)
	if Input.is_action_just_pressed("ui_left"):
		targeted_node.position_offset += Vector2(-self.snap_distance, 0)
	if Input.is_action_just_pressed("ui_right"):
		targeted_node.position_offset += Vector2(self.snap_distance, 0)
			
func poll_node_navigation() -> void:
	if targeted_node == null: return
	if Input.is_action_just_pressed("ui_accept"):
		var list : Array[Dictionary] = self.get_connection_list()
		match(targeted_node.targeting_dir):
			"INPUT":
				for connection in list:
					if connection["to"] != targeted_node.name: continue
					if connection["to_port"] != targeted_node.targeted_index: continue
					targeted_node = self.find_child(connection["from"], false, false)
					return
			"OUTPUT":
				for connection in list:
					if connection["from"] != targeted_node.name: continue
					if connection["from_port"] != targeted_node.targeted_index: continue
					targeted_node = self.find_child(connection["to"], false, false)
					return

@onready var add_node_menu : PopupPanel = %"AddNodeMenu"
@export var template_node : PackedScene

func setup_input_actions() -> void:
	InputMap.add_action("ui_node_add")
	var add_node_key_event : InputEventKey = InputEventKey.new()
	add_node_key_event.keycode = KEY_A
	InputMap.action_add_event("ui_node_add", add_node_key_event)

	InputMap.add_action("ui_alternate")
	var alternate_key_event : InputEventKey = InputEventKey.new()
	alternate_key_event.keycode = KEY_SHIFT
	InputMap.action_add_event("ui_alternate", alternate_key_event)

func setup_node_creation() -> void:
	self.popup_request.connect(func(click_pos: Vector2) -> void:
		var rect : Rect2 = Rect2(0, 0, 0, 0)
		rect.position = click_pos
		rect.size = Vector2(add_node_menu.size)
		add_node_menu.popup(rect)
	)
	add_node_menu.create_node.connect(func(node_internal : CardBehaviorNodeInstance, pos : Vector2) -> void:
		var new_node : CBEditorGraphNode = create_node(node_internal, Rect2(pos, Vector2.ONE * 100))
		if targeted_node != null:
			match(targeted_node.targeting_dir):
				"INPUT":
					self.connect_node(
						new_node.name, 0,
						targeted_node.name, targeted_node.targeted_index
					)
					targeted_node = new_node
				"OUTPUT":
					self.connect_node(
						targeted_node.name, targeted_node.targeted_index, 
						new_node.name, 0
					)
					targeted_node = new_node
				_:
					return
	)
	
func create_node(node_internal : CardBehaviorNodeInstance, rect : Rect2) -> CBEditorGraphNode:
	var new_node := CBEditorGraphNode.new(node_internal, rect)
	self.add_child(new_node)
	#new_node.node_targeted.connect(func(n_node : CBEditorGraphNode) -> void: self.targeted_node = n_node)
	return new_node

func poll_node_creation() -> void:
	if Input.is_action_just_pressed("ui_node_add"):
		if Input.is_action_pressed("ui_alternate"): return
		var menu_pos : Vector2 = get_local_mouse_position()
		if targeted_node != null and targeted_node.targeting_dir != "NONE":
			var pos_mod : Vector2 = Vector2(targeted_node.get_rect().size.x, 0)\
						+ Vector2(self.snap_distance, 0)
			pos_mod = pos_mod * (1 if targeted_node.targeting_dir == "OUTPUT" else -2)
			menu_pos = targeted_node.position_offset + pos_mod
		self.popup_request.emit(menu_pos)

func setup_node_connection() -> void:
	self.connection_request.connect(handle_connection_request)
	self.disconnection_request.connect(handle_disconnection_request)

func handle_connection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int) -> void:
	self.connect_node(from_node, from_port, to_node, to_port)

func handle_disconnection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int) -> void:
	self.disconnect_node(from_node, from_port, to_node, to_port)
