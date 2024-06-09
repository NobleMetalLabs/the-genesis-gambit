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
	self.arrange_nodes()

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
	self.popup_request.connect(add_node_menu.handle_dialog_show)
	add_node_menu.create_node.connect(
		func(internal : CardBehaviorNodeInstance, pos : Vector2) -> void:
			create_node(internal, pos)
	)
	
func create_node(node_internal : CardBehaviorNodeInstance, pos : Vector2 = Vector2.ZERO) -> CBEditorGraphNode:
	var new_node := CBEditorGraphNode.new(node_internal, (pos + self.scroll_offset) / self.zoom)
	self.add_child(new_node)
	#new_node.node_targeted.connect(func(n_node : CBEditorGraphNode) -> void: self.targeted_node = n_node)
	print("Created node %s at %s" % [node_internal, new_node.position_offset])
	return new_node

func poll_node_creation() -> void:
	if self.get_viewport().gui_get_focus_owner() != self: return
	if Input.is_action_just_pressed("ui_node_add"):
		if Input.is_action_pressed("ui_alternate"): return
		add_node_menu.handle_dialog_show(get_local_mouse_position())

func setup_node_connection() -> void:
	self.connection_request.connect(handle_connection_request)
	self.disconnection_request.connect(handle_disconnection_request)

func handle_connection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int) -> void:
	self.connect_node(from_node, from_port, to_node, to_port)

func handle_disconnection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int) -> void:
	self.disconnect_node(from_node, from_port, to_node, to_port)
