class_name CBEditorGraphEdit
extends GraphEdit

@onready var editor : CardBehaviorEditor = get_tree().get_root().get_node("CardBehaviorEditor")

func _ready() -> void:
	setup_right_click_menu()
	setup_node_deletion()
	setup_node_connection()
	return

func refresh() -> void:
	# Reset
	for node in nodes:
		node.queue_free()
	nodes.clear()
	internals_to_nodes.clear()

	var cbg : CardBehaviorGraph = editor.currently_editing_card_behavior
	# Nodes
	for node_idx in range(cbg.nodes.size()):
		var node_instance : CardBehaviorNodeInstance = cbg.nodes[node_idx]
		create_node(node_instance)
	# Edges
	for edge : CardBehaviorEdge in cbg.edges:
		var from_node : CBEditorGraphNode = internals_to_nodes[edge.start_node]
		var to_node : CBEditorGraphNode = internals_to_nodes[edge.end_node]
		connect_node(from_node.name, edge.start_port, to_node.name, edge.end_port)
		to_node.refresh_input_fields()
	self.arrange_nodes()
	self.arrange_nodes() # I LOVE GODOT ENGINE !!!!!!!

@onready var right_click_menu : CBERightClickMenu = %"CBERightClickMenu"

func setup_input_actions() -> void:
	InputMap.add_action("ui_node_add")
	var add_node_key_event : InputEventKey = InputEventKey.new()
	add_node_key_event.keycode = KEY_A
	InputMap.action_add_event("ui_node_add", add_node_key_event)

	InputMap.add_action("ui_alternate")
	var alternate_key_event : InputEventKey = InputEventKey.new()
	alternate_key_event.keycode = KEY_SHIFT
	InputMap.action_add_event("ui_alternate", alternate_key_event)

func setup_right_click_menu() -> void:
	self.popup_request.connect(right_click_menu.handle_dialog_show)
	right_click_menu.create_node.connect(
		func(internal : CardBehaviorNodeInstance, pos : Vector2) -> void:
			editor.currently_editing_card_behavior.nodes.append(internal)
			create_node(internal, pos)
	)

func setup_node_deletion() -> void:
	self.delete_nodes_request.connect(
		func remap_nodes(del_nodes : Array) -> void:
			var remaped : Array[GraphElement] = []
			for _name : String in del_nodes:
				remaped.append(self.get_node(_name))
			handle_deletion_request(remaped)
	)

func position_offset_to_screen_space(pos : Vector2) -> Vector2:
	return (pos + self.scroll_offset) / self.zoom

var nodes : Array[CBEditorGraphNode] = []
var internals_to_nodes : Dictionary = {} #[CardBehaviorNodeInstance, CBEditorGraphNode]

func create_node(node_internal : CardBehaviorNodeInstance, pos : Vector2 = Vector2.ZERO) -> CBEditorGraphNode:
	var new_node := CBEditorGraphNode.new(node_internal, position_offset_to_screen_space(pos))
	self.add_child(new_node)
	nodes.append(new_node)
	internals_to_nodes[node_internal] = new_node
	return new_node

func poll_node_creation() -> void:
	if self.get_viewport().gui_get_focus_owner() != self: return
	if Input.is_action_just_pressed("ui_node_add"):
		if Input.is_action_pressed("ui_alternate"): return
		right_click_menu.handle_dialog_show(get_local_mouse_position())

func setup_node_connection() -> void:
	self.connection_request.connect(handle_connection_request)
	self.disconnection_request.connect(handle_disconnection_request)

func handle_deletion_request(nodes_to_delete : Array[GraphElement]) -> void:
	for element : GraphElement in nodes_to_delete:
		if element is CBEditorGraphNode:
			var internal : CardBehaviorNodeInstance = element.node_internal
			internals_to_nodes.erase(internal)
			editor.currently_editing_card_behavior.nodes.erase(internal)
			nodes.erase(element)
			element.queue_free()
		else:
			push_warning("Unhandled deletion request for graphelement %s" % [element])

func handle_connection_request(from_node_name : StringName, from_port : int, to_node_name : StringName, to_port : int) -> void:
	var from_node_instance : CardBehaviorNodeInstance = self.get_node(NodePath(from_node_name)).node_internal
	var to_node : CBEditorGraphNode = self.get_node(NodePath(to_node_name))
	var to_node_instance : CardBehaviorNodeInstance = to_node.node_internal
	print("NEW EDGE")
	self.connect_node(from_node_name, from_port, to_node_name, to_port)
	to_node.refresh_input_fields()
	for edge in editor.currently_editing_card_behavior.edges:
		if edge.start_node != from_node_instance: continue
		if edge.start_port != from_port: continue
		if edge.end_node != to_node_instance: continue
		if edge.end_port != to_port: continue
		# Edge already exists
		return
	editor.currently_editing_card_behavior.edges.append(
		CardBehaviorEdge.new(
			from_node_instance,
			from_port,
			to_node_instance,
			to_port
		)
	)

func handle_disconnection_request(from_node_name : StringName, from_port : int, to_node_name : StringName, to_port : int) -> void:
	var from_node_instance : CardBehaviorNodeInstance = self.get_node(NodePath(from_node_name)).node_internal
	var to_node : CBEditorGraphNode = self.get_node(NodePath(to_node_name))
	var to_node_instance : CardBehaviorNodeInstance = to_node.node_internal
	self.disconnect_node(from_node_name, from_port, to_node_name, to_port)
	to_node.refresh_input_fields()
	for edge in editor.currently_editing_card_behavior.edges:
		if edge.start_node != from_node_instance: continue
		if edge.start_port != from_port: continue
		if edge.end_node != to_node_instance: continue
		if edge.end_port != to_port: continue
		print("REMOVED EDGE")
		editor.currently_editing_card_behavior.edges.erase(edge)
		return
	push_warning("Disconnected edge not present in the graph")
