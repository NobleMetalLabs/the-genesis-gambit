class_name HandCard
extends TextureButton

@export var metadata : CardMetadata

func _setup(_metadata : CardMetadata) -> void:
	metadata = _metadata

func _ready() -> void:
	texture_normal = metadata.image
