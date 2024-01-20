class_name CardPack
extends Resource

@export var cards : Array[CardMetadata]
@export_enum("Common", "Rare", "Mythic", "Epic") var rarity: String = "Common"
