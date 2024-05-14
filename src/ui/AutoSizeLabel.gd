@tool
class_name AutoSizeLabel
extends Label

@export var fill_percentage : float = 1

func _ready() -> void:
	item_rect_changed.connect(resize_from_current_text)
	resize_from_current_text()

func resize_from_current_text() -> void:
	var size_max : int = 60
	var size_min : int = 1
	for index in 7:
		var size_mid : int = (size_max + size_min) / 2
		if does_text_fit(size_mid):
			size_min = size_mid
		else:
			size_max = size_mid
	self.label_settings.font_size = size_min

#TODO: Add multiline functionality
func does_text_fit(_size : int) -> bool:
	var settings : LabelSettings = self.label_settings
	var text_size : Vector2 = settings.font.get_string_size(
		self.text, self.horizontal_alignment, -1, _size
	)
	return text_size.x < (self.size.x * fill_percentage)
