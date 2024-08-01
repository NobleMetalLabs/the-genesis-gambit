class_name CardFrontend
extends TextureRect

static var scn : PackedScene = preload("res://scn/ui/CardFrontend.tscn")
static func instantiate() -> CardFrontend:
	return scn.instantiate()

static var back_img : Texture = preload("res://ast/game/cards/fgs/back.png")
var card_instance : ICardInstance

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

func set_cooldown_bar_value(value : float) -> void:
	overlay_component.set_cooldown_bar_value(value)

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

	if card_stats.get_statistic(Genesis.Statistic.IS_IN_COOLDOWN):
		var cooldown_length : int = card_stats.get_statistic(Genesis.Statistic.NUM_COOLDOWN_FRAMES_LENGTH)
		var cooldown_remaining : int = card_stats.get_statistic(Genesis.Statistic.NUM_COOLDOWN_FRAMES_REMAINING)
		var cooldown_progress : float = float(cooldown_remaining) / max(1, cooldown_length)
		set_cooldown_bar_value(cooldown_progress)
