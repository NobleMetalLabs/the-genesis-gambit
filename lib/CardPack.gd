class_name CardPack
extends Resource

@export var name : String
@export var image : Texture
@export var cards : Array[CardMetadata]
@export_enum("Common", "Rare", "Mythic", "Epic") var rarity: String = "Common"
