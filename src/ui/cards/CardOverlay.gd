class_name CardOverlay
extends Control

@onready var _cooldown_bar : TextureProgressBar = $CooldownTprogbar
@onready var _marked_trect : TextureRect = $MarkedTrect
@onready var _frozen_trect : TextureRect = $FrozenTrect

func set_cooldown_bar_value(value : float) -> void:
	_cooldown_bar.value = value

func set_overlays(is_marked : bool, is_frozen : bool) -> void:
	set_marked(is_marked)
	set_frozen(is_frozen)

func set_marked(is_marked : bool) -> void:
	_marked_trect.set_visible(is_marked)

func set_frozen(is_frozen : bool) -> void:
	_frozen_trect.set_visible(is_frozen)