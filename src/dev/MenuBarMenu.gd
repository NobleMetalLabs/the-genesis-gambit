class_name MenuBarMenu extends PopupMenu

@export var shortcuts : Array[Shortcut]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assign_shortcuts()
	self.index_pressed.connect(func item_option_pressed(idx : int) -> void:
		option_pressed.emit(self.name, get_item_text(idx))
	)

signal option_pressed(menu : StringName, option : StringName)

func assign_shortcuts() -> void:
	for idx in range(0, self.item_count):
		self.set_item_shortcut(idx, shortcuts[idx])
