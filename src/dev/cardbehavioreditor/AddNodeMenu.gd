class_name AddNodeMenu
extends PopupPanel

var nodes : Dictionary #[String..., CardBehaviorNode]
# {
# 	"Math" : {
# 		"Add" : add.gd
# 	}
# }

var tree_to_nodes : Dictionary #[TreeItem, CardBehaviorNode]
@onready var tree : Tree = $"Tree"

signal create_node(node : CardBehaviorNodeInstance, position : Vector2)

func _ready() -> void:
	nodes = load_nodes()
	print(nodes)
	_build_tree()

func _build_tree() -> void:
	var root : TreeItem = tree.create_item()
	for category_name : String in nodes.keys():
		var category_item : TreeItem = tree.create_item(root)
		category_item.set_text(0, category_name)
		if not nodes[category_name] is Dictionary: continue
		var category_items : Dictionary = nodes[category_name]
		for node_name : String in category_items.keys():
			var node_item : TreeItem = tree.create_item(category_item)
			node_item.set_text(0, node_name)
			tree_to_nodes[node_item] = category_items[node_name]
	tree.item_activated.connect(handle_dialog_accept)

func _input(_event : InputEvent) -> void:
	if not self.visible: return
	if Input.is_action_just_pressed("ui_accept"):
		if tree.get_selected() == null: return
		handle_dialog_accept()

func handle_dialog_accept() -> void:
	var node_item : TreeItem = tree.get_selected()
	if node_item.get_child_count() > 0: return
	var node_path : StringName = node_item.get_text(0)
	var node_instance := CardBehaviorNodeInstance.new(tree_to_nodes[node_item])
	print("Creating node %s at %s" % [node_instance, self.position])
	create_node.emit(node_instance, Vector2(self.position))
	while node_item != tree.get_root():
		node_item = node_item.get_parent()
		node_path = "%s/%s" % [node_item.get_text(0), node_path]
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
