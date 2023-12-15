@icon("res://lib/CardMetadata.png")
class_name CardMetadata
extends Resource

@export_group("Caracteristics")
@export var id : int
@export var name : String
@export var description : String
@export var image : Texture
@export_enum("Common", "Rare", "Mythic", "Epic") var rarity: String = "Common"
@export_group("Stats")
@export var cost : int
@export var hp : int
@export var power : int
@export var defense : int
@export_group("Logic")
@export var logic_script : GDScript