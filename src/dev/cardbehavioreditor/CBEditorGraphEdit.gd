class_name CBEditorGraphEdit
extends GraphEdit

func _ready() -> void:
	setup_input_actions()
	setup_node_creation()
	setup_node_connection()
	return

func _input(_event : InputEvent) -> void:
	poll_node_creation()
	return

func load_visual_card_behavior(cbg : CardBehaviorGraph) -> void:
	for node_idx in range(cbg.nodes.size()):
		var node_instance : CardBehaviorNodeInstance = cbg.nodes[node_idx]
		var _ui_node : CBEditorGraphNode = create_node(node_instance)
	# connect nodes
	for edge : CardBehaviorEdge in cbg.edges:
		connect_node(edge.from_node, edge.from_port, edge.to_node, edge.to_port)

@onready var add_node_menu : PopupPanel = %"AddNodeMenu"

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
	add_node_menu.create_node.connect(
		func(internal : CardBehaviorNodeInstance, pos : Vector2) -> void:
			var rect : Rect2 = Rect2(pos, Vector2(200, 100))
			create_node(internal, rect)
	)
	
func create_node(node_internal : CardBehaviorNodeInstance, rect : Rect2 = Rect2(Vector2.ZERO, Vector2.ONE)) -> CBEditorGraphNode:
	var new_node := CBEditorGraphNode.new(node_internal, rect)
	self.add_child(new_node)
	#new_node.node_targeted.connect(func(n_node : CBEditorGraphNode) -> void: self.targeted_node = n_node)
	print("Created node %s at %s" % [node_internal, new_node.position])
	return new_node

func poll_node_creation() -> void:
	if Input.is_action_just_pressed("ui_node_add"):
		if Input.is_action_pressed("ui_alternate"): return
		var menu_pos : Vector2 = get_local_mouse_position()
		self.popup_request.emit(menu_pos)

func setup_node_connection() -> void:
	self.connection_request.connect(handle_connection_request)
	self.disconnection_request.connect(handle_disconnection_request)

func handle_connection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int) -> void:
	self.connect_node(from_node, from_port, to_node, to_port)

func handle_disconnection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int) -> void:
	self.disconnect_node(from_node, from_port, to_node, to_port)
