@icon("res://lib/card/CardMetadata.png")
class_name CardMetadata
extends Resource

signal value_changed # emit when a property is changed to trigger ui to refresh
# used when a card modifies a property of another card for sum reason

var id : int
var tribe : Genesis.CardTribe = Genesis.CardTribe.NONE
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
