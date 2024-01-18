class_name CardInstanceInHand
extends CardInstance

@onready var texture_rect : TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.texture = metadata.image

func _setup(_metadata : CardMetadata) -> void:
	metadata = _metadata
