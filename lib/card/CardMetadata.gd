@icon("res://lib/card/CardMetadata.png")
class_name CardMetadata
extends Resource

var id : int
@export_group("Characteristics")
@export var name : String
@export var type : Genesis.CardType = Genesis.CardType.INSTANT
@export var rarity : Genesis.CardRarity = Genesis.CardRarity.COMMON
@export var image : Texture
@export var logic_script : GDScript = preload("res://ast/game/cards/logic/src/Nothing.gd")
@export_group("Stats")
@export var health : int
@export var strength : int
@export var speed : int
@export var energy : int
