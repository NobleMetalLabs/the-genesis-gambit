class_name RightClickMenu
extends PopupMenu

signal create_node(node : CardBehaviorNodeInstance, position : Vector2)

@onready var window : Window = get_tree().root

func _ready() -> void:
	_build_add_node_menu()

func _build_add_node_menu() -> void:
	var nodes : Dictionary = load_nodes() #[String..., CardBehaviorNode]
	# {
	# 	"Math" : {
	# 		"Add" : CardBehaviorNode<add.gd>,
	# 	}
	# } 
	var id_to_node : Dictionary = {} #[int, CardBehaviorNode]
	var id_tally : int = 0
	var add_menu := PopupMenu.new()
	for category_name : String in nodes.keys():
		var submenu : PopupMenu = PopupMenu.new()
		if not nodes[category_name] is Dictionary: continue
		var category_items : Dictionary = nodes[category_name]
		for node_name : String in category_items.keys():
			submenu.add_item(node_name.left(-3).to_pascal_case(), id_tally)
			id_to_node[id_tally] = category_items[node_name]
			id_tally += 1
		add_menu.add_submenu_node_item(category_name.to_pascal_case(), submenu)
		submenu.id_pressed.connect(func add_node(id : int) -> void:
			handle_node_addition(id_to_node[id], self.position - window.position)
		)
	self.add_submenu_node_item("Add Node", add_menu)

var mouse_position : Vector2 = Vector2()
func handle_dialog_show(_position : Vector2) -> void:
	print("Showing dialog at %s -> %s" % [window.position, _position])
	mouse_position = _position
	self.position = Vector2(window.position) + _position
	self.popup()

func handle_node_addition(node : CardBehaviorNode, pos : Vector2) -> void:
	var node_instance := CardBehaviorNodeInstance.new(node)
	print("Creating node %s at %s" % [node_instance, self.position])
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
