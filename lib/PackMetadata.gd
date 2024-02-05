class_name PackMetadata
extends Resource

@export var name : String
@export var image : Texture
@export var all_cards : Array[CardWithProbability]

@export_enum("Common", "Rare", "Mythic", "Epic") var rarity: String = "Common"
@export_enum("Instant", "Attacker", "Support") var type : String
