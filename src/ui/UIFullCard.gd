class_name UIFullCard
extends Control

@onready var title_label : Label = $"%TITLE-LABEL"
@onready var image_trect : TextureRect = $"%IMAGE"
@onready var type_label : Label = $"%TYPE-LABEL"
@onready var description_label : Label = $"%DESC-LABEL"
@onready var border_component : CardBorderComponent = $"%BORDER-COMPONENT"

func set_metadata(metadata : CardMetadata) -> void:
	title_label.text = metadata.name
	image_trect.texture = metadata.image
	type_label.text = str(metadata.type) #TODO this is wrong lol and also this entire class is kinda cooked
	description_label.text = metadata.logic_script.description
	border_component.set_rarity(metadata.rarity)
