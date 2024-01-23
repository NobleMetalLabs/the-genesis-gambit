class_name UIFullCard
extends Control

@onready var title_label : Label = $"%TITLE-LABEL"
@onready var image_trect : TextureRect = $"%IMAGE"
@onready var type_label : Label = $"%TYPE-LABEL"
@onready var description_label : Label = $"%DESC-LABEL"

func set_metadata(metadata : CardMetadata) -> void:
	title_label.text = metadata.name
	image_trect.texture = metadata.image
	type_label.text = metadata.type
	description_label.text = metadata.description
