class_name UIFullPack
extends Control

@onready var title_label : Label = $"%TITLE-LABEL"
@onready var image_trect : TextureRect = $"%IMAGE"
@onready var type_label : Label = $"%TYPE-LABEL"
@onready var full_button : Button = $"%FULL-BUTTON"
@onready var inspect_button : Button = $"%INSPECT-BUTTON"

func set_metadata(metadata : PackMetadata) -> void:
	title_label.text = metadata.name
	image_trect.texture = metadata.image
	type_label.text = metadata.type
	
