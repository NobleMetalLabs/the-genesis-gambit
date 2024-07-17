class_name CardBehaviorEditor
extends Control

@onready var graph_edit : CBEditorGraphEdit = $"%GRAPH-EDIT"
@onready var menu_bar : MenuBar = $"%MENU-BAR"
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
		"Edit":
			handle_edit_pressed(option)

func handle_file_pressed(option : StringName) -> void:
	match option:
		"New":
			handle_new_file()
		"Save":
			handle_save_file()
		"Open":
			handle_open_file()

func handle_edit_pressed(option : StringName) -> void:
	match option:
		"Edit Description":
			self.get_node("CBEEditDescriptionPanel").popup()

func handle_new_file() -> void:
	currently_editing_card_behavior = CardBehaviorGraph.new()
	graph_edit.refresh()

func handle_save_file() -> void:
	var file_dialog : FileDialog = self.get_node("CBEFileDialog")
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.ok_button_text = "Save"
	file_dialog.title = "Save"
	if file_dialog.file_selected.is_connected(_open_file):
		file_dialog.file_selected.disconnect(_open_file)
	if not file_dialog.file_selected.is_connected(_save_file):
		file_dialog.file_selected.connect(_save_file)
	file_dialog.popup()

func handle_open_file() -> void:
	var file_dialog : FileDialog = self.get_node("CBEFileDialog")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.ok_button_text = "Open"
	file_dialog.title = "Open"
	if file_dialog.file_selected.is_connected(_save_file):
		file_dialog.file_selected.disconnect(_save_file)
	if not file_dialog.file_selected.is_connected(_open_file):
		file_dialog.file_selected.connect(_open_file)
	file_dialog.popup()

func _save_file(path : String) -> void:
	var cereal := CardBehaviorGraphSerializable.serialize(currently_editing_card_behavior)
	var dict : Dictionary = Serializeable._variant_to_deep_variant(cereal)
	var file_access := FileAccess.open(path, FileAccess.WRITE)
	file_access.store_var(dict)
	file_access.close()

func _open_file(path : String) -> void:
	var file_access := FileAccess.open(path, FileAccess.READ)
	var dict : Dictionary = file_access.get_var()
	file_access.close()
	var serializable := CardBehaviorGraphSerializable.from_dict(dict)
	var behavior : CardBehaviorGraph = serializable.deserialize()
	currently_editing_card_behavior = behavior
	graph_edit.refresh()
