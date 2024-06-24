@icon("res://lib/card/CardMetadata.png")
class_name CardMetadata
extends Resource

@export_group("Characteristics")
@export var id : int
@export var name : String
@export var type : Genesis.CardType = Genesis.CardType.INSTANT
@export var rarity : Genesis.CardRarity = Genesis.CardRarity.COMMON
@export var image : Texture
@export var logic_script : GDScript = preload("res://ast/game/cards/logic/src/Nothing.gd")
@export_group("Stats")
@export var cost : int
@export var hp : int
@export var power : int
@export var defense : int
