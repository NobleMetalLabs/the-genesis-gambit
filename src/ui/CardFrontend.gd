class_name CardFrontend
extends TextureRect

static var scn : PackedScene = preload("res://scn/ui/CardFrontend.tscn")
static func instantiate() -> CardFrontend:
	return scn.instantiate()

func _ready() -> void:
	var card_instance : ICardInstance = ICardInstance.id(get_parent())
	self.texture = card_instance.metadata.image
	var border_component : CardBorderComponent = $CardBorderComponent
	border_component.set_rarity(card_instance.metadata.rarity)
	
