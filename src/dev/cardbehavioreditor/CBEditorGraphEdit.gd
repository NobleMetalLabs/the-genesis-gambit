class_name CBEditorGraphEdit
extends GraphEdit

@onready var editor : CardBehaviorEditor = get_tree().get_root().get_node("CardBehaviorEditor")

func _ready() -> void:
	setup_input_actions()
	setup_node_creation()
	setup_node_deletion()
	setup_node_connection()
	return

func _input(_event : InputEvent) -> void:
	poll_node_creation()
	return

func refresh() -> void:
	for node in nodes:
		node.queue_free()
	nodes.clear()
	internals_to_nodes.clear()
	internals_to_names.clear()

	var cbg : CardBehaviorGraph = editor.currently_editing_card_behavior
	for node_idx in range(cbg.nodes.size()):
		var node_instance : CardBehaviorNodeInstance = cbg.nodes[node_idx]
		var _ui_node : CBEditorGraphNode = create_node(node_instance)
	# connect nodes
	for edge : CardBehaviorEdge in cbg.edges:
		connect_node(internals_to_names[edge.start_node], edge.start_port, internals_to_names[edge.end_node], edge.end_port)
	self.arrange_nodes()
	self.arrange_nodes() # I LOVE GODOT ENGINE !!!!!!!

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
			var node : CBEditorGraphNode = create_node(internal, pos)
			editor.currently_editing_card_behavior.nodes.append(node.node_internal)
	)

func setup_node_deletion() -> void:
	self.delete_nodes_request.connect(
		func(del_nodes : Array) -> void:
			for node_name : String in del_nodes:
				var node : CBEditorGraphNode = self.get_node(node_name)
				var internal : CardBehaviorNodeInstance = node.node_internal
				internals_to_nodes.erase(internal)
				internals_to_names.erase(internal)
				editor.currently_editing_card_behavior.nodes.erase(internal)
				nodes.erase(node)
				node.queue_free()
	)

func position_offset_to_screen_space(pos : Vector2) -> Vector2:
	return (pos + self.scroll_offset) / self.zoom

var nodes : Array[CBEditorGraphNode] = []
var internals_to_nodes : Dictionary = {} #[CardBehaviorNodeInstance, CBEditorGraphNode]
var internals_to_names : Dictionary = {} #[CardBehaviorNodeInstance, String]

func create_node(node_internal : CardBehaviorNodeInstance, pos : Vector2 = Vector2.ZERO) -> CBEditorGraphNode:
	var new_node := CBEditorGraphNode.new(node_internal, position_offset_to_screen_space(pos))
	self.add_child(new_node)
	print("Created node %s at %s" % [node_internal, new_node.position_offset])
	nodes.append(new_node)
	internals_to_nodes[node_internal] = new_node
	internals_to_names[node_internal] = new_node.name
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
	print("Connection request from %s:%s to %s:%s" % [from_node, from_port, to_node, to_port])
	var from_node_instance : CardBehaviorNodeInstance = self.get_node(NodePath(from_node)).node_internal
	var to_node_instance : CardBehaviorNodeInstance = self.get_node(NodePath(to_node)).node_internal
	editor.currently_editing_card_behavior.edges.append(
		CardBehaviorEdge.new(
			from_node_instance,
			from_port,
			to_node_instance,
			to_port
		)
	)
	self.connect_node(from_node, from_port, to_node, to_port)

func handle_disconnection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int) -> void:
	print("Disconnection request from %s:%s to %s:%s" % [from_node, from_port, to_node, to_port])
	var from_node_instance : CardBehaviorNodeInstance = self.get_node(NodePath(from_node)).node_internal
	var to_node_instance : CardBehaviorNodeInstance = self.get_node(NodePath(to_node)).node_internal
	self.disconnect_node(from_node, from_port, to_node, to_port)
	for edge in editor.currently_editing_card_behavior.edges:
		if edge.start_node != from_node_instance: continue
		if edge.start_port != from_port: continue
		if edge.end_node != to_node_instance: continue
		if edge.end_port != to_port: continue
		print("found the edge")
		editor.currently_editing_card_behavior.edges.erase(edge)
		print(editor.currently_editing_card_behavior.edges)
		return
