class_name CardBehaviorEditor
extends Control

@onready var graph_edit : CBEditorGraphEdit = $"%GRAPH_EDIT"
@onready var menu_bar : MenuBar = $"%MENU_BAR"

var currently_editing_card_behavior := CardBehaviorGraph.new()

func _ready() -> void:
	var window : Window = get_tree().get_root()
	window.title = "Card Behavior Editor"
	window.content_scale_size = Vector2.ZERO

	for menu : MenuBarMenu in menu_bar.get_children():
		menu.option_pressed.connect(handle_menu_pressed)

func handle_menu_pressed(menu : StringName, option : StringName) -> void:
	match menu:
		"File":
			handle_file_pressed(option)

func handle_file_pressed(option : StringName) -> void:
	match option:
		"Save":
			save_file()
		"Open":
			open_file()

func save_file() -> void:
	var cereal := CardBehaviorGraphSerializable.serialize(currently_editing_card_behavior)
	var dict : Dictionary = Utils.object_to_dict(cereal)
	print(JSON.stringify(dict))
	var file_access := FileAccess.open("C://Users/ML/Desktop/test_card_behavior.gcb", FileAccess.WRITE)
	file_access.store_var(dict)
	file_access.close()

func open_file() -> void:
	var file_access := FileAccess.open("C://Users/ML/Desktop/test_card_behavior.gcb", FileAccess.READ)
	var dict : Dictionary = file_access.get_var()
	print(JSON.stringify(dict))
	file_access.close()
	var serializable := CardBehaviorGraphSerializable.from_dict(dict)
	var behavior : CardBehaviorGraph = serializable.deserialize()
	currently_editing_card_behavior = behavior
	graph_edit.refresh()
