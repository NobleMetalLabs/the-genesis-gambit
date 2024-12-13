@icon("res://lib/card/CardMetadata.png")
class_name CardMetadata
extends Serializeable

static var nothing_script : GDScript = preload("res://ast/game/cards/logic/src/Nothing.gd")

@export_group("DO NOT TICH >:(")
@export var id : int
@export var tribe : Genesis.CardTribe = Genesis.CardTribe.NONE
@export_group("Characteristics")
@export var name : String
@export var type : Genesis.CardType = Genesis.CardType.INSTANT
@export var rarity : Genesis.CardRarity = Genesis.CardRarity.COMMON
@export var image : Texture = preload("res://ast/game/cards/fgs/unknown.png")
@export var logic_script : GDScript = preload("res://ast/game/cards/logic/src/Nothing.gd")
@export_group("Stats")
@export var health : int = -1
@export var strength : int = -1
@export var speed : int = -1
@export var energy : int = -1

func _to_string() -> String:
	return "CardMetadata<%s>[%s]" % [id, name]
