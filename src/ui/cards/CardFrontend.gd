class_name CardFrontend
extends TextureRect

static var scn : PackedScene = preload("res://scn/ui/CardFrontend.tscn")
static func instantiate() -> CardFrontend:
	return scn.instantiate()

static var back_img : Texture = preload("res://ast/game/cards/fgs/back.png")
var card_instance : ICardInstance

@onready var border_component : CardBorderComponent = $CardBorderComponent

func _ready() -> void:
	self.set_anchors_preset(PRESET_CENTER)

	card_instance = get_parent().card_backend
	self.texture = card_instance.metadata.image
	
	border_component.set_rarity(card_instance.metadata.rarity)

func _process(_delta : float) -> void:
	self.size = self.get_combined_minimum_size()

func set_visibility(face : bool, rarity : bool, _type : bool) -> void:
	if face:
		self.texture = card_instance.metadata.image
	else:
		self.texture = back_img
	
	if rarity:
		border_component.set_rarity(card_instance.metadata.rarity)
	else:
		border_component.set_rarity(Genesis.CardRarity.COMMON)
	
	#if _type:
