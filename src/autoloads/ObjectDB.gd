class_name ObjectDB
extends Node

var CardInstanceOnField : GDScript = _CardInstanceOnField

class _CardInstanceOnField:
	const scene : PackedScene = preload("res://scn/game/CardInstanceOnField.tscn")
	static func create(gamefield : Gamefield, metadata : CardMetadata, player_owner : Player) -> CardInstanceOnField:
		var new_obj : CardInstanceOnField = scene.instantiate()
		new_obj._setup(gamefield, metadata, player_owner)
		return new_obj
