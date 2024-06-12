class_name CBERightClickMenu
extends PopupMenu

signal create_node(node : CardBehaviorNodeInstance, position : Vector2)

@onready var window : Window = get_tree().root

func _ready() -> void:
	self.index_pressed.connect(
		func invoke_menu_item_metadata(idx : int) -> void:
			var metadata : Variant = self.get_item_metadata(idx)
			if metadata == null: return
			if not metadata is Callable: return
			metadata.call()
	)
	_build_add_node_menu()

var id_tally : int = 0
var id_to_node : Dictionary = {} #[int, CardBehaviorNode]
func _build_add_node_menu() -> void:
	self.add_submenu_node_item("Add Node", _build_node_menu())

func _build_node_menu(menu_dict : Dictionary = load_nodes()) -> PopupMenu:
	var menu : PopupMenu = PopupMenu.new()
	for menu_item_name : String in menu_dict.keys():
		var menu_item : Variant = menu_dict[menu_item_name]
		if menu_item is CardBehaviorNode:
			menu.add_item(menu_item_name.left(-3).to_pascal_case(), id_tally)
			id_to_node[id_tally] = menu_item
			id_tally += 1
		elif menu_item is Dictionary:
			var submenu : PopupMenu = _build_node_menu(menu_item)
			menu.add_submenu_node_item(menu_item_name.to_pascal_case(), submenu)
			submenu.id_pressed.connect(func add_node(id : int) -> void:
				handle_node_addition(id_to_node[id], self.position - window.position)
			)
		else:
			push_warning("Building CBERightClickMenu, unknown thingie: %s" % [menu_item])
	return menu

var mouse_position : Vector2 = Vector2()
func handle_dialog_show(_position : Vector2) -> void:
	mouse_position = _position
	self.position = Vector2(window.position) + _position
	self.popup()

func handle_node_addition(node : CardBehaviorNode, pos : Vector2) -> void:
	var node_instance := CardBehaviorNodeInstance.new(node)
	create_node.emit(node_instance, pos)
	self.hide()

func load_nodes(path : String = "res://lib/card/behavior/frontend/nodes/") -> Dictionary: #[String..., Resource<CardBehaviorNode>]
	var nodes_dir : DirAccess = DirAccess.open(path)
	if nodes_dir == null: return {}
	var output : Dictionary = {}
	for directory in nodes_dir.get_directories():
		output[directory] = load_nodes("%s/%s" % [path, directory])
	for file in nodes_dir.get_files():
		if not file.get_basename().ends_with("CBN"):
			continue
		var node_resource : CardBehaviorNode = load("%s/%s" % [path, file]).new()
		var node_name : String = file.get_basename()
		if node_name == "null": continue
		output[node_name] = node_resource
	return output
