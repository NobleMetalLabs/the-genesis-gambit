@icon("res://lib/CardMetadata.png")
class_name CardMetadata
extends Resource

@export_group("Characteristics")
@export var id : int
@export var name : String
var description : String : 
	get: return logic_script.new().description
@export var image : Texture
@export_enum("Instant", "Attacker", "Support") var type : String
@export_enum("Common", "Rare", "Mythic", "Epic") var rarity: String = "Common"
@export_group("Stats")
@export var cost : int
@export var hp : int
@export var power : int
@export var defense : int
@export_group("Logic")
@export var logic_script : GDScript
