class_name CardOverlay
extends Control

@onready var _ssickness_cooldown_bar : TextureProgressBar = $SSicknessCooldownBar
@onready var _attack_cooldown_bar : TextureProgressBar = $AttackCooldownBar
@onready var _damage_bar : TextureProgressBar = $DamageBar
@onready var _marked_trect : TextureRect = $MarkedTrect
@onready var _frozen_trect : TextureRect = $FrozenTrect

func set_cooldown_bar_value(type : Genesis.CooldownType, value : float) -> void:
	match(type):
		Genesis.CooldownType.SSICKNESS:
			_ssickness_cooldown_bar.value = value
		Genesis.CooldownType.ATTACK:
			_attack_cooldown_bar.value = value

func set_damage_bar_value(value : float) -> void:
	_damage_bar.value = value
	var eased_value : float = sin((value * PI) / 2)
	_damage_bar.self_modulate.a = eased_value

func set_overlays(is_marked : bool, is_frozen : bool) -> void:
	set_marked(is_marked)
	set_frozen(is_frozen)

func set_marked(is_marked : bool) -> void:
	_marked_trect.set_visible(is_marked)

func set_frozen(is_frozen : bool) -> void:
	_frozen_trect.set_visible(is_frozen)