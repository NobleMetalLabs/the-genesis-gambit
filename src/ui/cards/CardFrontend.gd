class_name CardFrontend
extends TextureRect

static var scn : PackedScene = preload("res://scn/ui/CardFrontend.tscn")
static func instantiate() -> CardFrontend:
	return scn.instantiate()

static var back_img : Texture = preload("res://ast/game/cards/fgs/back.png")
var card_instance : ICardInstance

signal update_requested()

@onready var border_component : CardBorder = $CardBorder
@onready var overlay_component : CardOverlay = $CardOverlay

func _ready() -> void:
	card_instance = get_parent().get("card_backend")
	set_card(card_instance)

func set_card(card : ICardInstance) -> void:
	if card == null: return
	card_instance = card
	self.texture = card_instance.metadata.image
	border_component.set_rarity(card_instance.metadata.rarity)

var is_face_visible : bool = true
func set_visibility(face : bool, rarity : bool, _type : bool) -> void:
	if card_instance == null: return

	is_face_visible = face
	if face:
		self.texture = card_instance.metadata.image
	else:
		self.texture = back_img
	
	if rarity:
		border_component.set_rarity(card_instance.metadata.rarity)
	else:
		border_component.set_rarity(Genesis.CardRarity.COMMON)
	
	#if _type:

func set_overlays(is_marked : bool, is_frozen : bool) -> void:
	overlay_component.set_overlays(is_marked, is_frozen)

func set_cooldown_bar_value(type : Genesis.CooldownType, value : float) -> void:
	overlay_component.set_cooldown_bar_value(type, value)

func check_self_for_animation() -> void:
	var card_stats := IStatisticPossessor.id(card_instance)

	if card_stats.get_statistic(Genesis.Statistic.WAS_JUST_ACTIVATED):
		var flash_tween : Tween = Router.get_tree().create_tween()
		flash_tween.tween_property(self, "modulate", Color(0, 1, 0, 1), 0)
		flash_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)

	if card_stats.get_statistic(Genesis.Statistic.WAS_JUST_BURNED):
		var burn_tween : Tween = Router.get_tree().create_tween()
		burn_tween.tween_property(self, "modulate", Color(1, 0.4, 0, 1), 0.2)
		burn_tween.parallel().tween_interval(0.1)
		burn_tween.tween_property(self, "modulate", Color(0, 0, 0, 1), 0.3)
		burn_tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 1)

	set_overlays(
		card_stats.get_statistic(Genesis.Statistic.IS_MARKED) and is_face_visible,
		card_stats.get_statistic(Genesis.Statistic.IS_FROZEN)
	)

	var health : int = card_stats.get_statistic(Genesis.Statistic.HEALTH)
	if health > 0:
		var start_health : int = card_instance.metadata.health
		var damage_progress : float = (float(start_health) - health) / max(1, start_health)
		overlay_component.set_damage_bar_value(damage_progress)
	else:
		overlay_component.set_damage_bar_value(0)

	var sickness_cooldown : CooldownEffect = card_stats.get_cooldown_of_type(Genesis.CooldownType.SSICKNESS)
	if sickness_cooldown != null:
		var cooldown_length : int = sickness_cooldown.total_frames
		var cooldown_remaining : int = sickness_cooldown.frames
		var cooldown_progress : float = float(cooldown_remaining) / max(1, cooldown_length)
		
		set_cooldown_bar_value(Genesis.CooldownType.SSICKNESS, cooldown_progress)
	else:
		set_cooldown_bar_value(Genesis.CooldownType.SSICKNESS, 0)

		
	var attack_cooldown : CooldownEffect = card_stats.get_cooldown_of_type(Genesis.CooldownType.ATTACK)
	if attack_cooldown != null:
		var cooldown_length : int = attack_cooldown.total_frames
		var cooldown_remaining : int = attack_cooldown.frames
		var cooldown_progress : float = float(cooldown_remaining) / max(1, cooldown_length)
		
		set_cooldown_bar_value(Genesis.CooldownType.ATTACK, cooldown_progress)
	else:
		set_cooldown_bar_value(Genesis.CooldownType.ATTACK, 0)
		

	# TODO: make this work

	#var attack_swing_tween : Tween = Router.get_tree().create_tween()
	#attack_swing_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self.creature, "rotation_degrees", 20, 0.05)
	#attack_swing_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).tween_property(self.creature, "rotation_degrees", -20, 0.1)
	#attack_swing_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).tween_property(self.creature, "rotation_degrees", 0, 0.2)
	#var attack_grow_tween : Tween = Router.get_tree().create_tween()
	#attack_grow_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self.creature, "scale", Vector2.ONE * 1.05, 0.1)
	#attack_grow_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT).tween_property(self.creature, "scale", Vector2.ONE, 0.5)
#
	#var damage_flash_tween : Tween = Router.get_tree().create_tween()
	#damage_flash_tween.tween_property(self.target, "modulate", Color(1, 0, 0, 1), 0)
	#damage_flash_tween.tween_property(self.target, "modulate", Color(1, 1, 1, 1), 0.5)
