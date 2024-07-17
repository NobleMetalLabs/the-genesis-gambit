class_name UIPackSlice
extends Control

@onready var title_label : Label = $"%TITLE-LABEL"
@onready var image_trect : TextureRect = $"%IMAGE"
@onready var full_button : Button = $"%FULL-BUTTON"
@onready var border_component : CardBorderComponent = $"%BORDER-COMPONENT"
var _metadata : PackMetadata

func set_metadata(metadata : PackMetadata) -> void:
	_metadata = metadata
	title_label.text = metadata.name
	image_trect.texture = metadata.image
	border_component.set_rarity(metadata.rarity as Genesis.CardRarity)

func set_label_multiplier(count : int) -> void:
	if count > 1: title_label.text = _metadata.name + " (x%s)"%count
	else: title_label.text = _metadata.name
	title_label.emit_signal("item_rect_changed")
