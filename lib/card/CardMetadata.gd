@icon("res://lib/card/CardMetadata.png")
class_name CardMetadata
extends Resource

@export_group("Characteristics")
@export var id : int
@export var logic_script : GDScript = preload("res://ast/game/cards/logic/Nothing.gd")
@export var name : String
@export var image : Texture
@export_enum("Instant", "Attacker", "Support") var type : String
@export_enum("Common", "Rare", "Mythic", "Epic") var rarity: String = "Common"
@export_group("Stats")
@export var cost : int
@export var hp : int
@export var power : int
@export var defense : int
