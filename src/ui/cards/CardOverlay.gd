class_name CardOverlay
extends Control

@export var marked_texture : Texture
@export var frozen_texture : Texture

var _marked_trect : TextureRect
var _frozen_trect : TextureRect

func _ready() -> void:
	_marked_trect = TextureRect.new()
	_marked_trect.texture = marked_texture
	_marked_trect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_marked_trect.set_visible(false)
	add_child(_marked_trect)
	_frozen_trect = TextureRect.new()
	_frozen_trect.texture = frozen_texture
	_frozen_trect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_frozen_trect.set_visible(false)
	add_child(_frozen_trect)

func set_overlays(is_marked : bool, is_frozen : bool) -> void:
	set_marked(is_marked)
	set_frozen(is_frozen)

func set_marked(is_marked : bool) -> void:
	_marked_trect.set_visible(is_marked)

func set_frozen(is_frozen : bool) -> void:
	_frozen_trect.set_visible(is_frozen)