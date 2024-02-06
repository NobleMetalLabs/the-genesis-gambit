class_name UIFullPack
extends Control

@onready var title_label : Label = $"%TITLE-LABEL"
@onready var image_trect : TextureRect = $"%IMAGE"
@onready var type_label : Label = $"%TYPE-LABEL"
@onready var full_button : Button = $"%FULL-BUTTON"
@onready var inspect_button : Button = $"%INSPECT-BUTTON"
var _metadata : PackMetadata

@export var view_pack_popup_scn : PackedScene

func set_metadata(metadata : PackMetadata) -> void:
	_metadata = metadata
	title_label.text = metadata.name
	image_trect.texture = metadata.image
	type_label.text = metadata.type

func _ready() -> void:
	inspect_button.pressed.connect(
		func() -> void:
			var new_view_popup : PopupPanel = view_pack_popup_scn.instantiate()
			add_child(new_view_popup, true)
			new_view_popup.show_with_metadata(_metadata)
	)
